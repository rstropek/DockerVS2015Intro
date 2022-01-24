FROM node:alpine AS build
WORKDIR /app
COPY . .
RUN npm install

FROM node:alpine
WORKDIR /app
COPY --from=build /app .
ENV PORT 80
EXPOSE 80
CMD ["node", "server.js"]
