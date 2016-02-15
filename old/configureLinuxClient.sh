#!/bin/bash

# Ensure everything is up to date
apt-get -qqy update

# Install and configure Samba for file sharing
apt-get -qqy install samba
mv /etc/samba/smb.conf /etc/samba/smb.conf.backup
printf "[global]\nworkgroup = DOCKERSAMPLE\nsecurity = user\nmap to guest = Bad Password\nguest account = nobody\n\n[appSrc]\ncomment = App Files\npath = /app/src\nbrowsable = yes\nguest ok = yes\nread only = no\ncreate mask = 0755\n" \
 | tee /etc/samba/smb.conf
mkdir -p /app/src
chown nobody.nogroup /app/src/
chmod a+w /app/src
restart smbd
restart nmbd

# Install Docker
curl -sSL https://get.docker.com/ubuntu/ | sh

