#!/bin/bash

# Get latest version from GitHub
git pull https://github.com/aspnet/Home.git

# Restore packages
cd samples/1.0.0-beta7/HelloMvc/
dnu restore

# Start kestrel web server
dnx kestrel

