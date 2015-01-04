#!/bin/bash

# Get latest version from GitHub
git pull https://github.com/aspnet/Home.git

# Restore packages
cd samples/HelloMvc/
kpm restore

# Start kestrel web server
k kestrel

