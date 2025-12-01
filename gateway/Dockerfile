FROM node:25-alpine3.21

ARG GATEWAY_PORT

RUN addgroup -g 1010 appuser && adduser -D -u 1010 -G appuser appuser
USER appuser

WORKDIR /gateway

# cache package installation
COPY package.json .
RUN yarn

COPY ./src ./src

EXPOSE $GATEWAY_PORT
ENV NODE_ENV='production'

CMD ["yarn", "start"]
