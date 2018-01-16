#!/usr/bin/env bash

DIRDIR="/Users/derekscott/Mage/dotsync/ui/.ubersicht/nerdbar.widget/scripts/"
BSH="/usr/local/bin/bash"

echo -n $(${BSH} ${DIRDIR}time_script)@
echo -n $(${BSH} ${DIRDIR}date_script)@
echo -n $(${BSH} ${DIRDIR}battery_percentage_script)%@
echo -n $(${BSH} ${DIRDIR}battery_charging_script)@
echo -n $(${BSH} ${DIRDIR}wifi_status_script)@
echo -n $(/usr/local/bin/python3 ${DIRDIR}mail.py)@
echo -n $(${BSH} ${DIRDIR}reminders.sh)@
pmset -g batt | awk '/^ /{print $5}'
