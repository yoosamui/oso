#!/bin/bash

apt update 
apt upgrade -y

# skype
apt update
echo "install skype" 
wget https://repo.skype.com/latest/skypeforlinux-64.deb
skype_path=$('skypeforlinux-64.deb')
sudo dpkg -i ${skype_path}
rm -f ${skype_path}

