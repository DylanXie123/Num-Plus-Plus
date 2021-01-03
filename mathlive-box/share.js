// share.js

const fs = require('fs-extra')
const path = require('path')
fs.copySync(path.join('build'), path.join('..', 'assets', 'html'))