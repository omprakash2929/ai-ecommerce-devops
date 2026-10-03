// Basic static-site tests: required pages, local asset references, JS syntax.
const fs = require('fs');
const path = require('path');
const cp = require('child_process');

const appDir = path.join(__dirname, '..', 'application');
const files = fs.readdirSync(appDir);
const htmlFiles = files.filter(f => f.endsWith('.html'));
let errors = 0;

if (!htmlFiles.includes('index.html')) {
  console.error('[FAIL] index.html is missing');
  errors++;
}

// 1. every local href/src must exist
for (const page of htmlFiles) {
  const src = fs.readFileSync(path.join(appDir, page), 'utf8');
  const re = /(?:href|src)=["']([^"'#?]+)["']/g;
  let m;
  while ((m = re.exec(src))) {
    const ref = m[1];
    if (/^(https?:)?\/\/|^mailto:|^tel:|^data:|^javascript:/.test(ref)) continue;
    if (!fs.existsSync(path.join(appDir, ref))) {
      console.error(`[FAIL] ${page} references missing file: ${ref}`);
      errors++;
    }
  }
  console.log(`[ OK ] checked references in ${page}`);
}

// 2. JS syntax check
for (const js of files.filter(f => f.endsWith('.js'))) {
  const r = cp.spawnSync('node', ['--check', path.join(appDir, js)]);
  if (r.status !== 0) {
    console.error(`[FAIL] syntax error in ${js}\n${r.stderr}`);
    errors++;
  } else {
    console.log(`[ OK ] syntax ${js}`);
  }
}

if (errors) {
  console.error(`\n${errors} problem(s) found`);
  process.exit(1);
}
console.log('\nAll tests passed');
