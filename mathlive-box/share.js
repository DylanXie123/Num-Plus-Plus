// share.js

const fs = require('fs-extra')
const path = require('path')
fs.removeSync(path.join('..', 'assets', 'html'))
fs.copySync(path.join('build'), path.join('..', 'assets', 'html'))