#!/bin/bash

# Assuming you name the file pushover.sh, place somewhere within your $PATH, then chmod +x /path/to/pushover.sh
# Invoke with: pushover.sh [-d device_name] [-t Title] [-u Url] [-ut URL Title] [-p] [-ts timestamp] "notifcation text"

token="a9h4a9n1jrb8wirn17x3vj97c5cwov"
user="ui7s5mj8wtks3nxbdbswk3e95fbgu1"
#curl -s --form-string "token=a9h4a9n1jrb8wirn17x3vj97c5cwov" --form-string "user=ui7s5mj8wtks3nxbdbswk3e95fbgu1" --form-string "title=$1" --form-string "message=$2" --from-string "url=twitter://direct_message?screen_name=someuser" https://api.pushover.net/1/messages.json
#curl -s --form-string "device=cameras" --form-string "token=a9h4a9n1jrb8wirn17x3vj97c5cwov" --form-string "user=ui7s5mj8wtks3nxbdbswk3e95fbgu1" --form-string "title=$1" --form-string "message=$2" --form-string "url=twitter://direct_message?screen_name=someuser" https://api.pushover.net/1/messages.json
link="https://www.dropbox.com/sh/wfvx5arq2znr2wa/AABt1mHlvSFK0J8ak4HCglC-a?dl=0"
curl -s --form-string "token=a9h4a9n1jrb8wirn17x3vj97c5cwov" --form-string "user=g89zsercfb5mjdmvy1mpwr2u3t6ugs" --form-string "title=$1" --form-string "message=$2" --form-string url=$link https://api.pushover.net/1/messages.json
exit

#test -f ~/.pushover && source ~/.pushover # Put your API token and user key here


title="Camera gate MESSAGE"
message="detection"
params=( -d token=$token -d user=$user )

while [ $# -gt 0 ]
do
    case "$1" in
	-d)
	    shift
	    params=( "${params[@]}" --data-urlencode device="$1" )
	    shift
	    ;;
	-t)
	    shift
	    params=( "${params[@]}" --data-urlencode title="$1" )
	    shift
	    ;;
	-u)
	    shift
	    params=( "${params[@]}" --data-urlencode url="$1" )
	    shift
	    ;;
	-ut)
	    shift
	    params=( "${params[@]}" --data-urlencode url_title="$1" )
	    shift
	    ;;
	-s)
	    shift
	    params=( "${params[@]}" --data-urlencode sound="$1" )
	    shift
	    ;;
	-p)
	    shift
	    params=( "${params[@]}" -d priority=1 )
	    ;;
	-q)
	    shift
	    params=( "${params[@]}" -d priority=-1 )
	    ;;
	-ts)
	    shift
	    params=( "${params[@]}" --data-urlencode timestamp="$1" )
	    ;;
	*)
	    message="$1"
	    shift
	    ;;
    esac
done

notify-send "$message"

# uncomment these lines to send to email instead
# echo "$message" | mail -s "Pushover: $title" `whoami`
# exit $?

params=( "${params[@]}" --data-urlencode message="$message" )
curl -s -S "${params[@]}" https://api.pushover.net/1/messages.json && echo

## Gist: 5544874
##
## Copyright (c) 2013, Daniel Ray Jones
## All rights reserved.
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##
## 1. Redistributions of source code must retain the above copyright notice, this
##    list of conditions and the following disclaimer.
##
## 2. Redistributions in binary form must reproduce the above copyright notice,
##    this list of conditions and the following disclaimer in the documentation
##    and/or other materials provided with the distribution.
##
## 3. The name of the author may not be used to endorse or promote products derived
##    from this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
## WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
## SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
## OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
## INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
## CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
## IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
## OF SUCH DAMAGE.
