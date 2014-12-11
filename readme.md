# Docker on Microsoft Azure Sample

## Introduction

This sample demonstrates the use of Docker for HTML and ASP.NET vNext
development. It contains scripts to automatically create the demo
environment in Azure.

## Demo environment

The script [createDemoEnv.sh](createDemoEnv.sh) creates three
virtual machines in a separate vnet in Microsoft Azure:

* Docker Host
  Ubuntu-based Docker host. Beside Docker it also runs Samba so that the
  Windows Server with Visual Studio 2015 can easily store files there.

* Linux Docker Client
  Ubuntu-based Docker client. Use it to play with the Linux-based Docker
  client. Note that the create script mentioned above automatically copies
  the Docker certificates created during VM setup of the Docker Host to
  this client. Therefore this client can talk to the Docker Host using TLS.

* Visual Studio 2015 Preview on Windows
  Windows-based server with Visual Studio 2015 Preview.

## Setting up the Demo Environment

In order to setup the demo environment you need:

1. An Azure Subscription
2. A Linux machine (if you don't have one, create an Ubuntu VM in Azure)
3. The Linux machine has to be configured as follows:
  1. Install Azure XPlat tools as described [here](http://azure.microsoft.com/en-us/documentation/articles/xplat-cli/)
  2. The Azure XPlat tools have to be connected to your Azure subscription (I recommend
     the publish settings file method)

If you have that, clone this Github repository and run [createDemoEnv.sh](blob/master/createDemoEnv.sh).
You will probably need to adapt the name constants at the beginning of the file as the 
names might already be taken.

Once the script is completed, you can use the helper scripts 
[openLinuxClientShell.sh](openLinuxClientShell.sh) and
[openDockerHostShell.sh](openDockerHostShell.sh) to open a remote shell
on the Linux machines.

To check if everything worked well, connect to the Linux client machine and try
`docker --tls=true -H tcp://dockersamplehost.cloudapp.net:4243 info`. The Docker
Host should answer correctly.


