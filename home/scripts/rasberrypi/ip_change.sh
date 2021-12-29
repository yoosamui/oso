#!/bin/bash

IPFILE=/root/ipaddress
CURRENT_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)

if [ -f $IPFILE ]; then
KNOWN_IP=$(cat $IPFILE)
else
KNOWN_IP=
fi


if [ "$CURRENT_IP" != "$KNOWN_IP" ]; then
echo $CURRENT_IP > $IPFILE

mail -a "From: GPON <moo4pi@gmail.com>"  -s "Changed Public IP on $(date)" moo4pi@gmail.com < $IPFILE


#mail -a "From: GPON <serenapatioinfo@gmail.com>"  -t "moo4pi@gmail.com" -s "Changed Public IP on $(date)" serenapatioinfo@gmail.com < $IPFILE
#mail -a "From: GPON <serenapatioinfo@gmail.com>" -s "Changed Public IP on $(date)" j-gonzalez@email.de < $IPFILE


logger -t ext_ipcheck -- IP changed to $CURRENT_IP
else
logger -t ext_ipcheck -- NO IP Change
fi




