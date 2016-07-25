#!/bin/bash -u

# Tab-separated URLs to fetch
URLS="http://at.farnell.com/	http://at.rs-online.com/	http://www.mouser.at/	http://www.digikey.at/"
# Write data into this file
CSV=frontpage.txt
# Sleep this many seconds between polls
SLEEP=500
# Plus up to this many random seconds (1/2 on average)
RAND_SLEEP=120

# curl has a built-on way to print total request time via "-w"
function curl_time_total {
	# Masquerade as Chrome 51 on Windows 7
	curl \
	--header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" \
	--header "Accept-Encoding: gzip, deflate, sdch" \
	--header "Accept-Language: de-DE,de;q=0.8,en-US;q=0.6,en;q=0.4" \
	--header "Upgrade-Insecure-Requests: 1" \
	--header "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" \
	--silent --location --fail -o /dev/null -w "%{time_total}" \
	$1
}

# time in seconds with two decimal digits or NaN on error.
function time_get {
	t=$(curl_time_total $1)
	if [ $? -eq 0 ]; then
		echo $t
	else
		# curl returned an error
		echo "NaN"
	fi
}

# Set up a sane environment
export LC_ALL=C
cd "$(dirname "$0")"

# Write column header if the CSV is empty or does not exist yet
if [ ! -s $CSV ]; then
	echo "Unixtime	$URLS" >> $CSV
fi

# gather loop
while true; do
	COLS="$(date +%s)"
	for URL in $URLS; do
		COLS="$COLS	$(time_get $URL)"
	done
	echo "$COLS" >> $CSV
	# Also print it out so it gets logged in syslog
	echo "$COLS"
	# Minimum of 500 secs between polls
	sleep $SLEEP
	# Plus some random delay
	sleep $((RANDOM % $RAND_SLEEP))
done
