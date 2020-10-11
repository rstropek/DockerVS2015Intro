# Docker Volumes

## Prerequisites

**Note** that this exercise assumes that you have done [the previous exercise](https://github.com/rstropek/DockerVS2015Intro/tree/master/dockerDemos/labs/020-docker-networking).

## Mount Postgres Data to Host Volume

* Create an empty folder on your host machine.
* Run a new instance of Postgres and configure it so that it stores its data on the host in your folder (**note** that you have to replace *<folder-on-your-machine>* in the following statement): `docker run -d -e POSTGRES_PASSWORD=secret -e PGDATA=/pgdata --net pg-net -v <folder-on-your-machine>:/pgdata --name pg-db postgres`
* Remove container: `docker rm -f pg-db`
* Check that Postgres data is still present in your data folder on the host.
* For cleaning up, delete the data folder.

## Use a Docker Volume

* Create a Docker volume: `docker volume create dbstore`
* Inspect the volume: `docker volume inspect dbstore`
* Start Postgres and mount data location to Docker volume: `docker run -d -e POSTGRES_PASSWORD=secret -e PGDATA=/dbdata --mount 'type=volume,src=dbstore,dst=/dbdata' --name pg-db postgres`
* Verify that Postgres data has been stored in the volume in a separate Ubuntu container: `docker run --rm --mount 'type=volume,src=dbstore,dst=/dbdata' -w /dbdata ubuntu /bin/bash -c "ls -la"`
* For cleaning up, delete the volume: `docker volume rm dbstore`
