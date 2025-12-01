FROM node:25-alpine3.21

ARG GATEWAY_PORT

WORKDIR /app

# cache package installation
COPY package.json .
RUN yarn

COPY ./src ./src

EXPOSE $GATEWAY_PORT
ENV NODE_ENV='production'

CMD ["yarn", "start"]
