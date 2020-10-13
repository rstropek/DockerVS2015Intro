FROM ubuntu AS hugo-base
ARG HUGO_VERSION=0.76.4
RUN apt-get update && apt-get install -y wget \
    && wget https://github.com/gohugoio/hugo/releases/download/v$HUGO_VERSION/hugo_extended_${HUGO_VERSION}_Linux-64bit.deb \
          -O 'hugo_${HUGO_VERSION}_Linux-64bit.deb' \
    && dpkg -i hugo*.deb

FROM hugo-base AS builder
WORKDIR /app
COPY . .
RUN hugo

FROM nginx:alpine
WORKDIR /app
COPY --from=builder /app/public /usr/share/nginx/html
