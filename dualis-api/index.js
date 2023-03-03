import fetchModules from './data-scraper.js';
import verifyCourse from './data-verifier.js';
import { Course, Student, Module, Lecture, Exam } from './classes.js';
import { getUser, getSecretary, addUser, addCourse, updateStudent, getStudentId } from './database.js';
import util from 'util';
import fs from 'fs';
import express from 'express';
import dotenv from 'dotenv';
import jwt from 'jsonwebtoken';

dotenv.config();

const app = express();
app.use(express.json());
const port = process.env.PORT || 3000;

const jwtKey = process.env.JWT_KEY;


/**
 * Middleware to verify the token
 * Sets the secretaryId in the request object
 */
const verifyToken = async (req, res, next) => {
    const token = req.headers.authorization;
    if (!token) {
        res.status(401).send('No token provided');
        return;
    }
    const secretaryId = await jwt.verify(token, jwtKey, async (err, decoded) => {
        if (err || !decoded.Email || !decoded.UserID) {
            res.status(403).send('Invalid token');
            return;
        }
        const user = await getUser(decoded.Email, decoded.UserID);
        if (!user || user.Role != 'Secretary') {
            res.status(403).send('Invalid token');
            return;
        }
        const sectretary = await getSecretary(user.UserID);
        if (!sectretary) {
            res.status(403).send('Invalid token');
            return;
        }
        return sectretary.SecretaryID;
    });
    if (!secretaryId) {
        return;
    }
    req.secretaryId = secretaryId;
    next();
}

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
    await Promise.all(requests);
    //console.log(util.inspect(course, false, null, true));
    fs.writeFileSync('course.json', JSON.stringify(course, null, 2));

    course.setCourseId(3);
    await course.students.forEach(async (student) => {
        const userId = await addUser(student);
        if (userId) {
            const studentId = await getStudentId(userId);
            student.setUserId(userId);
            console.log(userId);
            student.setStudentId(studentId);
            console.log(studentId);
            console.log(await updateStudent(course.courseId, student));
        }
    });

    res.status(200).send('Hello World!');
});

app.all('/', (req, res) => {
    res.status(405).send('Method not allowed');
});

app.all('*', (req, res) => {
    res.status(404).send('Not found');
});

app.listen(port, () => {
    console.log(`Dualis API listening at http://localhost:${port}`);
});
