#!/bin/bash
docker run -e VSTS_ACCOUNT=rainerdemotfs-westeu -e VSTS_TOKEN=tq7tiaqbrjomwk47fsnebv6r5mgs5ggmmlvnnsh273l2hdntju7a -v /var/run/docker.sock:/var/run/docker.sock microsoft/vsts-agent
