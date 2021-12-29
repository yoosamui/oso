#!/bin/bash

echo "add sudo"
sh ./add-sudo.sh
echo "add sudo completed"



exit

sh ./add-sudo.sh
sh ./timezone-ntp.sh
sh ./plymouth.sh
sh ./sources_list.sh
sh ./software-ui.sh
sh ./software-full.sh

sh ./copy-files.sh

#sh ./software-extra.sh
#sh ./docker.sh
#sh ./post-install.sh
#sh ./optimizer.sh
#sh ./update-fstab.sh