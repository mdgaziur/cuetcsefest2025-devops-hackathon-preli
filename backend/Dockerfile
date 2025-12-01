FROM node:25-alpine3.21

WORKDIR /backend
COPY package.json .

# Cache package installation
RUN yarn

COPY src ./src
COPY tsconfig.json .

RUN yarn build

EXPOSE 3847

CMD ["yarn", "start"]
