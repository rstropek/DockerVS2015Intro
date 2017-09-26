#!/bin/bash
if [ ! -f ./Program.cs ]; then
    cp ../01-dotnet-core-sample/*.csproj .
    cp ../01-dotnet-core-sample/*.cs .
fi

docker rm -f basta-linux-scd
docker rmi rstropek/basta-linux-scd
docker build -t rstropek/basta-linux-scd .
docker run -d --name basta-linux-scd -p 5000:5000 rstropek/basta-linux-scd

sleep 2
echo Webserver returns `curl http://localhost:5000/demo -s`

docker rm -f basta-linux-scd
