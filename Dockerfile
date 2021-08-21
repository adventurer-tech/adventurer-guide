FROM node:16-alpine3.11 AS dev

# install tools and deps for node-gyp
RUN apk add --no-cache --virtual .gyp \
  python \
  make \
  g++ \
  jq

WORKDIR /app
COPY ./ ./
RUN yarn install
RUN NODE_ENV=production VERSION=`jq .version package.json` yarn build

FROM 36node/nginx-react:0.1

ENV DEBUG=off \
    NODE_ENV=production

COPY --from=dev /app/build /app
