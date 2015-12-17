#!/bin/bash

# Get latest version from GitHub
git pull https://github.com/aspnet/Home.git

# Restore packages
cd samples/1.0.0-rc1-update1/HelloMvc/
dnu restore

# Start kestrel web server
dnx web

