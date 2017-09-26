#!/bin/bash
if [ ! -f ./Program.cs ]; then
    cp ../01-dotnet-core-sample/*.csproj .
    cp ../01-dotnet-core-sample/*.cs .
fi

docker rm -f basta-linux-prod
docker rmi rstropek/basta-linux-prod
docker build -t rstropek/basta-linux-prod .
docker run -d --name basta-linux-prod -p 5000:5000 rstropek/basta-linux-prod

sleep 2
echo Webserver returns `curl http://localhost:5000/demo -s`

docker rm -f basta-linux-prod
