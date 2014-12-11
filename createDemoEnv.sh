#!/bin/sh

# ============================================================
#  Creates a demo environment for playing with Docker and
#  Visual Studio 2015 in Microsoft Azure.
#  Author: Rainer Stropek, Azure MVP
#          Twitter: @rstropek
#          Blogs: http://www.software-architects.com, 
#                 http://www.timecockpit.com
# ============================================================

vnetname = "$1"

if [ "$vnetname" == "" ]; then
	echo "USAGE: createDemoEnv.sh vnetname"
	exit 1
fi
