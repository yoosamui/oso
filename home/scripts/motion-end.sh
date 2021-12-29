#!/bin/bash



#now=$(date)
#echo "$now - KILL recording "$1  >> /home/yoo/mmmmm.txt

#processname="motionwriter-"$1
#kill $(($(pgrep $processname))) &

xdotool search --name "cam-"$2 key Escape &




