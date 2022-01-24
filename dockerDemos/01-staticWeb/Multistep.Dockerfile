FROM node:alpine as build
COPY ./app /app
WORKDIR /app
RUN rm -rf ./dist && npm install && npm run build

FROM nginx:alpine
COPY --from=build /app/dist/ /usr/share/nginx/html/
