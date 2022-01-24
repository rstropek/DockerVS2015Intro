# Simple Web App

```sh
cd app
npm install
npm start
npm run build
docker run -t --rm -v $(pwd):/app -w /app node:alpine npm run build

cd ..
docker build -t 01-staticweb .
docker build -t 01-staticweb -f Multistep.Dockerfile
docker run -t --rm -p 8081:80 01-staticweb
```
