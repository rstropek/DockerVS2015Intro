# Docker on Microsoft Azure Sample

Creator: Rainer Stropek, Azure MVP

Originally created for an article in the German 
[Windows Developer Magazine](http://windowsdeveloper.de/).

## Introduction

This sample demonstrates the use of [Docker](https://www.docker.com/) 
for HTML- and [ASP.NET vNext](http://www.asp.net/vnext)-development on Linux. 
It contains scripts to automatically create the demo environment in Azure.

At the end of this sample, you will have ASP.NET MVC applications running on
Linux in a Docker Container :-)

This 

## Demo environment

The script [createDemoEnv.sh](createDemoEnv.sh) creates three
virtual machines in a separate vnet in [Microsoft Azure](http://azure.microsoft.com):

* Docker Host
  Ubuntu-based Docker host.

* Docker Client
  Ubuntu-based Docker client. Use it to play with the Linux-based Docker
  client. Note that the create script automatically copies
  the Docker certificates created during VM setup of the Docker Host to
  this client. Therefore this client can talk to the Docker Host using TLS.
  The script also installs and configures [Samba](https://www.samba.org/samba/) 
  so that you can easily exchange files (e.g. ASP.NET projects) with the VS2015 Windows machine
  (see below).

* Visual Studio 2015 Preview on Windows (optionally)
  Windows-based server with Visual Studio 2015 Preview.

## Setting up the Demo Environment

In order to setup the demo environment you need:

1. An Azure Subscription
2. A Linux machine (if you don't have one, create an Ubuntu VM in Azure)

The Linux machine has to be configured as follows:

1. Install Azure XPlat tools (for details see also  
   [Azure docs](http://azure.microsoft.com/en-us/documentation/articles/xplat-cli/)):
```
sudo apt-get -qqy update
sudo apt-get -qqy install nodejs-legacy npm git
sudo npm install -g azure-cli
```

2. The Azure XPlat tools have to be connected to your Azure subscription (I recommend
   the publish settings file method)
  1. Open a browser window and log in to the [Azure Portal](http://portal.azure.com). Make
     sure you use credentials for the Azure subscription you want to use for your tests.
  2. Open https://manage.windowsazure.com/publishsettings/index?client=xplat in a new browser
     tab. That will allow you to download the publishing file for your subscription.
  3. Copy the publishing file to the new Linux machine you just created. You can use
     `scp` on Linux or e.g. [WinSCP](http://winscp.net/eng/index.php) on Windows.
  4. Import the publishing file using `azure account import my.publishsettings`.
  5. Validate if the correct Azure account has been selected (`azure account list`).
     Optionally, you can select an account using `azure account set myAzureAccountName`.
   
If you have that, clone this Github repository and run [createDemoEnv.sh](createDemoEnv.sh).
You will *probably need to adapt the name constants* (specifically `prefix`) at the beginning 
of the file as the names might already be taken by other Azure users.

Once the script ran to completion, you can use the helper scripts 
[openLinuxClientShell.sh](openLinuxClientShell.sh) and
[openDockerHostShell.sh](openDockerHostShell.sh) to open a remote shells
on the Linux machines.

To check if everything worked well, connect to the *Linux client machine* 
(Docker Client) using [openLinuxClientShell.sh](openLinuxClientShell.sh) and try
`docker --tls=true -H tcp://dockersamplehost.cloudapp.net:4243 info`. The Docker
Host should answer correctly.

## Manually Starting Docker Containers

Now that Docker is working, you can try to create your first Docker Container.
This is done using the command 
`docker --tls run -h tcp://dockersamplehost.cloudapp.net:4243 -i -t ubuntu /bin/bash`.
It opens a bash shell in a new Ubuntu container.
You can read more about the parameters of the `docker` command in the 
[Docker documentation](https://docs.docker.com/userguide/usingdocker/).

If you are tired of specifying the remote docker host, you can set the 
`DOCKER_HOST` environment variable using the command
`export DOCKER_HOST=tcp://dockersamplehost.cloudapp.net:4243`. After that,
you can just write `docker --tls run -i -t ubuntu /bin/bash`.

Start multiple containers as described above and note how fast new containers
are started after the base image `ubuntu` has been downloaded.

## Nginx Webserver in a Docker Container

Next, let's try to run a static website using [nginx](http://nginx.org/en/). Instead
of creating the container manually, use the following 
[Dockerfile](https://docs.docker.com/reference/builder/) (store a sample
**default.html** file next to the dockerfile):

```
# Version 0.0.1
FROM nginx
MAINTAINER Rainer Stropek "rainer@timecockpit.com"
ENV REFRESHED_AT 2014-01-02
RUN apt-get -qq update
COPY *.html /usr/share/nginx/html/
```

From this dockerfile, you can create a docker image using 
`docker --tls build -t staticweb .`. After this command, you should find the new
image in docker's image list: `docker --tls images`.

Now we can start a container: `docker --tls run --name staticwebcontainer -d -p 80:80 staticweb`.
After this command, you should find the new, running container in docker's container
list: `docker --tls ps`. Stop the container using docker's `stop` command.

## ASP.NET vNext in a Linux Docker Container

Ready to run ASP.NET vNext in a Linux Docker Container? Fortunately, Microsoft provides
a ready-made docker base image for ASP.NET vNext: 
[microsoft/aspnet](https://registry.hub.docker.com/u/microsoft/aspnet/).

The dockerfile [aspnetSampleTestImage/Dockerfile](aspnetSampleTestImage/Dockerfile) uses
this base image to get the official ASP.NET vNext samples from 
[GitHub](https://github.com/aspnet/home), restores the necessary packages (`kpm restore`),
and starts the [Kestrel](https://github.com/aspnet/KestrelHttpServer) webserver.

1. Build the docker image using `docker --tls build -t myapp .`
2. Run the docker container with kestrel using `docker --tls run -d -t -p 80:5004 myapp`

After that, you have ASP.NET under Linux running inside a docker container :-)

