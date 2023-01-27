import got from 'got';
import util from 'util';
import fs from 'fs';

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

const getModuleArguments = async (credentials, semesterArguments) => {
    let moduleArguments = [];
    for (const semesterArgument of semesterArguments) {
        let url = `https://dualis.dhbw.de/scripts/mgrqispi.dll?APPNAME=CampusNet&PRGNAME=COURSERESULTS&ARGUMENTS=${credentials.arguments.slice(0, 2).join(',')},-N${semesterArgument}`;
        const response = await got.get(url, {
            headers: {
                'Cookie': credentials.cookie
            }
        });

        let modules = response.body.split('<tbody>')[1].split('</tbody>')[0].replaceAll('\t', '').replaceAll('  ', '').split('</tr>');
        for (const module of modules) {
            if (module.includes('href')) {
                moduleArguments.push(module.split('dl_popUp("')[1].split('"')[0]);
            }
        }
    }

    // Remove duplicates
    moduleArguments = [...new Set(moduleArguments)];
    return moduleArguments;
}

const getModules = async (credentials, moduleArguments) => {
    let modules = [];
    for (const moduleArgument of moduleArguments) {
        let url = `https://dualis.dhbw.de${moduleArgument}`;
        const response = await got.get(url, {
            headers: {
                'Cookie': credentials.cookie
            }
        });

        let module = {};
        module.name = response.body.split('<h1>')[1].split('&nbsp;\r\n')[1].split(' (')[0];
        module.lectures = [];
        let gradeTableRows = response.body.split('<table')[1].split('</table>')[0].replaceAll('\t', '').replaceAll('  ', '').split('</tr>');
        if (gradeTableRows[3].includes('Modulabschlussleistungen')) {
            if (gradeTableRows[5].includes('Gesamt')) {
                // Modulabschlussleistungen mit nur einer Note
                let rowColumns = gradeTableRows[4].split('</td>');
                let lecture = {};
                lecture.name = module.name;
                let exam = {};
                let gradeString = rowColumns[3].replaceAll('\r\n', '').split('>')[1];
                if (gradeString.includes('noch nicht gesetzt')) {
                    exam = null;
                }
                else {
                    exam.semester = rowColumns[0].split('">')[1];
                    exam.grade = gradeToPercentPoints(parseFloat(gradeString));
                }
                lecture.exam = exam;
                module.lectures.push(lecture);
            }
            else {
                // Modulabschlussleistungen mit mehreren Noten
                let semester = gradeTableRows[4].split('</td>')[0].split('">')[1];
                for (let row of gradeTableRows.slice(5)) {
                    if (!row.includes('Gesamt')) {
                        let rowColumns = row.split('</td>');
                        let lecture = {};
                        lecture.name = rowColumns[1].split('&nbsp;&nbsp;')[1];
                        let exam = {};
                        exam.semester = semester;
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
            // console.log(gradeTableRows)
            for (let i = 0; i < gradeTableRows.length / 2; i++) {
                let lecture = {};
                lecture.name = gradeTableRows[i * 2].split('">')[1].split(' (')[0].split('</td>')[0];
                let exam = {};
                let rowColumns = gradeTableRows[i * 2 + 1].split('</td>');
                if (rowColumns.length >= 4) {
                    let gradeString = rowColumns[3].replaceAll('\r\n', '').split('>')[1];
                    if (gradeString.includes('noch nicht gesetzt')) {
                        exam = null;
                    }
                    else {
                        exam.semester = rowColumns[0].split('">')[1];
                        if (gradeString.includes('b')) {
                            exam.grade = 50;
                        }
                        else {
                            exam.grade = gradeToPercentPoints(parseFloat(rowColumns[3].replaceAll('\r\n', '').split('>')[1]));

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

const gradeToPercentPoints = (grade) => {
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
    return gradeConversion[grade];
}

const fetch = async (credentials) => {
    credentials = await login(credentials);
    const semesterArguments = await getSemesterArguments(credentials);
    const moduleArguments = await getModuleArguments(credentials, semesterArguments);
    const modules = await getModules(credentials, moduleArguments);
    console.log(util.inspect(modules, false, null, true /* enable colors */));
    fs.writeFileSync('modules.json', JSON.stringify(modules, null, 2));
}

export default fetch;
