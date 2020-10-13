# Hugo Website

## Introduction

In this exercise, you will build a website using the [Hugo](https://gohugo.io) static website generator.

## Prerequisites

* Clone or download the repository [https://github.com/rstropek/git-fundamentals-basic-hugo-website](https://github.com/rstropek/git-fundamentals-basic-hugo-website) into a new folder. Note that the repository is a template. Therefore, you can also click on *Use this template* to fork the repository into you own organization.

* Make yourself familiar with the website structure.

## Docker Code

* Add the following *Dockerfile* to your folder:

```Dockerfile
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
```

* Try to understand the content of the *Dockerfile*.

## Build the Docker Image

* Build the image: `docker build -t myhugo .`

* Verify that the image exists: `docker images myhugo`

* Run a container with the image: `docker run -d -p 8080:80 myhugo`
  * Open *http://localhost:8080/* and check whether the website works.

## Publish the Docker Image

* Create a free user account on the [Docker Hub](https://hub.docker.com).

* Add a tag to your image: `docker tag myhubo <your-dockerhub-user>/myhugo`

* Verify that everything is fine with the images: `docker images <your-dockerhub-user>/myhugo`

* Login to the Docker Hub: `docker login`

* Push your image to the Docker Hub: `docker push <your-dockerhub-user>/myhugo`

* Go to the [Docker Hub](https://hub.docker.com) and verify that your image is there.
