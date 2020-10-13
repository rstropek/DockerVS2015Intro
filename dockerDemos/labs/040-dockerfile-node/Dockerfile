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
