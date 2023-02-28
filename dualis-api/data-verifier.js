/**
 * Verifies if all students have the same modules
 * @param {list} course 
 * @returns true if course is valid, false otherwise
 */
const verifyCourse = (course) => {
    // check if all students have the same number of modules
    let moduleNumber;
    for (const student of course) {
        if (moduleNumber === undefined) {
            moduleNumber = student.length;
        }
        else if (moduleNumber !== student.length) {
            return false;
        }
    }

    // check if all students have the same modules
    for (let i = 0; i < course[0].length; i++) {
        for (const student of course.slice(1)) {
            // check if module name, cts and number of lectures are the same
            if (course[0][i].modulename !== student[i].modulename && course[0][i].cts !== student[i].cts && course[0][i].lectures.length !== student[i].lectures.length) {
                return false;
            }
            else {
                for (let j = 0; j < course[0][i].lectures.length; j++) {
                    // check if lectures are the same
                    if (course[0][i].lectures[j].lecturename !== student[i].lectures[j].lecturename) {
                        return false;
                    }
                }
            }
        }
    }
    return true;
};

export default verifyCourse;
