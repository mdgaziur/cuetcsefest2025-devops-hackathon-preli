FROM node:25-alpine3.21

ARG GATEWAY_PORT
ARG BACKEND_PORT
ENV BACKEND_PORT=$BACKEND_PORT
ENV GATEWAY_PORT=$GATEWAY_PORT

WORKDIR /app

# cache package installation
COPY package.json .
RUN yarn

COPY ./src ./src

EXPOSE $GATEWAY_PORT

RUN ["yarn", "start"]
