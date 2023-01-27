import fetch from './data-scraper.js';
import fs from 'fs';

const credentials = JSON.parse(fs.readFileSync('credentials.json', 'utf8'));

await fetch(credentials)