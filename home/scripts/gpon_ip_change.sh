#!/bin/bash

is_ipvalid() {
  # Set up local variables
  local ip=${1:-1.2.3.4}
  local IFS=.; local -a a=($ip)
  # Start with a regex format test
  [[ $ip =~ ^[0-9]+(\.[0-9]+){3}$ ]] || return 1
  # Test values of quads
  local quad
  for quad in {0..3}; do
    [[ "${a[$quad]}" -gt 255 ]] && return 1
  done
  return 0
}

if [[ -f ".ipaddress" ]]
then
    OLDIP=$(cat .ipaddress)
fi

NEWIP=$(curl -s http://ifconfig.me/ip)

if is_ipvalid "$NEWIP"; then
  echo "current ip is valid  ($NEWIP)"

else
  echo "ip mailformed. fail ($NEWIP)"
  exit 1
fi

if [[ "$OLDIP" != "$NEWIP" ]]
then
    echo $NEWIP | tee .ipaddress

#mail -s "GPON" moo4pi@gmail.com < $NEWIP
#echo $NEWIP | mail -s "GPON ip changed " moo4pi@gmail.com
now=$(date +'%m/%d/%Y %H:%M %:::z ')
#now=$(date +"%Z %:::z")

echo $now$"new IP="$NEWIP | mail -s "GPON ip changed " moo4pi@gmail.com

echo "IP changed "$OLDIP$" to "$NEWIP



    #sendEmail -f $RASPBERRY_EMAIL -t $EMAIL_ADDRESS -s $SMTP_HOST -u $EMAIL_SUBJECT -xu $RASPBERRY_EMAIL -xp $RASPBERRY_PASSWORD -m "$MESSAGE" -o tls=yes
fi


