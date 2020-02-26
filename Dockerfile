FROM zzswang/docker-nginx-react:v0.10.7

ARG VERSION

ENV DEBUG=off \
  APP_VERSION=${VERSION} \
  NODE_ENV=production \
  APP_PORT=80

COPY ./build /app
