FROM node:17.9.0-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm i
COPY vite.config.js index.html ./
COPY public public/
COPY src src/
RUN npx vite build

FROM nginx:1.21.6-alpine
COPY docker/prod/default.conf /etc/nginx/conf.d/
COPY --from=build /app/dist /app/
