#!/bin/bash
# expected format:
# 06/27/2021 21:04 +07 new IP=110.78.179.200


getmail > null

DIR=$"/home/yoo/mail/new/*"
#notify-send -t 15000 -i "/usr/lib/expressvpn/icon.png" "GPON IP STARTS" "GPON"
#echo "HALLO FROM CRON "$DIR  > /home/yoo/scripts/ipaddress

#exit

# getmail directory
#DIR=$"/home/"$USER$"/mail/new/*"

# validate ip function
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

# read all mail files
readarray -d '' entries < <(printf '%s\0' $DIR | sort -zVr)

# iteration logic
for filename in "${entries[@]}"; do
  # do something with $entry
 #echo $filename
  #echo ${filename##*/}

  # extract last line

  line=$(tail -n 1 $filename)
#echo $line
#continue
  # extract the ip
  ip=$(echo $line | cut -d'=' -f 2)
  if ! is_ipvalid "$ip"; then
    #echo " invalid content "$filename
    continue
  fi

    if [[ !  -z  $ip ]] ; then
        notify-send -t 15000 -i "/usr/lib/expressvpn/icon.png" "IP CHANGED" "GPON-IP: \"$ip\""
        echo $ip > /home/yoo/scripts/ipaddress
        echo $ip
    fi

    exit
done

exit









for file in $DIR
do
    echo $file
done


exit
# get the last neuest filename
filename=$(find $DIR -type f -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1)

if [[ -f "$filename" ]]; then
    # read last line
    ip=$(tail -n 1 $filename)

    # check if is a valid ip
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo $ip
        else
        echo "invalid format in "$filename

    fi
fi

