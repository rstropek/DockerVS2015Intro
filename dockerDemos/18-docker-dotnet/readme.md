# Docker and .NET - Tips and Tricks

## Official Images

* [.NET official images on Docker Hub](https://hub.docker.com/_/microsoft-dotnet)
* [Sources on GitHub](https://github.com/dotnet/dotnet-docker/)
* Variants
  * [SDK](https://hub.docker.com/_/microsoft-dotnet-sdk/)
    * For coding and building
  * [ASP.NET Core Runtime](https://hub.docker.com/_/microsoft-dotnet-aspnet/)
    * For running ASP.NET Core apps ([framework-dependent deployment](https://docs.microsoft.com/en-us/dotnet/core/deploying/)) in production
  * [Runtime](https://hub.docker.com/_/microsoft-dotnet-runtime/)
    * For running .NET apps ([framework-dependent deployment](https://docs.microsoft.com/en-us/dotnet/core/deploying/)) in production
  * [Runtime dependencies](https://hub.docker.com/_/microsoft-dotnet-runtime-deps/)
    * For running .NET apps ([self-contained deployment](https://docs.microsoft.com/en-us/dotnet/core/deploying/)) in production
  * [Monitor](https://hub.docker.com/_/microsoft-dotnet-monitor/)
    * Sidecar container for collecting diagnostic information
  * [Samples](https://hub.docker.com/_/microsoft-dotnet-samples/)
  * What if none of the existing images fit your needs and you need to install .NET in your own Dockerfile?
    * See [code snippets for .NET install in Dockerfile](https://github.com/dotnet/dotnet-docker/blob/main/documentation/scenarios/installing-dotnet.md)
* Hierarchy of standard images
  * *SDK* [is based on](https://github.com/dotnet/dotnet-docker/blob/3b02c5dcd3780ec66ee6b178d0f2d15f994841b8/src/sdk/6.0/bullseye-slim/amd64/Dockerfile#L1)...
  * *aspnet*, [which is based on](https://github.com/dotnet/dotnet-docker/blob/3b02c5dcd3780ec66ee6b178d0f2d15f994841b8/src/aspnet/6.0/bullseye-slim/amd64/Dockerfile#L1)...
  * *runtime*, [which is based on](https://github.com/dotnet/dotnet-docker/blob/3b02c5dcd3780ec66ee6b178d0f2d15f994841b8/src/runtime/6.0/bullseye-slim/amd64/Dockerfile#L1)...
  * *runtime-deps*, [which is based on](https://github.com/dotnet/dotnet-docker/blob/3b02c5dcd3780ec66ee6b178d0f2d15f994841b8/src/runtime-deps/6.0/bullseye-slim/amd64/Dockerfile#L1)...
  * the underlying Linux distro
* [Image Update Policy](https://github.com/dotnet/dotnet-docker#image-update-policy)
  * Updated within 12 hours after update of base image (e.g. Linux distro)
  * New images appear shortly after or in parallel with release of .NET versions (including previews)
* [Platforms](https://github.com/dotnet/dotnet-docker/blob/main/documentation/supported-platforms.md)
  * Linux: Alpine, Debian, Ubuntu
  * Windows: Server Core, Nano Server
  * Check lifetime policies!
  * Linux/Windows x86-64 (*amd64*)
  * Linux ARMv7 32-bit (*arm32v7*)
  * Linux ARMv8 64-bit (*arm64v8*)
* [Tagging](https://github.com/dotnet/dotnet-docker/blob/main/documentation/supported-tags.md)
  * Simple tags (e.g. *6.0.100-preview.7-bullseye-slim-amd64*) according to schema `<Major.Minor .NET Version>-<OS>-<Architecture>`
  * Shared tags (e.g. *6.0.100-preview.7*) reference images for multiple platforms
    * Docker will pick proper platform
    * If no OS is specified...
      * ...Debian is used when on Linux
      * ...Nano Server is used when on Windows

## Demos

### Use SDK Image to Generate and Build App

```bash
docker run -it --rm mcr.microsoft.com/dotnet/sdk:6.0 /bin/bash
dotnet --list-sdks
mkdir dotnet
cd dotnet
dotnet new --list
dotnet new console -o hello-dotnet
cd hello-dotnet
dotnet run
```

### Develop in Container

```bash
docker run -d mcr.microsoft.com/dotnet/sdk:6.0 tail -f /dev/null
```

* Connect to container in VSCode
  * [Docker extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
* Open folder
* Open console
* `dotnet new console -o hello-dotnet`
* Open folder
* Install C# extension
* Configure default build task
* Create *launch.json* for debugging
  * Add configuration *Launch .NET Core Console App*
  * Target framework is *net6.0*
  * Project name is *hello-dotnet*
* Debug in Container remotely

## Writing Dockerfiles For .NET Apps

* In general: Follow [samples provided by Microsoft](https://github.com/dotnet/dotnet-docker/tree/main/samples)
* [Multi-stage build](https://docs.microsoft.com/en-us/visualstudio/containers/container-build#multistage-build)
  * [Restore, build, and generate resulting image in multiple stages](https://github.com/dotnet/dotnet-docker/blob/main/samples/dotnetapp/Dockerfile)
  * [Run tests during image build](https://github.com/dotnet/dotnet-docker/blob/main/samples/complexapp/Dockerfile)
  * Discuss: When to build in Dockerfile, when to build in e.g. GitHub Actions?
* [Generate Dockerfile with Visual Studio](https://docs.microsoft.com/en-us/visualstudio/containers/container-tools)

## Demos

### Create ASP.NET Core App For Container

* Create ASP.NET Core project in VS 2022
  * Enable Docker
  * No HTTPS, no Swagger
* Walkthrough *Dockerfile*, *.dockerignore*
* Switch debugging to *Docker*
* Start debugger

```bash
docker ps
docker exec -it <container-id> /bin/bash
apt-get update && apt-get install curl -y
curl http://localhost:80/weatherForecast
```

* Debugger breaks in VS

### Build Image From Dockerfile

* Open folder with previously created ASP.NET Core app

```bash
docker build -t md-devdays-web:latest .
docker images md-devdays-web
```

## Azure Container Registry

* [Managed, private Docker registry service](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-intro)
  * Based on the open-source Docker Registry 2.0
  * Supports Windows and Linux images
  * Use standard Docker CLI
  * [Not expensive](https://azure.microsoft.com/en-us/pricing/details/container-registry/)
* Why?
  * Store and manage private Docker container images
  * Store copies of publish images (e.g. to work around Docker download rate limts)
  * Local, network-close storage of container images
    * Optional: Geo-replication in Premium tier
  * Azure RBAC integration
* Build, test, push, and deploy images through *ACR Tasks*
  * `docker build` in the cloud
  * No need for local Docker installation
  * Can be triggered automatically [when base images are updated](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview#automate-os-and-framework-patching) (auto-patching)
  * Triggered [when code changes](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview#trigger-task-on-source-code-update) (e.g. GitHub Webhooks)
  * [Examples for tasks](https://docs.microsoft.com/en-us/cli/azure/acr/task?view=azure-cli-latest#az_acr_task_create-examples)

## Demos

### Create Container Registry and Push ASP.NET Core App

```bash
az group create --name md-devdays --location westeurope
az acr create --resource-group md-devdays --name rsmddevdays --sku premium --admin-enabled
az acr login --name rsmddevdays

docker tag md-devdays-web:latest rsmddevdays.azurecr.io/md-devdays-web:latest
docker push rsmddevdays.azurecr.io/md-devdays-web:latest

az interactive
az acr list -o table
az acr repository list --name rsmddevdays -o table

az acr repository delete --name rsmddevdays --image md-devdays-web:latest
```

### Copy .NET SDK Image

```bash
az acr import --name rsmddevdays --source mcr.microsoft.com/dotnet/sdk:6.0 --image dotnet/sdk:6.0
az acr import --name rsmddevdays --source mcr.microsoft.com/dotnet/aspnet:6.0 --image dotnet/aspnet:6.0
az acr repository list --name rsmddevdays -o table
```

### Build ASP.NET Core App in ACR

* Change *mcr.microsoft.com* in Dockerfile to *rsmddevdays.azurecr.io*

```bash
az acr build --registry rsmddevdays --image md-devdays-web:latest .
az acr repository list --name rsmddevdays -o table
```

* Show repository in Azure Portal
* Show task log in Azure Portal

## Running .NET Container in Azure

* Discuss [compute candidate services](https://docs.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree#choose-a-candidate-service) in MS docs
* [Azure Container Instances](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview) (ACI)
* [Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/tutorial-custom-container?pivots=container-linux)
* [Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/) (AKS)
* [Azure Service Fabric](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-quickstart-containers-linux)

## Demos

* Run *Container Instance* with image from ACR
* Run *App Service* with image from ACR
