#!/bin/bash
if [ ! -f ./Program.cs ]; then
    cp ../08-docker-dot-net/01-dotnet-core-sample/*.csproj .
    cp ../08-docker-dot-net/01-dotnet-core-sample/*.cs .
    cp ../08-docker-dot-net/Dockerfile .
fi

docker rm -f aks-dotnet-linux-scd
docker rmi rainer.azurecr.io/aks-dotnet-linux-scd
docker build -t rainer.azurecr.io/aks-dotnet-linux-scd .
docker run -d --name aks-dotnet-linux-scd -p 5000:5000 rainer.azurecr.io/aks-dotnet-linux-scd

sleep 2
echo Webserver returns `curl http://localhost:5000/demo -s`

docker rm -f aks-dotnet-linux-scd

az container create --name aks-dotnet-linux-scd --image rainer.azurecr.io/aks-dotnet-linux-scd \
  --cpu 1 --memory 1 --registry-password jX5RW.... --ip-address public --ports 5000\
  -g Docker --location westeurope

az container show --name aks-dotnet-linux-scd --resource-group Docker --query instanceView.state

az container show --name aks-dotnet-linux-scd --resource-group Docker --query ipAddress.ip

az container logs --name aks-dotnet-linux-scd -g Docker