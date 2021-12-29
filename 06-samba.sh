#!/bin/bash

apt update 
apt upgrade -y

# samba 

apt install --fix-missing \
samba \
smbclient \
cifs-utils \
nfs-common -y

echo "[shared]" >>  /etc/samba/smb.conf
echo "path = /media/"$USER"/shared" >>  /etc/samba/smb.conf
echo "valid users = $USER" >>  /etc/samba/smb.conf
echo "read only = no" >>  /etc/samba/smb.conf
cat /etc/samba/smb.conf
echo "Please enter the password for samba. User="$USER
sudo smbpasswd -a $USER

echo "done"
