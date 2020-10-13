# Web App With Node.js and Express.js

## Introduction

In this exercise, you are going to build a dockerized web application (server-side HTML generation) with Node.js, TypeScript, and Express.js.

If you do not have Node.js installed, run all node-related commands in a Docker container (e.g. `docker run --rm -v <your-path>:/app -w /app node npm install ...`).

## Setup Project

* Create an empty folder *node-express* for the app.

* Run `npm init`. You can accept all the default options.

* Install production dependencies: `npm install express hbs`.

* Install development dependencies: `npm install -D @types/express copyfiles typescript`.

* Set TypeScript compiler options by creating *tsconfig.json* file with the following content:

```json
{
  "compilerOptions": {
    "target": "es2019",
    "module": "commonjs",
    "rootDir": "src",
    "outDir": "dist"
  }
}
```

* Create a *.gitignore* file with the following content:

```txt
dist
node_modules
```

* Add the following scripts to *package.json*:

```json
{
  ...,
  "scripts": {
    "build": "tsc && copyfiles --up 1 ./src/**/*.hbs ./dist",
    "start": "npm run build && node ./dist/app.js"
  },
  ...
}

```

## Write the Code

* Create a folder *src*.

* Create a file *app.ts* in *src* with the following content:

```ts
import * as path from 'path';
import * as express from 'express';

const app = express();

app.set('view engine', 'hbs');
app.set('views', path.join(__dirname, '/views'));

app.get('/', function(req, res) {
  res.render('index', {
    title: 'Hey',
    message: 'Hello there!',
    todos: [ { id: 1, desc: 'Buy food' }, { id: 2, desc: 'Homework' },
      { id: 3, desc: 'Play video games' } ]
  });
});

app.listen(8080, () => console.log('API is listening on port 8080'));
```

* Create a folder *src/views*.

* Create a file *index.hbs* in *src/views* with the following content:

```hbs
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ title }}</title>
</head>
<body>
    <h1>{{ message }}</h1>
    {{#if todos}}
    <ul>
        {{#each todos}}
        <li>{{desc}}</li>
        {{/each}}
    </ul>
    {{else}}
    <p>No todos</p>
    {{/if}}
</body>
</html>
```

* Try building the app: `npm run build`

* Try running the app: `npm start`
  * Open *http://localhost:8080* to see if it works

## Add Docker Code

* Create a file *.dockerignore* with the following content:

```txt
dist
node_modules
Dockerfile
.dockerignore
```

* Create a file *Dockerfile* with the following content:

```Dockerfile
FROM node:alpine AS builder
WORKDIR /app
COPY . .
RUN npm install && npm run build

FROM node:alpine
WORKDIR /app
COPY --from=builder /app/package.json ./
COPY --from=builder /app/dist/ ./
RUN npm install --only=prod
EXPOSE 8080
CMD ["node", "app.js"]
```

* Add the following scripts to *package.json*:

```json
{
  ...,
  "scripts": {
    "build": "tsc && copyfiles --up 1 ./src/**/*.hbs ./dist",
    "start": "npm run build && node ./dist/app.js",
    "docker:build": "docker build -t mywebserver .",
    "docker:run": "docker run -d -p 8080:8080 --name mywebserver mywebserver",
    "docker:rm": "docker rm -f mywebserver"
  },
  ...
}

```

* Try building the Docker image: `npm run docker:build`

* Try running the Docker container: `npm run docker:run`
  * Open *http://localhost:8080* to see if it works
