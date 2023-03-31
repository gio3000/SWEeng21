import { Course, CourseModule, CourseLecture, CourseExam } from "./classes.js";

/**
 * Formats the course data to be saved in the database
 * @param {Course[]} course - The course data
 */
const formatCourseData = (course) => {
    for (const student of course.students) {
        for (const dualisModule of student.dualisModules) {
            let found = false;
            for (const module of course.courseModules) {
                // Check if module already exists
                if (module.moduleName === dualisModule.moduleName && module.cts === dualisModule.cts && module.lectures.length === dualisModule.lectures.length) {
                    for (let i = 0; i < dualisModule.lectures.length; i++) {
                        const dualisExam = dualisModule.lectures[i].exam;
                        const exam = new CourseExam(student.studentId, dualisExam.firstTry, dualisExam.secondTry, dualisExam.thirdTry);
                        module.lectures[i].appendExam(exam);
                    }
                    found = true;
                    break;
                }
            }
            if (!found) {
                // Append Module
                const module = new CourseModule(dualisModule.moduleName, dualisModule.cts);
                for (const dualisLecture of dualisModule.lectures) {
                    const lecture = new CourseLecture(dualisLecture.lectureName, dualisLecture.semester, dualisLecture.countsToAverage);
                    const exam = new CourseExam(student.studentId, dualisLecture.exam.firstTry, dualisLecture.exam.secondTry, dualisLecture.exam.thirdTry);
                    lecture.appendExam(exam);
                    module.appendLecture(lecture);
                }
                course.courseModules.push(module);
            }
        }
    }
};

export default formatCourseData;
