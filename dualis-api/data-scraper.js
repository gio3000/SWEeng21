import got from 'got';
import { JSDOM } from 'jsdom';
import { Student, Module, Lecture, Exam } from './classes.js';
import { gradeStringToPercentPoints, removeModuleDataDuplicates } from './helper.js';

/**
 * Logs a student in
 * @param {Student} student - Student to be logged in
 * @raises Error if login failed
 */
const login = async (student) => {
    const response = await got.post('https://dualis.dhbw.de/scripts/mgrqispi.dll', {
        form: {
            'usrname': student.email,
            'pass': student.password,
            'APPNAME': 'CampusNet',
            'PRGNAME': 'LOGINCHECK',
            'ARGUMENTS': 'clino,usrname,pass,menuno,menu_type,browser,platform',
            'clino': '000000000000001',
            'menuno': '000324',
            'menu_type': 'classic'
        }
    });
    try {
        student.dualisCredentials.cookie = response.headers['set-cookie'][0].split(';')[0].replace(' ', '');
        student.dualisCredentials.urlArguments = response.headers['refresh'].split('ARGUMENTS=')[1].split(',');
    } catch (error) {
        throw new Error(`Login failed for ${student.email}`);
    }
}

/**
 * Gets the semester arguments of a student
 * @param {Student} student - Student to get the semester arguments from 
 * @returns list of semester arguments
 */
const getSemesterArguments = async (student) => {
    const url = `https://dualis.dhbw.de/scripts/mgrqispi.dll?APPNAME=CampusNet&PRGNAME=COURSERESULTS&ARGUMENTS=${student.dualisCredentials.urlArguments.join(',')}`;
    const response = await got.get(url, {
        headers: {
            'Cookie': student.dualisCredentials.cookie
        }
    });

    let semesterArguments = [];

    const dom = new JSDOM(response.body);

    let semesterDropdown = dom.window.document.getElementsByTagName('option');
    for (const option of semesterDropdown) {
        semesterArguments.push(option.value);
    }

    return semesterArguments;
}

/**
 * Gets the module data of a student
 * @param {Student} student - Student to get the module data from
 * @param {string[]} semesterArguments - List of semester arguments
 * @returns list of module data
 */
const getModuleData = async (student, semesterArguments) => {
    const requests = semesterArguments.map(semesterArgument => {
        const url = `https://dualis.dhbw.de/scripts/mgrqispi.dll?APPNAME=CampusNet&PRGNAME=COURSERESULTS&ARGUMENTS=${student.dualisCredentials.urlArguments.slice(0, 2).join(',')},-N${semesterArgument}`;
        return got.get(url, {
            headers: {
                'Cookie': student.dualisCredentials.cookie
            }
        });
    });

    const responses = await Promise.all(requests);

    let moduleData = [];

    for (const response of responses) {
        const dom = new JSDOM(response.body);
        let tableBody = dom.window.document.getElementsByTagName('tbody')[0];
        let tableRows = tableBody.getElementsByTagName('tr');
        for (const tableRow of tableRows) {
            if (tableRow.innerHTML.includes('href')) {
                const module = {};
                module.path = tableRow.getElementsByTagName('script')[0].innerHTML.split('dl_popUp("')[1].split('"')[0];
                module.cts = parseInt(tableRow.getElementsByClassName('tbdata_numeric')[1].innerHTML.split(',')[0]);
                moduleData.push(module);
            }
        }
    }
    // Remove duplicates
    moduleData = removeModuleDataDuplicates(moduleData);
    return moduleData;
}

/**
 * Gets the modules of a student
 * @param {Student} student - Student to get the modules from
 * @param {string[]} moduleData - List of module data
 */
const getModules = async (student, moduleData) => {
    const requests = moduleData.map(moduleDataObj => {
        const url = `https://dualis.dhbw.de${moduleDataObj.path}`;
        return got.get(url, {
            headers: {
                'Cookie': student.dualisCredentials.cookie
            }
        });
    });

    const responses = await Promise.all(requests);

    for (let i = 0; i < responses.length; i++) {
        const response = responses[i];

        const dom = new JSDOM(response.body);

        const moduleName = dom.window.document.getElementsByTagName('h1')[0].innerHTML.split('&nbsp;\n')[1].split(' (')[0];
        const cts = moduleData[i].cts;
        const module = new Module(moduleName, cts);

        const table = dom.window.document.getElementsByTagName('table')[0];
        const tableRows = Array.from(table.getElementsByTagName('tr')).slice(3);

        if (tableRows[0].innerHTML.includes('Modulabschlussleistungen')) {
            if (tableRows[2].innerHTML.includes('Gesamt')) {
                // Modulabschlussleistungen mit nur einer Note
                const rowColumns1T = tableRows[1].getElementsByTagName('td');

                const lectureName = module.moduleName;
                const semester = rowColumns1T[0].innerHTML;
                const countsToAverage = true;

                const gradeString1T = rowColumns1T[3].innerHTML;
                const firstTry = gradeStringToPercentPoints(gradeString1T);

                const exam = new Exam(firstTry);

                // Parse second try
                if (tableRows.length > 6 && tableRows[3].innerHTML.includes('Versuch  2')) {
                    const rowColumns2T = tableRows[5].getElementsByTagName('td');
                    const gradeString2T = rowColumns2T[3].innerHTML;
                    const secondTry = gradeStringToPercentPoints(gradeString2T);
                    exam.addSecondTry(secondTry);
                }

                // Parse third try
                if (tableRows.length > 10 && tableRows[7].innerHTML.includes('Versuch  3')) {
                    const rowColumns3T = tableRows[9].getElementsByTagName('td');
                    const gradeString3T = rowColumns3T[3].innerHTML;
                    const thirdTry = gradeStringToPercentPoints(gradeString3T);
                    exam.addThirdTry(thirdTry);
                }

                const lecture = new Lecture(lectureName, semester, countsToAverage, exam);
                module.appendLecture(lecture);
            }
            else {
                // Modulabschlussleistungen mit mehreren Noten
                // TODO Parsen bei Versuch 2 machen
                const semester = tableRows[1].getElementsByTagName('td')[0].innerHTML;

                for (const row of tableRows.slice(2)) {
                    if (!row.innerHTML.includes('Gesamt')) {
                        let rowColumns1T = row.getElementsByTagName('td');

                        const lectureName = rowColumns1T[1].innerHTML.replaceAll('&nbsp;&nbsp;', '');
                        const countsToAverage = true;

                        const firstTry = parseInt(rowColumns1T[3].innerHTML.split(',')[0]);
                        const exam = new Exam(firstTry);

                        const lecture = new Lecture(lectureName, semester, countsToAverage, exam);
                        module.appendLecture(lecture);
                    }
                    else {
                        break;
                    }
                }
            }
        }
        else {
            // Modul mit mehreren getrennten Vorlesungen
            let tryCount = 1;
            for (let i = 0; i < tableRows.length / 2; i++) {
                let rowColumns = tableRows[i * 2 + 1]?.getElementsByTagName('td');

                // Check if row contains data
                if (rowColumns) {
                    if (rowColumns[0].innerHTML.includes('Versuch  2')) {
                        // Indicate that the next lectures are the second try
                        tryCount = 2;
                    }
                    else if (rowColumns[0].innerHTML.includes('Versuch  3')) {
                        // Indicate that the next lectures are the third try
                        tryCount = 3;
                    }
                    else {
                        // Indicates that this row contains a lecture
                        let found = false;

                        let lecture = {};
                        const lectureName = tableRows[i * 2].getElementsByTagName('td')[0].innerHTML.split(' ').slice(1).join(' ').split(' (')[0];
                        const semester = rowColumns[0].innerHTML;
                        let countsToAverage = true;
                        let exam = {};

                        // Check if lecture already exists when multiple tries
                        if (tryCount >= 2) {
                            module.lectures.forEach(lectureElem => {
                                if (lectureElem.lectureName === lectureName) {
                                    lecture = lectureElem;
                                    exam = lecture.exam;
                                    found = true;
                                }
                            });
                        }

                        // Parse grade
                        const gradeString = rowColumns[3].innerHTML;
                        const weightage = parseInt(rowColumns[1].innerHTML.split('(')[1].split('%)')[0]);
                        countsToAverage = weightage > 0;
                        let grade = gradeStringToPercentPoints(gradeString, weightage);

                        // Set exam grade
                        if (tryCount === 1 || !found || exam.first_try === grade) {
                            // Create new exam if it is the first try or if the exam does not exist yet or if the grade is the same as the first try (e.g. when the second lecture is not passed, then the first lecture is again displayed)
                            exam = new Exam(grade);
                        }
                        else if (tryCount === 2) {
                            exam.addSecondTry(grade);
                        }
                        else if (tryCount === 3) {
                            exam.addThirdTry(grade);
                        }
                        if (gradeString.includes('b')) {
                            // Modul/Prüfungsleistung ist bestanden aber hat keine Note, wird also nicht bewertet
                            countsToAverage = false;
                        }
                        if (!found) {
                            lecture = new Lecture(lectureName, semester, countsToAverage, exam);
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
        student.appendModule(module);
    }
}

/**
 * Fetches all modules of a student from dualis
 * @param {Student} student - The student to fetch the modules for
 */
const fetchModules = async (student) => {
    await login(student);
    const semesterArguments = await getSemesterArguments(student);
    const moduleData = await getModuleData(student, semesterArguments);
    await getModules(student, moduleData);
}

export default fetchModules;
