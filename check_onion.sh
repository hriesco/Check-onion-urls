#!/bin/bash

if [[ $# != 2 ]]; then 
	echo "Usage:" $0 " <file_with_onion_urls> <file_output_onions_found>"
	exit 1
fi
if [ ! -f $1 ]; then
	echo "File not found"
	exit 1
fi

proxy_tor="127.0.0.1:9050"

while read line
do
	if [[ "$line" == *"http"* ]]; then
		url=$(echo $line | grep -o 'https*://[^"]*onion*' | awk '{print $1}')
		status=$(curl --socks5-hostname $proxy_tor -o /dev/null -w '%{http_code}' $url)
		if [[ "$status" == *"200"* ]]; then
			echo $line "OK" >> $2
		fi	
	fi
done < $1 
