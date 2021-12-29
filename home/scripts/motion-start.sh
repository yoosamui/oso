#!/bin/bash

#now=$(date)
#echo "$now - starting recording "$1  >> /home/yoo/motion-files/mmmmm.txt

if [ -z $1 ]
then
exit
fi


processname="motionwriter-"$1
#pid=$(pgrep $processname)
pid=$(ps -C $processname -o pid=)

if [ ! -z  $pid ]
then
echo "proc allready run "$pid
xdotool search --name "cam-"$2 key Escape &
exit
fi

path=$"/media/yoo/develop/of_v0.11.0_linux64gcc6_release/apps/myApps/motion-writer/bin/"

width="640"
height="360"
channel=""
lanwan="1"

#notify-send -t 5000 -i "/usr/lib/expressvpn/icon.png" "Motion detection" "CAM: \"$2\""
cd $path

case $1 in
# upstairs
  "1")
   channel="602"
    ;;
# gate
  "2")
    channel="102"
    ;;
# entrance
  "3")
    channel="802"
    ;;
# center
  "4")
    channel="202"
    ;;
# storeroom
  "5")
    channel="502"
    ;;
# left
  "6")
    channel="402"
    ;;
# behind
  "7")
    channel="302"
    ;;

  *)
#    STATEMENTS
    ;;
esac



params=$" "$channel$" "$2$" "$width$" "$height$" "$lanwan
./motionwriter-$1$params &

#	writer=$($"./motionwriter-"$1$params ) &

###-eof-###
