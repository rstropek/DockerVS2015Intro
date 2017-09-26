#!/bin/bash
dotnet build
dotnet publish -c Release -o fdd
dotnet publish -c Release -o scd -r linux-x64
