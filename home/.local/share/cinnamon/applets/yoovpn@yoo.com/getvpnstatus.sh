#!/bin/bash
#shopt -s extglob

script="/usr/bin/expressvpn"
text=$("$script" "status" | head -n 3)

line=$(echo "${text:10}" | sed -e '1q;d')

if [[ $text == *"A new version is available"* ]]; then

    status=$(echo "$text" | sed '3q;d')

    echo $status
    echo $line

else


    echo $line

fi
exit





/////////////////////////////////////////////
echo "${text:10}" | sed -e 's/^[ \t]*//'
#echo "${text##*( ):10}" | sed -e 's/^[ \t]*//'
echo "${text:40}" | sed  '3q;d'
exit


output="${text:10}" | sed -e 's/^[ \t]*//'

echo $output

if [[ $text == *"Connected to"* ]]; then
echo " CONNNECTED "$output
else
echo "DISCO"
fi

#shopt -u extglob
exit



if [[ $text == *"A new version is available"* ]]; then

        con=""${text:10}

        text=$("$script" "status" | head -n 3)

        if [[ $text == *"Not connected"* ]]; then
            echo ${text:10}
            exit
        fi

        echo ""${text:108}
        echo $con

else

    if [[ $text == *"Connected to"* ]]; then
        echo ${text:10}
    else

        echo "Disconnected "
    fi


fi

exit





