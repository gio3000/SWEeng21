import mysql from 'mysql2/promise';
import dotenv from 'dotenv';

dotenv.config();

const connection = await mysql.createConnection({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE
});

/**
 * Gets a user from the database
 * @param {string} email - Email address of the user
 * @param {number} userid - UserID of the user
 * @returns User object or null
 */
const getUser = async (email, userid) => {
    return connection.execute('SELECT * FROM User WHERE Email = ? AND UserID = ?', [email, userid]).then(([user]) => {
        if (user.length !== 1) {
            return null;
        }
        return user[0];
    }).catch((err) => {
        console.log(err);
        return null;
    });
}

/**
 * Gets a secretary from the database
 * @param {number} userid - UserID of the secretary
 * @returns Secretary object or null
 */
const getSecretary = async (userid) => {
    return connection.execute('SELECT SecretaryID FROM Secretary WHERE UserID = ?', [userid]).then(([secretary]) => {
        if (secretary.length !== 1) {
            return null;
        }
        return secretary[0];
    }).catch((err) => {
        console.log(err);
        return null;
    });
}

/**
 * Adds a course to the database
 * @param {Course} course - Course object
 * @returns CourseID or null
 */
const addCourse = async (course) => {
    return connection.execute('INSERT INTO Course (Coursename, SecretaryID) VALUES (?, ?)', [course.courseName, course.secretaryId]).then((result) => {
        return result[0].insertId;
    }).catch((err) => {
        console.log(err);
        return null;
    });
}

/**
 * Adds a user to the database
 * @param {Student} user - User object
 * @returns UserID or null
 */
const addUser = async (user) => {
    return connection.execute('INSERT INTO User (First_Name, Last_Name, Role, Email, Password, Salt, Hash_Count) VALUES (?, ?, ?, ?, ?, ?, ?)', [user.firstName, user.lastName, user.role, user.email, user.hash, user.salt, user.hashcount]).then((result) => {
        return result[0].insertId;
    }).catch((err) => {
        console.log(err);
        return null;
    });
}

/**
 * Gets the automatically generated student id from the database
 * @param {number} userId - UserID of the student
 * @returns StudentID or null
 */
const getStudentId = async (userId) => {
    return connection.execute('SELECT StudentID FROM Student WHERE UserID = ?', [userId]).then(([student]) => {
        if (student.length !== 1) {
            return null;
        }
        return student[0].StudentID;
    }).catch((err) => {
        console.log(err);
        return null;
    });
}

/**
 * Updates the automatically generated student in the database
 * @param {number} courseId - CourseID of the course
 * @param {Student} student - Student object
 * @returns true or null
 */
const updateStudent = async (courseId, student) => {
    return connection.execute('UPDATE Student SET CourseID = ?, MatriculationNr = ? WHERE UserID = ? AND StudentID = ?', [courseId, student.matriculationNumber, student.userId, student.studentId]).then((result) => {
        return (result[0].affectedRows === 1);
    }).catch((err) => {
        console.log(err);
        return null;
    });
}

/**
 * Adds a module to the database
 * @param {CourseModule} module - Module object
 * @returns ModuleID or null
 */
const addModule = async (module) => {
    return connection.execute('INSERT INTO Module (Modulename, CTS) VALUES (?, ?)', [module.moduleName, module.cts]).then((result) => {
        return result[0].insertId;
    }).catch((err) => {
        console.log(err);
        return null;
    });
}

/**
 * Adds a course-module relationship to the database
 * @param {number} courseId - CourseID of the course
 * @param {number} moduleId - ModuleID of the module
 * @returns true or null
 */
const addCourseModuleRel = async (courseId, moduleId) => {
    return connection.execute('INSERT INTO CourseModuleRel (CourseID, ModuleID) VALUES (?, ?)', [courseId, moduleId]).then((result) => {
        return result[0].insertId;
    }).catch((err) => {
        console.log(err);
        return null;
    });
}

/**
 * Adds a lecture to the database
 * @param {number} moduleId - ModuleID of the module
 * @param {CourseLecture} lecture - Lecture object
 * @returns LectureID or null
 */
const addLecture = async (moduleId, lecture) => {
    return connection.execute('INSERT INTO Lecture (ModuleID, Lecturename, CountsToAverage, Semester) VALUES (?, ?, ?, ?)', [moduleId, lecture.lectureName, lecture.countsToAverage, lecture.semester]).then((result) => {
        return result[0].insertId;
    }).catch((err) => {
        console.log(err);
        return null;
    });
}

/**
 * Adds an exam to the database
 * @param {CourseExam} exam - Exam object
 * @returns ExamID or null
 */
const addExam = async (exam) => {
    return connection.execute('INSERT INTO Exam (StudentID, LectureID, First_Try, First_Try, First_Try) VALUES (?, ?, ?, ?, ?)', [exam.studentId, lectureId, exam.firstTry, exam.secondTry, exam.thirdTry]).then((result) => {
        return result[0].insertId;
    }).catch((err) => {
        console.log(err);
        return null;
    });
}

export { getUser, getSecretary, addCourse, addUser, getStudentId, updateStudent, addModule, addCourseModuleRel, addLecture, addExam };
