#!/bin/bash

# ============================================================
#  Creates a demo environment for playing with Docker and
#  Visual Studio 2015 in Microsoft Azure.
#  Author: Rainer Stropek, Azure MVP
#          Twitter: @rstropek
#          Blogs: http://www.software-architects.com, 
#                 http://www.timecockpit.com
# ============================================================

# Note that this script assumes that you have the Azure XPlat
# tools installed and set up. Additionally, you have to select
# a subscription before running this script. More information
# can be found at http://azure.microsoft.com/en-us/documentation/articles/xplat-cli/

# Note that there has been a bug in Azure XPlat tools at the 
# time of writing this sample. You have to have AT LEAST ONE VNet
# (can be a dummy vnet). Otherwise creating a new VNet via Azure
# XPlat tools does not work :-(

prefix="dockersample"
vnetname="${prefix}net"
affinitygroupname="${prefix}ag"
region="North Europe"
storagename="${prefix}vmstorage"
linuxclientname="${prefix}linuxclient"
dockerhostname="${prefix}host"
vsname="${prefix}vs"
username="dockersample"
password="P@ssw0rd!"
machinesize="Basic_A1"
sshkey="sshkey"
ubuntuimage="b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu-14_10-amd64-server-20150416-en-us-30GB"
vsimage="03f55de797f546a1b29d1b8d66be687a__Visual-Studio-2015-Enterprise-RC-AzureSDK-2.6-WS2012R2"

# Ask to make sure we can run
echo ""
echo "WARNING! This script will create a demo environment in Azure for you"
echo "  You HAVE TO MAKE SURE that you have selected an appropriate Azure"
echo "  account before running this script. If you are not sure, read"
echo "  http://azure.microsoft.com/en-us/documentation/articles/xplat-cli/"
echo "  before continuing."
echo ""
echo "This script will perform the following actions:"
echo "  - Create an affinity group '$affinitygroupname'"
echo "    (all resources will be assigned to it)"
echo "  - Create a storage account '$storagename'"
echo "  - Create an SSH key file for passwordless SSH"
echo "  - Create a vnet '$vnetname'"
echo "    (all VMs will be assigned to it)"
echo "  - Create a Linux VM '$linuxclientname'"
echo "    (will also contain a Samba share for file exchange)"
echo "  - Create a Docker Host VM '$dockerhostname'"
echo "  - Create a VS2015 VM '$vsname'"
echo "    (for demo purposes only; not used in the core sample)"
echo ""
echo "Press any key to continue or stop script now ..."
read -n 1 -s

# Define Azure affinity group
azure account affinity-group create --location "$region" --label "$prefix" "$affinitygroupname"

# Create storage account for VMs
azure storage account create --affinity-group "$affinitygroupname" --label "$prefix" \
--type LRS "$storagename"

# Define Azure network
azure network vnet create --affinity-group "$affinitygroupname" "$vnetname"

# Generate SSH key file
if [ ! -f ${sshkey}.key ]; then
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$sshkey".key -out "$sshkey".pem \
		-config createdockerkeys.config
	chmod 600 ${sshkey}.key
fi

# Create docker Linux client (also used to create other VMs)
azure vm create --ssh 22 --virtual-network-name "$vnetname" \
--vm-size "$machinesize" $linuxclientname --affinity-group "$affinitygroupname" \
--ssh-cert ${sshkey}.pem --no-ssh-password "$ubuntuimage" $username 

# Create docker host (note that this will create docker certs, too)
azure vm docker create --ssh 22 --virtual-network-name "$vnetname" \
--vm-size "$machinesize" $dockerhostname --affinity-group "$affinitygroupname" \
--ssh-cert ${sshkey}.pem --no-ssh-password "$ubuntuimage" $username 

# Create VS2015 trial VM (Windows)
# (Just for demo purposes, not part of the core sample. Uncomment
#  if you want to play with VS2015 together with Docker)
# azure vm create --rdp --virtual-network-name "$vnetname" \
# --vm-size "$machinesize" $vsname --affinity-group "$affinitygroupname" \
# "$vsimage" $username $password

# Wait until VMs came up
echo ""
echo "Please check Azure portal and press any key to continue when all VMs are up and running"
read -n 1 -s

# Configure Linux client
ssh -i ${sshkey}.key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
${username}@${linuxclientname}.cloudapp.net "sudo sh" < configureLinuxClient.sh

# Configure Linux Docker host
ssh -i ${sshkey}.key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
${username}@${dockerhostname}.cloudapp.net "sudo apt-get -qqy update"

# Copy Docker certificates
scp -i sshkey.key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -r \
~/.docker dockersample@${linuxclientname}.cloudapp.net:~/.docker

scp -i sshkey.key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -r \
~/.docker dockersample@${dockerhostname}.cloudapp.net:~/.docker

scp -i sshkey.key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -r \
~/.docker dockersample@${linuxclientname}.cloudapp.net:/app/src/.docker
