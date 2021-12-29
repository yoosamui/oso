#!/bin/bash

# sub stream cam size
cam_width=640
cam_height=360




# associative array:
declare -A cam_port;
declare -a orders;

# 90
cam_port[gate]=102
# 82
cam_port[center]=202
# 92
cam_port[behind]=302
# 93
cam_port[left]=402
# 81
cam_port[storeroom]=502
# 89
cam_port[entrance]=802

#cam_port[frontleft]=802

orders+=("center")
orders+=("entrance")
orders+=("gate")


#orders+=("frontleft")

#orders+=("left")
#orders+=("storeroom")
#orders+=("behind")

wan="1";
program "ffplay"

for c in "${orders[@]}"; do
    id="${cam_port[$c]}"

        col=$(( cam_width * x ))
        row=$(( cam_height * y ))


                if [ $x -gt 2 ]
                then
                    x=0
                    col=0;


                    ((y++))
                    row=$(( cam_height * y ))

                fi


                ((x++))


if [ ! -z $1 ]
then
if ! [[ $1 == ?(-)+([0-9]) ]]; then
     if [ "$1" != "$c" ]; then
        continue
     fi

fi
fi

    command=$id$" "$c$" "$cam_width$" "$cam_height$" "$wan

    echo "connecting..." $command
 #        continue;
 #//ffplay 'qweqweq"

 ffplay -rtsp_transport tcp 'rtsp://admin:master!31416Pi@192.168.1.88:554/Streaming/channels/102'  &
 #echo $("$program" $command) &

    echo "..."



       timeout=0
       while(($timeout<10))
       do
            window_id=0
            sleep 1
            window_id=$(xdotool search  --name "cam-"$c)
            echo "get window..:" $c$" "$window_id
            if [ ! -z $window_id ]
            then

                if [ $y -gt 0 ]
                then
                    row=$(( row + 120 ))
                fi
               #sleep 6
               xdotool  windowmove $window_id $col $row
               break
            fi

            ((timeout++))

       done


done


echo "done"



