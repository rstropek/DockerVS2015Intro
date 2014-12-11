#!/bin/sh

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
# time of writing this sample. You have to have at least one VNet
# (can be a dummy vnet). Otherwise creating a new VNet does not work.

prefix="dockersample"
vnetname="${prefix}net"
affinitygroupname="${prefix}ag"
region="North Europe"
storagename="${prefix}vmstorage"
linuxclientname="${prefix}linuxclient"
username="dockersample"
password="P@ssw0rd!"
machinesize="Basic_A1"

# Define Azure affinity group
azure account affinity-group create --location "$region" --label "$prefix" "$affinitygroupname"

# Create storage account for VMs
azure storage account create --affinity-group "$affinitygroupname" --label "$prefix" \
--disable-geoReplication "$storagename"

# Define Azure network
azure network vnet create --affinity-group "$affinitygroupname" "$vnetname"

# Create docker Linux client (also used to create other VMs)
azure vm create --ssh 22 --virtual-network-name "$vnetname" \
--vm-size "$machinesize" $linuxclientname --affinity-group "$affinitygroupname" \
"b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu-14_04-LTS-amd64-server-20140724-en-us-30GB" \
$username $password

