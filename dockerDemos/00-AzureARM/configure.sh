#!/bin/bash

sudo apt-get update

# Install Node.js 5
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install some important tools globaly
sudo npm install -g typescript gulp grunt-cli
