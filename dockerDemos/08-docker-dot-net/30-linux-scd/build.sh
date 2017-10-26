#!/bin/bash
if [ ! -f ./Program.cs ]; then
    cp ../01-dotnet-core-sample/*.csproj .
    cp ../01-dotnet-core-sample/*.cs .
fi

docker rm -f tdsweden-linux-scd
docker rmi rstropek/tdsweden-linux-scd
docker build -t rstropek/tdsweden-linux-scd .
docker run -d --name tdsweden-linux-scd -p 5000:5000 rstropek/tdsweden-linux-scd

sleep 2
echo Webserver returns `curl http://localhost:5000/demo -s`

docker rm -f tdsweden-linux-scd
