import fetch from './data-scraper.js';
import verifyCourse from './data-verifier.js';
import util from 'util';
import fs from 'fs';

const credentials = JSON.parse(fs.readFileSync('credentials.json', 'utf8'));

const requests = credentials.map(credentials => fetch(credentials));
const modules = await Promise.all(requests);

console.log(util.inspect(modules, false, null, true /* enable colors */));

fs.writeFileSync('modules.json', JSON.stringify(modules, null, 2));

console.log(verifyCourse(modules));
