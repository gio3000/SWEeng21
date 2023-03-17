import fetchModules from './data-scraper.js';
import verifyCourse from './data-verifier.js';
import { Course, Student, Module, Lecture, Exam } from './classes.js';
import { addUser, addCourse, updateStudent, getStudentId } from './database.js';
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
    const requests = course.students.map(student => fetchModules(student));
    try {
        await Promise.all(requests);
    } catch (err) {
        if (err.message.includes('Login failed')) {
            res.status(400).send(err.message);
        } else {
            res.status(500).send('Internal server error');
        }
        return;
    }
    //console.log(util.inspect(course, false, null, true));
    fs.writeFileSync('course.json', JSON.stringify(course, null, 2));

    course.setCourseId(3);
    const requests2 = course.students.map(async (student) => {
        return new Promise(async (resolve, reject) => {
            const userId = await addUser(student);
            if (userId) {
                const studentId = await getStudentId(userId);
                student.setUserId(userId);
                console.log(userId);
                student.setStudentId(studentId);
                console.log(studentId);
                console.log(await updateStudent(course.courseId, student));
            }
            resolve();
        });
    });
    await Promise.all(requests2);

    res.status(200).send('Hello World!');
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
