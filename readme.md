# Docker Introduction (Focus on Azure)

Creator: Rainer Stropek, Azure MVP

Originally created for an article in the German 
[Windows Developer Magazine](http://windowsdeveloper.de/). Extended and refined for various
trainings I did with customers.


## Introduction

This collection of samples demonstrates the use of [Docker](https://www.docker.com/) 
for HTML- and [ASP.NET Core 1.0](https://docs.asp.net/en/latest/)-development on Linux. 
It contains scripts to automatically create the demo environment in [Microsoft Azure](http://azure.microsoft.com).


## Slides

The folder [slides](slides) contains PowerPoint slides about Docker. The slide deck
contains a lot of samples you can try based on a demo environment created with
the scripts in this Github repository.

Additional samples and code snippets for demo can be found in the [dockerDemos](dockerDemos) folder.


## Demo environment

The script [Deploy-AzureResourceGroup.ps1](dockerDemos/00-AzureARM/Deploy-AzureResourceGroup.ps1) creates two Ubuntu virtual machines in a separate Resource Group in 
[Microsoft Azure](http://azure.microsoft.com):

* Docker Host (dockertraining.northeurope.cloudapp.azure.com)
  Ubuntu-based Docker host.

* Docker Client (dockertrainingclient.northeurope.cloudapp.azure.com)
  Ubuntu-based Docker client. Note that the create script automatically copies
  the Docker certificates created during VM setup of the Docker Host to
  this client. Therefore this client can talk to the Docker Host using TLS.

To demonstrate the [Azure Files-Driver for Docker Volumes](https://github.com/Azure/azurefile-dockervolumedriver)
you have to [install it](https://github.com/Azure/azurefile-dockervolumedriver/tree/master/contrib/init/systemd)
on the Docker Host. This step is not yet automated in the deployment script mentioned above. You currently
have to do that manually.

  
## Setting up the Demo Environment

In order to setup the demo environment you need an Azure Subscription.
   
Once you have that, clone this Github repository and run [Deploy-AzureResourceGroup.ps1](dockerDemos/00-AzureARM/Deploy-AzureResourceGroup.ps1).
You will *probably need to adapt the name constants* at the beginning 
of the file as the names might already be taken by other Azure users.

