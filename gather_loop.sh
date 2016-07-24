#!/bin/bash -u

cd "$(dirname "$0")"

# time in seconds with two decimal digits or NaN on error.
function time_get {
	t=$(/usr/bin/time --format=%e ./chrome_get.sh $1 2>&1)
	if [ $? -eq 0 ]; then
		echo $t
	else
		# wget returned an error.
		echo "NaN"
	fi
}

# gather loop
while true; do
	farnell=$(time_get http://at.farnell.com/)
	rs=$(time_get http://at.rs-online.com/)
	mouser=$(time_get http://www.mouser.at/)
	digikey=$(time_get http://www.digikey.at/)
	t=$(date +%s)
	echo "$t	$farnell	$rs	$mouser	$digikey" #>> frontpage.csv	
	exit 0
	sleep 60
done
