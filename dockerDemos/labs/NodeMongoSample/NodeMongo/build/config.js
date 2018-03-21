exports.TS_SOURCES = [
    "typings/main.d.ts",
    "src/**/*.ts"
];
exports.APP_DIST = "./dist";
exports.CLEAN = [
    "**/*.js.map",
    "**/*.js",
    "!node_modules/**/*.js",
    "!Gulpfile.js",
    "!build/**/*.js",
    "dist/**",
    "!dist",
    "!dist/.git"
];