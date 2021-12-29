#!/bin/bash

// BRAVE INSTALL
sudo apt install apt-transport-https curl

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

sudo apt install brave-browser

// COPY ICONS THEMES

cp -r .icons/ /home/$USER/
cp -r .themes/ /home/$USER/

// copy docklight
sudo cp -r docklight-3.0/ /var/synox/

