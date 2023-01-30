import fetch from './data-scraper.js';
import util from 'util';
import fs from 'fs';

const credentials = JSON.parse(fs.readFileSync('credentials.json', 'utf8'));

const requests = credentials.map(credentials => fetch(credentials));
const modules = await Promise.all(requests);

for (let module of modules) {
    console.log(util.inspect(module, false, null, true /* enable colors */));
}

fs.writeFileSync('modules.json', JSON.stringify(modules, null, 2));

for (let module of modules[0]) {
    let found = false;
    for (let module1 of modules[1]) {
        if (module.name == module1.name) {
            found = true;
            break;
        }
    }
    if (!found) {
        console.log(module.name);
    }
    else {
        console.log("found");
    }
}


console.log(modules[0].length === modules[1].length && modules[0].length === modules[2].length);
