import fetch from './data-scraper.js';
import util from 'util';
import fs from 'fs';

const credentialsJanik = JSON.parse(fs.readFileSync('credentialsJanik.json', 'utf8'));
const credentialsTimo = JSON.parse(fs.readFileSync('credentialsTimo.json', 'utf8'));
const credentialsJustin = JSON.parse(fs.readFileSync('credentialsJustin.json', 'utf8'));


const modulesJanik = await fetch(credentialsJanik);
const modulesTimo = await fetch(credentialsTimo);
const modulesJustin = await fetch(credentialsJustin);


console.log(util.inspect(modulesJanik, false, null, true /* enable colors */));
console.log(util.inspect(modulesTimo, false, null, true /* enable colors */));
console.log(util.inspect(modulesJustin, false, null, true /* enable colors */));

fs.writeFileSync('modulesJanik.json', JSON.stringify(modulesJanik, null, 2));
fs.writeFileSync('modulesTimo.json', JSON.stringify(modulesTimo, null, 2));
fs.writeFileSync('modulesJustin.json', JSON.stringify(modulesJustin, null, 2));


for (let module of modulesJanik) {
    let found = false;
    for (let module1 of modulesTimo) {
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

console.log(modulesJanik.length === modulesTimo.length && modulesJanik.length === modulesJustin.length);
