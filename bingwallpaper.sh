#!/usr/bin/env bash
#Market options: en-IN, en-US, zh-CN, ja-JP, en-AU, en-UK, de-DE, en-NZ
#Resolution options: 1366×768, 1920×1080, 1920×1200
#NeedHistory (Old Images to be stored): true, false
Market="en-IN"
Resolution="1920x1080"
Directory="$HOME/Pictures/Bing Wallpaper/"
FileName="wallpaper.jpg"
NeedHistory=true

#Verifying Connectivity
while ! ping -c 1 bing.com > /dev/null 2>&1; do
	echo -e "\x1B[93m Waiting for internet connectivity to continue... \x1b[0m"
	sleep 10;
done;

mkdir -pv "$Directory"

URL=($(curl -s 'http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt='"$Market" | sed -e 's/^.*"urlbase":"\([^"]*\)".*$/\1/'))
ImageURL="http://www.bing.com"/$URL"_"$Resolution".jpg"

if [ -f "$Directory/$FileName" ]; then
	fileDate=($(stat -f "%Sm" -t "%Y%m%d" "$Directory"/$FileName))
	todayDate=($(date +"%Y%m%d"))
	if [ $todayDate = $fileDate ]; then
		echo -e "\x1B[35m You already have today's Bing image \x1b[0m"
	else
		if $NeedHistory ; then
			echo -e "\x1B[35m Keeping old image history. \x1b[0m"
			mv "$Directory/$FileName" "$Directory/$todayDate.jpg"
		fi
		echo -e "\x1B[35m Downloading Bing image to: $Directory \x1b[0m"
		curl -so "$Directory/$FileName" "$ImageURL"
	fi
else
	echo -e "\x1B[35m Downloading New Bing image to: $Directory \x1b[0m"
	curl -so "$Directory/$FileName" "$ImageURL"
fi
while [ ! -f "$Directory/$FileName" ] ; do
	echo -e "\x1B[35m Waiting for Bing image to finish downloading... \x1b[0m"
	sleep 10;
done;
#osascript -e "tell application \"System Events\" to set picture of every desktop to \"/Library/Desktop Pictures/Solid Colors/Solid Gray Dark.png\""
osascript -e "tell application \"System Events\" to set picture of every desktop to \"$Directory/$FileName\""

echo -e "\x1B[32m Completed \x1b[0m"
