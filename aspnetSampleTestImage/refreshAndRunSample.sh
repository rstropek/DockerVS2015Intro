#!/bin/bash

git pull https://github.com/aspnet/Home.git
cd samples/HelloMvc/
kpm restore
k kestrel

