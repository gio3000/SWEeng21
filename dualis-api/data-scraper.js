import got from 'got';
import { gradeStringToPercentPoints, removeModuleDataDuplicates } from './helper.js';

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
    const url = `https://dualis.dhbw.de/scripts/mgrqispi.dll?APPNAME=CampusNet&PRGNAME=COURSERESULTS&ARGUMENTS=${credentials.arguments.join(',')}`;
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
    const requests = semesterArguments.map(semesterArgument => {
        const url = `https://dualis.dhbw.de/scripts/mgrqispi.dll?APPNAME=CampusNet&PRGNAME=COURSERESULTS&ARGUMENTS=${credentials.arguments.slice(0, 2).join(',')},-N${semesterArgument}`;
        return got.get(url, {
            headers: {
                'Cookie': credentials.cookie
            }
        });
    });
    const responses = await Promise.all(requests);
    for (const response of responses) {
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
    moduleData = removeModuleDataDuplicates(moduleData);
    return moduleData;
}

const getModules = async (credentials, moduleData) => {
    let modules = [];
    const requests = moduleData.map(moduleDataObj => {
        const url = `https://dualis.dhbw.de${moduleDataObj.argument}`;
        return got.get(url, {
            headers: {
                'Cookie': credentials.cookie
            }
        });
    });
    const responses = await Promise.all(requests);
    for (let i = 0; i < responses.length; i++) {
        const response = responses[i];
        let module = {};
        module.modulename = response.body.split('<h1>')[1].split('&nbsp;\r\n')[1].split(' (')[0];
        module.cts = moduleData[i].cts;
        module.lectures = [];

        let gradeTableRows = response.body.split('<table')[1].split('</table>')[0].replaceAll('\t', '').replaceAll('  ', '').split('</tr>');
        if (gradeTableRows[3].includes('Modulabschlussleistungen')) {
            if (gradeTableRows[5].includes('Gesamt')) {
                // Modulabschlussleistungen mit nur einer Note
                let rowColumns = gradeTableRows[4].split('</td>');
                let lecture = {};
                lecture.lecturename = module.modulename;
                lecture.semester = rowColumns[0].split('">')[1];
                lecture.countsToAverage = true;
                let exam = {};
                let gradeString = rowColumns[3].replaceAll('\r\n', '').split('>')[1];
                exam.first_try = gradeStringToPercentPoints(gradeString);
                exam.second_try = null;
                exam.third_try = null;
                if (gradeTableRows[6].includes('Versuch2')) {
                    rowColumns = gradeTableRows[8].split('</td>');
                    gradeString = rowColumns[3].replaceAll('\r\n', '').split('>')[1];
                    exam.second_try = gradeStringToPercentPoints(gradeString);
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
                        lecture.semester = semester;
                        lecture.countsToAverage = true;
                        let exam = {};
                        exam.first_try = parseInt(rowColumns[3].split('>')[1].split('<')[0].split(',')[0]);
                        exam.second_try = null;
                        exam.third_try = null;
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
            // TODO Parsen von Versuch 2 machen
            gradeTableRows = gradeTableRows.slice(3);
            let tryCount = 1;
            for (let i = 0; i < gradeTableRows.length / 2; i++) {
                // Check if lecture already exists when multiple tries
                let found = false;
                let lecture = {};
                lecture.lecturename = gradeTableRows[i * 2].split('">')[1].split(' ').slice(1).join(' ').split(' (')[0].split('</td>')[0];
                let exam = {};
                let rowColumns = gradeTableRows[i * 2 + 1].split('</td>');
                if (tryCount >= 2) {
                    module.lectures.forEach(lectureElem => {
                        if (lectureElem.lecturename === lecture.lecturename) {
                            lecture = lectureElem;
                            exam = lecture.exam;
                            found = true;
                        }
                    });
                }
                if (rowColumns.length > 1) {
                    lecture.semester = rowColumns[0].split('">')[1];
                    if (rowColumns[0].includes('Versuch2')) {
                        tryCount = 2;
                    }
                    else {
                        let gradeString = rowColumns[3].replaceAll('\r\n', '').split('>')[1];
                        const weightage = parseInt(rowColumns[1].split('(')[1].split('%)')[0]);
                        lecture.countsToAverage = weightage > 0;
                        let grade = gradeStringToPercentPoints(gradeString, weightage);
                        if (tryCount === 1 || !found || exam.first_try === grade) {
                            exam.first_try = grade;
                            exam.second_try = null;
                            exam.third_try = null;
                        }
                        else if (tryCount === 2) {
                            exam.second_try = grade;
                        }
                        if (gradeString.includes('b')) {
                            // Modul/Prüfungsleistung ist bestanden aber hat keine Note, wird also nicht bewertet
                            // TODO Besseren Weg finden um festzuhalten
                            lecture.countsToAverage = false;
                        }
                        lecture.exam = exam;
                        if (tryCount === 1) {
                            module.lectures.push(lecture);
                        }
                    }
                }
            }
        }
        // set countsToAverage to false if module is not graded
        if (module.cts === 0) {
            for (let lecture of module.lectures) {
                lecture.countsToAverage = false;
            }
        }
        modules.push(module);
    }
    return modules;
}

const fetch = async (credentials) => {
    credentials = await login(credentials);
    const semesterArguments = await getSemesterArguments(credentials);
    const moduleData = await getModuleData(credentials, semesterArguments);
    const modules = await getModules(credentials, moduleData);
    return modules;
}

export default fetch;
