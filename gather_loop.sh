#!/bin/bash -u

cd "$(dirname "$0")"

# time in seconds with two decimal digits or NaN on error.
function time_get {
	t=$(/usr/bin/time --format=%e ./chrome_get.sh $1 2>&1)
	if [ $? -eq 0 ]; then
		echo $t
	else
		# wget returned an error
		echo "NaN"
	fi
}

# Tab-separated URLs to fetch
URLS="http://at.farnell.com/	http://at.rs-online.com/	http://www.mouser.at/	http://www.digikey.at/"

# Write column header
echo "Unixtime	$URLS" >> frontpage.csv

# gather loop
while true; do
	COLS="$(date +%s)"
	for URL in $URLS; do
		COLS="$COLS	$(time_get $URL)"
	done
	echo "$COLS" >> frontpage.csv
	sleep 60
done
