FROM node:25-alpine3.21

ARG BACKEND_PORT

RUN addgroup -g 1010 appuser && adduser -D -u 1010 -G appuser appuser
USER appuser

WORKDIR /backend
COPY package.json .

# Cache package installation
RUN yarn

COPY src ./src
COPY tsconfig.json .

RUN yarn build

EXPOSE $BACKEND_PORT
ENV NODE_ENV='production'

CMD ["yarn", "start"]
