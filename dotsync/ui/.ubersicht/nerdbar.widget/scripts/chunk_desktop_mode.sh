#!/usr/bin/env bash

CURRENTDESKTOP="$(/usr/local/bin/chunkc get _active_desktop)";
CURRENTMODE="$(/usr/local/bin/chunkc get ${CURRENTDESKTOP}_desktop_mode)";
#CURRENTWINDOW="$(~/Mage/dotsync/ui/.ubersicht/nerdbar.widget/scripts/chunkwm-query.py -w)";

if [[ $(/usr/local/bin/chunkc tiling::query --desktops-for-monitor 3) ]]; then
  TDT=$(/usr/local/bin/chunkc tiling::query --desktops-for-monitor 3)
else
  if [[ $(/usr/local/bin/chunkc tiling::query --desktops-for-monitor 2) ]]; then
    TDT=$(/usr/local/bin/chunkc tiling::query --desktops-for-monitor 2)
  else
    TDT=$(/usr/local/bin/chunkc tiling::query --desktops-for-monitor 1)
  fi
fi

FIN=$(grep -Eo '[0-9]+$' <<< $TDT)

if [[ ${CURRENTDESKTOP} != *"connection failed"* ]];then
  echo -n "${CURRENTMODE}@${CURRENTDESKTOP}@${FIN}"
fi
