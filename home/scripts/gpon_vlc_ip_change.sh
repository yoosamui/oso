#!/bin/bash

filename=$"/home/"$USER$"/vlc-playlists/cam.stream.wan"
gpon_script="/home/"$USER$"/scripts/gpon_ip.sh"

current_ip=$("$gpon_script")
echo "current "$current_ip
if [[ $current_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then

    # read the first line from VLC cam.stream
    line=$(head -n 1 $filename)

    echo $line

    # get the firts index of @
    p1=`expr index "$line" @`
    token=${line:$p1:20}

    # get then index of :
    p2=`expr index "$token" :`

    # extract ip
    ip=${token:0:$p2-1}

    if [[ "$current_ip" != "$ip" ]]; then
        if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo "replace "$ip$" with "$current_ip
            sed -i -e "s/$ip/$current_ip/g"  $filename
        fi
    fi
fi
