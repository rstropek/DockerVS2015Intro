#!/bin/bash
if [ ! -f ./Program.cs ]; then
    cp ../01-dotnet-core-sample/*.csproj .
    cp ../01-dotnet-core-sample/*.cs .
fi

docker rm -f tdsweden-linux-prod
docker rmi rstropek/tdsweden-linux-prod
docker build -t rstropek/tdsweden-linux-prod .
docker run -d --name tdsweden-linux-prod -p 5000:5000 rstropek/tdsweden-linux-prod

sleep 2
echo Webserver returns `curl http://localhost:5000/demo -s`

docker rm -f tdsweden-linux-prod
