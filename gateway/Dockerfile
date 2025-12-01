FROM node:25-alpine3.21

WORKDIR /app

# cache package installation
COPY package.json .
RUN yarn

COPY ./src ./src

EXPOSE $GATEWAY_PORT

CMD ["yarn", "start"]
