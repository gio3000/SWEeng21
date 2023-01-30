/**
 * Converts gradeString to percent points
 * @param {string} gradeString 
 * @returns percent points of gradeString
 */
const gradeStringToPercentPoints = (gradeString) => {
    const gradeConversion = {
        1.0: 100,
        1.1: 97,
        1.2: 95,
        1.3: 93,
        1.4: 92,
        1.5: 90,
        1.6: 89,
        1.7: 87,
        1.8: 86,
        1.9: 84,
        2.0: 82,
        2.1: 81,
        2.2: 79,
        2.3: 77,
        2.4: 76,
        2.5: 74,
        2.6: 73,
        2.7: 71,
        2.8: 70,
        2.9: 68,
        3.0: 66,
        3.1: 65,
        3.2: 63,
        3.3: 61,
        3.4: 60,
        3.5: 58,
        3.6: 57,
        3.7: 55,
        3.8: 54,
        3.9: 52,
        4.0: 50,
        4.1: 49,
        4.2: 47,
        4.3: 45,
        4.4: 44,
        4.5: 42,
        4.6: 41,
        4.7: 39,
        4.8: 38,
        4.9: 36,
        5.0: 34
    }
    const grade = parseFloat(gradeString.replace(',', '.'))
    return gradeConversion[grade];
}

/**
 * Removes duplicates from moduleData
 * @param {list} moduleData 
 * @returns moduleData without duplicates
 */
const removeModuleDataDuplicates = (moduleData) => {
    const seen = new Set();
    return moduleData.filter(item => {
        const key = JSON.stringify([item.argument, item.cts]);
        if (seen.has(key)) {
            return false;
        }
        seen.add(key);
        return true;
    });
}

export { gradeStringToPercentPoints, removeModuleDataDuplicates };
