#!/usr/bin/env bash

file="/Users/derekscott/Mage/dotsync/ui/.ubersicht/nerdbar.widget/scripts/volume.txt"
compvol=$(osascript -e 'output volume of (get volume settings)')
muted=$(osascript -e 'output muted of (get volume settings)')
while IFS= read line
do
        # display $line or do somthing with $line
	echo "$line@$compvol@$muted"
done <"$file"

rm /Users/derekscott/Mage/dotsync/ui/.ubersicht/nerdbar.widget/scripts/volume.txt
echo $compvol@$muted >> /Users/derekscott/Mage/dotsync/ui/.ubersicht/nerdbar.widget/scripts/volume.txt
