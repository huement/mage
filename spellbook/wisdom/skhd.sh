#!/usr/bin/env bash

DisplayInfo() {
  echo "${B_YLW}${BLK}  SKHD - Keyboard Shortcuts  ${NORMAL}";
echo -n "${BGRN}close focused window${NORMAL}
alt - w : chunkc tiling::window --close

${BGRN}equalize size of windows${NORMAL}
shift + alt - 0 : chunkc tiling::desktop --equalize
${BGRN}swap window${NORMAL}
shift + alt - [h,j,k,l] : chunkc tiling::window --swap <dir>
${BGRN}move window${NORMAL}
shift + cmd - [h,j,k,l] : chunkc tiling::window --warp <dir>

${BGRN}send window to desktop${NORMAL}
shift + alt - [z,c] : chunkc tiling::window --send-to-desktop <prev, next>
shift + alt - 1 : chunkc tiling::window --send-to-desktop 1
${BGRN}increase region size${NORMAL}
shift + alt - [a,s,w,d] : chunkc tiling::window --use-temporary-ratio 0.1 --adjust-window-edge <dir>
${BGRN}decrease region size${NORMAL}
shift + cmd - [a,s,w,d] : chunkc tiling::window --use-temporary-ratio 0.1 --adjust-window-edge <dir>

${BGRN}rotate tree${NORMAL}
alt - r : chunkc tiling::desktop --rotate 90
${BGRN}mirror tree y-axis${NORMAL}
alt - [x,y] : chunkc tiling::desktop --mirror <hor,vert>
${BGRN}toggle desktop offset${NORMAL}
alt - a : chunkc tiling::desktop --toggle offset
${BGRN}toggle window fullscreen${NORMAL}
alt - f : chunkc tiling::window --toggle fullscreen
"
  echo ""
}
