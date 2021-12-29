#!/bin/bash

pid=$(ps -C motion -o pid=)
echo $pid
if ! [ -z $pid ]
then
   # if [[ $pid == ?(-)+([0-9]) ]]; then

    notify-send -t 15000 -i "/usr/lib/expressvpn/icon.png" "motion reload signal" "motion pid: "$pid
    kill -s SIGHUP $pid
    exit
   # fi

fi


