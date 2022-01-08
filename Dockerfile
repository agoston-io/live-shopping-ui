FROM node:16.14-alpine as build
COPY src/ /app/
WORKDIR /app
RUN npm ci --cache .npm --prefer-offline --silent --no-optional
RUN npm ci @vue/cli --cache .npm --prefer-offline --silent
RUN npm run build-prod

FROM nginx
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /usr/share/nginx/html
