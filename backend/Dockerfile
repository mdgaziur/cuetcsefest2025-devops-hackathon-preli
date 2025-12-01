FROM node:25-alpine3.21

ARG BACKEND_PORT

WORKDIR /backend
COPY package.json .

# Cache package installation
RUN yarn

COPY src ./src
COPY tsconfig.json .

RUN yarn build

EXPOSE $BACKEND_PORT

CMD ["yarn", "start"]
