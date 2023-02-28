import fetch from './data-scraper.js';
import verifyCourse from './data-verifier.js';
import { Course, Student, Module, Lecture, Exam } from './classes.js';
import fs from 'fs';
import express from 'express';
import dotenv from 'dotenv';
import mysql from 'mysql2/promise';
import jwt from 'jsonwebtoken';

dotenv.config();

const app = express();
app.use(express.json());
const port = process.env.PORT || 3000;

const jwtKey = process.env.JWT_KEY;

const connection = await mysql.createConnection({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE
});

app.get('/', (req, res) => {
    // get token from authentication header
    const token = req.headers.authorization;
    if (!token) {
        res.status(401).send('No token provided');
        return;
    }
    jwt.verify(token, jwtKey, async (err, decoded) => {
        if (err) {
            res.status(401).send('Invalid token');
            return;
        }
        const email = decoded.email;
        const [user] = await connection.execute('SELECT * FROM User WHERE Email = ?', [email]);
        if (user.length === 0) {
            res.status(401).send('Invalid token');
            return;
        }
        if (user[0].Role !== 'Secretary') {
            res.status(403).send('Invalid token');
            return;
        }
        if (!req.is('application/json')) {
            res.status(400).send('Invalid content type');
            return;
        }
        if (!req.body.courseName) {
            res.status(400).send('Invalid course data');
            return;
        }
        const [sectretary] = await connection.execute('SELECT SecretaryID FROM Secretary WHERE UserID = ?', [user[0].UserID]);
        if (sectretary.length === 0) {
            res.status(403).send('Invalid token');
            return;
        }
        const course = new Course(req.body.courseName, sectretary[0].SecretaryID);
        for (const student of req.body.students) {
            if (!student.firstName || !student.lastName || !student.email || !student.password || !student.matriculationNr) {
                res.status(400).send('Invalid student data');
                return;
            }
            const newStudent = new Student(student.firstName, student.lastName, student.email, student.password, student.matriculationNr);
            course.appendStudent(newStudent);
        }
        console.log(course);
        res.send('Hello World!');
    });
});

app.listen(port, () => {
    console.log(`Dualis API listening at http://localhost:${port}`);
});

/*
const credentials = JSON.parse(fs.readFileSync('credentials.json', 'utf8'));

const requests = credentials.map(credentials => fetch(credentials));
const modules = await Promise.all(requests);

fs.writeFileSync('modules.json', JSON.stringify(modules, null, 2));

console.log(verifyCourse(modules));
*/
