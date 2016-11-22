import path from 'path';
import Updater from './utils/Updater';

const packageJson = path.join(__dirname, '/../package.json');
const pkg = require(packageJson); // eslint-disable-line import/no-dynamic-require

new Updater(pkg).verify();
