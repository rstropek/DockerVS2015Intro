#!/bin/bash

# Sample script for installing docker.
# Note that this script does not configure/start daemon.
# This is by design as we jus need the docker client
# in this scenario.

# For additional details about installing docker on ubuntu see
# https://docs.docker.com/engine/installation/linux/ubuntulinux/

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo echo deb https://apt.dockerproject.org/repo ubuntu-wily main | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get purge lxc-docker

sudo apt-get install linux-image-extra-$(uname -r)

sudo apt-get install -y docker-engine

# Create directory that will receive certs for tlsverify.
# For details see https://docs.docker.com/engine/security/https/
mkdir /home/training/.docker
chown training /home/training/.docker
