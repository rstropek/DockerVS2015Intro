FROM node as build
ENV approot /app
COPY ./app ${approot}
WORKDIR ${approot}
RUN rm -rf ./dist && rm -rf ./node_modules && npm install && npm run build

FROM nginx:alpine
COPY --from=build /app/dist/ /usr/share/nginx/html/
