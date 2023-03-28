import fetchModules from './data-scraper.js';
import formatCourseData from './data-formater.js';
import { Course, Student } from './classes.js';
import { addCourse, addUser, getStudentId, updateStudent, addModule, addCourseModuleRel, addLecture, addExam } from './database.js';
import { verifyToken } from './authentication.js';
import util from 'util';
import fs from 'fs';
import express from 'express';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
app.use(express.json());
const port = process.env.PORT || 3000;

/**
 * POST /
 * Gets a course from Dualis and saves it to the database
 */
app.post('/', verifyToken, async (req, res) => {
    console.log('Request received');
    const time1 = performance.now();
    if (!req.secretaryId) {
        return;
    }
    if (!req.is('application/json')) {
        res.status(415).send('Invalid content type');
        return;
    }
    if (!req.body.courseName) {
        res.status(400).send('Invalid course data');
        return;
    }
    const course = new Course(req.body.courseName, req.secretaryId);
    for (const student of req.body.students) {
        if (!student.firstName || !student.lastName || !student.email || !student.password || !student.matriculationNr) {
            res.status(400).send('Invalid student data');
            return;
        }
        const newStudent = new Student(student.firstName, student.lastName, student.email, student.password, student.matriculationNr);
        course.appendStudent(newStudent);
    }
    const time2 = performance.now();
    console.log(`Time to setup and create course: ${time2 - time1}ms`);
    
    const requests = course.students.map(student => fetchModules(student));
    try {
        await Promise.all(requests);
    } catch (err) {
        if (err.message.includes('Login failed')) {
            res.status(400).send(err.message);
        } else {
            console.log(err);
            res.status(500).send('Internal server error');
        }
        return;
    }
    const time3 = performance.now();
    console.log(`Time to fetch modules: ${time3 - time2}ms`);

    await insertCourse(course);
    const time4 = performance.now();
    console.log(`Time to insert course: ${time4 - time3}ms`);

    fs.writeFileSync('course.json', JSON.stringify(course, null, 2));

    res.status(200).send('Hello World!');
    const time5 = performance.now();
    console.log(`Done! Overall Request time: ${time5 - time1}ms`);
});

/**
 * ALL /
 * Method not allowed
 */
app.all('/', (req, res) => {
    res.status(405).send('Method not allowed');
});

/**
 * ALL *
 * Not found
 */
app.all('*', (req, res) => {
    res.status(404).send('Not found');
});

/**
 * Start the server
 */
app.listen(port, () => {
    console.log(`Dualis API listening at http://localhost:${port}`);
});

/**
 * Inserts a course with all Students, Modules, Lectures and Exams into the database
 * @param {Course} course 
 */
const insertCourse = async (course) => {
    // Add the course to the database
    const courseId = await addCourse(course);
    course.setCourseId(courseId);

    // Add the students to the database
    const studentRequests = course.students.map(async (student) => {
        return new Promise(async (resolve, reject) => {
            // Add the user to the database
            const userId = await addUser(student);
            student.setUserId(userId);
            // Get auto generated student id
            const studentId = await getStudentId(userId);
            student.setStudentId(studentId);
            // Update the student in the database
            await updateStudent(course.courseId, student);
            resolve();
        });
    });
    await Promise.all(studentRequests);

    // Format the data to the database format
    formatCourseData(course);

    const moduleRequests = course.courseModules.map(async (module) => {
        return new Promise(async (resolve, reject) => {
            // Add the module to the database
            const moduleId = await addModule(module);
            // Add the relation between course and module to the database
            await addCourseModuleRel(course.courseId, moduleId);
            const lectureRequests = module.lectures.map(async (lecture) => {
                return new Promise(async (resolve, reject) => {
                    // Add the lecture to the database
                    const lectureId = await addLecture(moduleId, lecture);
                    const examRequests = lecture.exams.map(async (exam) => {
                        return new Promise(async (resolve, reject) => {
                            // Add the exam to the database
                            await addExam(exam, lectureId);
                            resolve();
                        });
                    });
                    await Promise.all(examRequests);
                    resolve();
                });
            });
            await Promise.all(lectureRequests);
            resolve();
        });
    });
    await Promise.all(moduleRequests);
}
