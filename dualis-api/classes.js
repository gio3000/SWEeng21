import crypto from 'crypto';

/**
 * Represents a course
 * @class
 * @param {string} courseName - Name of the course
 * @param {number} secretaryId - Id of the secretary
 * @param {Student[]} students - List of students
 */
class Course {
    constructor(courseName, secretaryId) {
        this.courseName = courseName;
        this.secretaryId = secretaryId;
        this.students = [];
    }

    /**
     * Adds a student to the course
     * @param {Student} student - Student to be added to the course
     */
    appendStudent(student) {
        this.students.push(student);
    }
}

/**
 * Represents a student
 * @class
 * @param {string} firstName - First name of the student
 * @param {string} lastName - Last name of the student
 * @param {string} role - Role of the user (always 'Student')
 * @param {string} email - Email of the student
 * @param {string} password - Password of the student
 * @param {number} hashcount - Number of times the password is hashed
 * @param {string} salt - Salt for the password
 * @param {string} hash - Hashed password
 * @param {string} matriculationNumber - Matriculation number of the student
 * @param {Module[]} modules - List of modules
 */
class Student {
    constructor(firstName, lastName, email, password, matriculationNumber) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.role = 'Student';
        this.email = email;
        this.password = password;
        this.salt = crypto.randomBytes(16).toString('hex');
        this.hashcount = Math.floor(Math.random() * 1000) + 1;
        for (let i = 0; i < this.hashcount; i++) {
            this.hash = crypto.createHmac('sha256', this.salt).update(this.password).digest('hex');
        }
        this.matriculationNumber = matriculationNumber;
        this.modules = [];
    }

    /**
     * Adds a module to the student
     * @param {Module} module - Module to be added to the student
     */
    appendModule(module) {
        this.modules.push(module);
    }
}

/**
 * Represents a module
 * @class
 * @param {string} moduleName - Name of the module
 * @param {string} cts - CTS of the module
 * @param {Lecture[]} lectures - List of lectures
 */
class Module {
    constructor(moduleName, cts) {
        this.moduleName = moduleName;
        this.cts = cts;
        this.lectures = [];
    }

    /**
     * Adds a lecture to the module
     * @param {Lecture} lecture - Lecture to be added to the module
     */
    appendLecture(lecture) {
        this.lectures.push(lecture);
    }
}

/**
 * Represents a lecture
 * @class
 * @param {string} lectureName - Name of the lecture
 * @param {string} semester - Semester of the lecture
 * @param {boolean} countsToAverage - Whether the lecture counts to the average
 * @param {Exam} exam - Exam of the lecture
 */
class Lecture {
    constructor(lectureName, semester, countsToAverge, exam) {
        this.lectureName = lectureName;
        this.semester = semester;
        this.countsToAverage = countsToAverge;
        this.exam = exam;
    }
}

/**
 * Represents an exam
 * @class
 * @param {number} firstTry - First try of the exam
 * @param {number} secondTry - Second try of the exam
 * @param {number} thirdTry - Third try of the exam
 */
class Exam {
    constructor(firstTry) {
        this.firstTry = firstTry;
        this.secondTry = null;
        this.thirdTry = null;
    }

    /**
     * Adds a second try to the exam
     * @param {number} secondTry - Second try of the exam
     */
    addSecondTry(secondTry) {
        this.secondTry = secondTry;
    }

    /**
     * Adds a third try to the exam
     * @param {number} thirdTry - Third try of the exam
     */
    addThirdTry(thirdTry) {
        this.thirdTry = thirdTry;
    }
}

export { Course, Student, Module, Lecture, Exam };
