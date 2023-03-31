import crypto from 'crypto';

/**
 * Represents a course
 * @class
 * @param {string} courseName - Name of the course
 * @param {number} secretaryId - Id of the secretary
 * @param {Student[]} students - List of students
 * @param {CourseModule[]} courseModules - List of course modules
 */
class Course {
    constructor(courseName, secretaryId) {
        this.courseName = courseName;
        this.secretaryId = secretaryId;
        this.students = [];
        this.courseModules = [];
    }

    /**
     * Adds a student to the course
     * @param {Student} student - Student to be added to the course
     */
    appendStudent(student) {
        this.students.push(student);
    }

    /**
     * Sets the course id from the database
     * @param {number} courseId 
     */
    setCourseId(courseId) {
        this.courseId = courseId;
    }

    /**
     * Adds a course module to the course
     * @param {CourseModule} courseModule - Course module to be added to the course
     */
    appendCourseModule(courseModule) {
        this.courseModules.push(courseModule);
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
 * @param {number} userId - Id of the user in the database
 * @param {number} studentId - Id of the student in the database
 * @param {DualisModule[]} modules - List of dualis modules
 * @param {Object} dualisCredentials - Dualis credentials of the student
 */
class Student {
    constructor(firstName, lastName, email, password, matriculationNumber) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.role = 'Student';
        this.email = email;
        this.password = password;
        this.salt = crypto.randomBytes(16).toString('hex');
        this.hashcount = Math.floor(Math.random() * 20) + 1;
        for (let i = 0; i < this.hashcount; i++) {
            this.hash = crypto.createHmac('sha256', this.salt).update(this.password).digest('hex');
        }
        this.matriculationNumber = matriculationNumber;
        this.userId = null;
        this.studentId = null;
        this.dualisModules = [];
        this.dualisCredentials = { cookie: '', urlArguments: [] };
    }

    /**
     * Adds a module to the student
     * @param {DualisModule} dualisModule - Module to be added to the student
     */
    appendDualisModule(dualisModule) {
        this.dualisModules.push(dualisModule);
    }

    /**
     * Sets the dualis credentials of the student
     * @param {string} cookie - Cookie of the student
     * @param {string[]} urlArguments - UrlArguments of the student
     */
    setDualisCredentials(cookie, urlArguments) {
        this.dualisCredentials = { cookie, urlArguments };
    }

    /**
     * Sets the user id from the database
     * @param {number} userId
     */
    setUserId(userId) {
        this.userId = userId;
    }

    /**
     * Sets the student id from the database
     * @param {number} studentId
     */
    setStudentId(studentId) {
        this.studentId = studentId;
    }
}

/**
 * Represents a module from dualis
 * @class
 * @param {string} moduleName - Name of the module
 * @param {string} cts - CTS of the module
 * @param {DualisLecture[]} lectures - List of lectures
 */
class DualisModule {
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
 * Represents a lecture from dualis
 * @class
 * @param {string} lectureName - Name of the lecture
 * @param {string} semester - Semester of the lecture
 * @param {boolean} countsToAverage - Whether the lecture counts to the average
 * @param {DualisExam} exam - Exam of the lecture
 */
class DualisLecture {
    constructor(lectureName, semester, countsToAverge, exam) {
        this.lectureName = lectureName;
        this.semester = semester;
        this.countsToAverage = countsToAverge;
        this.exam = exam;
    }
}

/**
 * Represents an exam from dualis
 * @class
 * @param {number} firstTry - First try of the exam
 * @param {number} secondTry - Second try of the exam
 * @param {number} thirdTry - Third try of the exam
 */
class DualisExam {
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

/**
 * Represents a module for the course
 * @class
 * @param {string} moduleName - Name of the module
 * @param {string} cts - CTS of the module
 * @param {CourseLecture[]} lectures - List of lectures
 */
class CourseModule {
    constructor(moduleName, cts) {
        this.moduleName = moduleName;
        this.cts = cts;
        this.lectures = [];
    }

    /**
     * Adds a lecture to the module
     * @param {CourseLecture} lecture - Lecture to be added to the module
     */
    appendLecture(lecture) {
        this.lectures.push(lecture);
    }
}

/**
 * Represents a lecture for the course
 * @class
 * @param {string} lectureName - Name of the lecture
 * @param {string} semester - Semester of the lecture
 * @param {boolean} countsToAverage - Whether the lecture counts to the average
 * @param {CourseExam[]} exams - List of exams
 */
class CourseLecture {
    constructor(lectureName, semester, countsToAverge) {
        this.lectureName = lectureName;
        this.semester = semester;
        this.countsToAverage = countsToAverge;
        this.exams = [];
    }

    /**
     * Adds an exam to the lecture
     * @param {CourseExam} exam - Exam to be added to the lecture
     */
    appendExam(exam) {
        this.exams.push(exam);
    }
}

/**
 * Represents an exam for the course
 * @class
 * @param {number} studentId - Id of the student
 * @param {number} firstTry - First try of the exam
 * @param {number} secondTry - Second try of the exam
 * @param {number} thirdTry - Third try of the exam
 */
class CourseExam {
    constructor(studentId, firstTry, secondTry, thirdTry) {
        this.studentId = studentId;
        this.firstTry = firstTry;
        this.secondTry = secondTry;
        this.thirdTry = thirdTry;
    }
}

export { Course, Student, DualisModule, DualisLecture, DualisExam, CourseModule, CourseLecture, CourseExam };
