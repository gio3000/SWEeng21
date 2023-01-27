import got from 'got';

const login = async (credentials) => {
    const response = await got.post('https://dualis.dhbw.de/scripts/mgrqispi.dll', {
        form: {
            'usrname': credentials.username,
            'pass': credentials.password,
            'APPNAME': 'CampusNet',
            'PRGNAME': 'LOGINCHECK',
            'ARGUMENTS': 'clino,usrname,pass,menuno,menu_type,browser,platform',
            'clino': '000000000000001',
            'menuno': '000324',
            'menu_type': 'classic'
        }
    });

    credentials.cookie = response.headers['set-cookie'][0].split(';')[0].replace(' ', '');
    credentials.arguments = response.headers['refresh'].split('ARGUMENTS=')[1].split(',');

    return credentials;
}

const getSemesterArguments = async (credentials) => {
    let url = `https://dualis.dhbw.de/scripts/mgrqispi.dll?APPNAME=CampusNet&PRGNAME=COURSERESULTS&ARGUMENTS=${credentials.arguments.join(',')}`;
    const response = await got.get(url, {
        headers: {
            'Cookie': credentials.cookie
        }
    });

    let semesterArguments = [];

    let semesterString = response.body.split('<select id="semester"')[1].split('</select>')[0].split('class="tabledata">')[1].replaceAll('\t', '').split('\r\n');
    for (let i = 0; i < semesterString.length; i++) {
        if (semesterString[i].includes('option')) {
            semesterArguments.push(semesterString[i].split('value="')[1].split('"')[0]);
        }
    }
    return semesterArguments;
}

const getModuleData = async (credentials, semesterArguments) => {
    let moduleData = [];
    for (const semesterArgument of semesterArguments) {
        let url = `https://dualis.dhbw.de/scripts/mgrqispi.dll?APPNAME=CampusNet&PRGNAME=COURSERESULTS&ARGUMENTS=${credentials.arguments.slice(0, 2).join(',')},-N${semesterArgument}`;
        const response = await got.get(url, {
            headers: {
                'Cookie': credentials.cookie
            }
        });

        let modules = response.body.split('<tbody>')[1].split('</tbody>')[0].replaceAll('\t', '').replaceAll('  ', '').split('</tr>');
        for (const moduleLine of modules) {
            if (moduleLine.includes('href')) {
                let module = {};
                module.argument = moduleLine.split('dl_popUp("')[1].split('"')[0];
                module.cts = parseInt(moduleLine.split('"tbdata_numeric">')[1].split('</td>')[0].split(',')[0]);
                moduleData.push(module);
            }
        }
    }
    // Remove duplicates
    // TODO Remove duplicates in a better way
    moduleData = [...new Set(moduleData)];
    return moduleData;
}

const getModules = async (credentials, moduleData) => {
    let modules = [];
    for (const moduleDataObj of moduleData) {
        let url = `https://dualis.dhbw.de${moduleDataObj.argument}`;
        const response = await got.get(url, {
            headers: {
                'Cookie': credentials.cookie
            }
        });

        let module = {};
        module.modulename = response.body.split('<h1>')[1].split('&nbsp;\r\n')[1].split(' (')[0];
        module.cts = moduleDataObj.cts;
        module.lectures = [];

        let gradeTableRows = response.body.split('<table')[1].split('</table>')[0].replaceAll('\t', '').replaceAll('  ', '').split('</tr>');
        if (gradeTableRows[3].includes('Modulabschlussleistungen')) {
            if (gradeTableRows[5].includes('Gesamt')) {
                // Modulabschlussleistungen mit nur einer Note
                let lecture = {};
                lecture.lecturename = module.modulename;
                let exam = {};
                let rowColumns = gradeTableRows[4].split('</td>');
                if (gradeTableRows[6].includes('Versuch2')) {
                    rowColumns = gradeTableRows[8].split('</td>');
                }
                let gradeString = rowColumns[3].replaceAll('\r\n', '').split('>')[1];
                if (gradeString.includes('noch nicht gesetzt')) {
                    exam = null;
                }
                else {
                    exam.semester = rowColumns[0].split('">')[1];
                    exam.countsToAverage = true;
                    exam.grade = gradeStringToPercentPoints(gradeString);
                }
                lecture.exam = exam;
                module.lectures.push(lecture);
            }
            else {
                // Modulabschlussleistungen mit mehreren Noten
                // TODO Parsen bei Versuch 2 machen
                let semester = gradeTableRows[4].split('</td>')[0].split('">')[1];
                for (let row of gradeTableRows.slice(5)) {
                    if (!row.includes('Gesamt')) {
                        let rowColumns = row.split('</td>');
                        let lecture = {};
                        lecture.lecturename = rowColumns[1].split('&nbsp;&nbsp;')[1];
                        let exam = {};
                        exam.semester = semester;
                        exam.countsToAverage = true;
                        exam.grade = parseInt(rowColumns[3].split('> ')[1].split('<')[0].split(',')[0]);
                        lecture.exam = exam;
                        module.lectures.push(lecture);
                    }
                    else {
                        break;
                    }
                }
            }
        }
        else {
            // Modul mit mehreren getrennten Vorlesungen
            gradeTableRows = gradeTableRows.slice(3);
            for (let i = 0; i < gradeTableRows.length / 2; i++) {
                let lecture = {};
                lecture.lecturename = gradeTableRows[i * 2].split('">')[1].split(' ').slice(1).join(' ').split(' (')[0].split('</td>')[0];
                let exam = {};
                let rowColumns = gradeTableRows[i * 2 + 1].split('</td>');
                if (rowColumns.length > 1) {
                    if (rowColumns[0].includes('Versuch2')) {
                        module.lectures = [];
                    }
                    else {
                        let gradeString = rowColumns[3].replaceAll('\r\n', '').split('>')[1];
                        if (gradeString.includes('noch nicht gesetzt')) {
                            exam = null;
                        }
                        else {
                            exam.semester = rowColumns[0].split('">')[1];
                            if (gradeString.includes('b')) {
                                // Modul/Prüfungsleistung ist bestanden aber hat keine Note, wird also nicht bewertet
                                // TODO Besseren Weg finden um festzuhalten
                                exam.countsToAverage = false;
                                exam.grade = 50;
                            }
                            else {
                                const weightage = parseInt(rowColumns[1].split('(')[1].split('%)')[0]);
                                exam.countsToAverage = weightage > 0;
                                exam.grade = Math.round(gradeStringToPercentPoints(gradeString) * weightage / 100);
                            }
                        }
                        lecture.exam = exam;
                        module.lectures.push(lecture);
                    }
                }
            }
        }
        modules.push(module);
    }
    return modules;
}

const gradeStringToPercentPoints = (gradeString) => {
    const gradeConversion = {
        1.0: 100,
        1.1: 97,
        1.2: 95,
        1.3: 93,
        1.4: 92,
        1.5: 90,
        1.6: 89,
        1.7: 87,
        1.8: 86,
        1.9: 84,
        2.0: 82,
        2.1: 81,
        2.2: 79,
        2.3: 77,
        2.4: 76,
        2.5: 74,
        2.6: 73,
        2.7: 71,
        2.8: 70,
        2.9: 68,
        3.0: 66,
        3.1: 65,
        3.2: 63,
        3.3: 61,
        3.4: 60,
        3.5: 58,
        3.6: 57,
        3.7: 55,
        3.8: 54,
        3.9: 52,
        4.0: 50,
        4.1: 49,
        4.2: 47,
        4.3: 45,
        4.4: 44,
        4.5: 42,
        4.6: 41,
        4.7: 39,
        4.8: 38,
        4.9: 36,
        5.0: 34
    }
    const grade = parseFloat(gradeString.replace(',', '.'))
    return gradeConversion[grade];
}

const fetch = async (credentials) => {
    credentials = await login(credentials);
    const semesterArguments = await getSemesterArguments(credentials);
    const moduleData = await getModuleData(credentials, semesterArguments);
    const modules = await getModules(credentials, moduleData);
    return modules;
}

export default fetch;
