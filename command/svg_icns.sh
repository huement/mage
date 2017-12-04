#!/usr/bin/env bash

#
# Turn any SVG file into an MacOS compatible .icns file!
# Usage:   svg2icns filename.svg
#
# Add an alias for easier converting!
# alias svgicns='~/Mage/command/svg_icns.sh'

box() { t="$1xxxx";c=${2:-=}; echo ${t//?/$c}; echo "$c $1 $c"; echo ${t//?/$c}; }

box "    SVG -to- ICNS    "

if [ "$#" -ne 1 ]; then
    echo "[FAIL] Required param missing!"
    echo -e "\nUsage:   svg2icns filename.svg\n\n"
    exit 100
fi

filename="$1"
name=${filename%.*}
ext=${filename##*.}

echo ""

scriptPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
dest="$name".iconset
final="$name".icns
displayName=$(basename "$dest")
mkdir "$dest"

echo "[INFO] processing: $displayName .  .   ."

convert -background none -resize '!16x16' "$1" "$dest/icon_16x16.png"
convert -background none -resize '!32x32' "$1" "$dest/icon_16x16@2x.png"
cp "$dest/icon_16x16@2x.png" "$dest/icon_32x32.png"
convert -background none -resize '!64x64' "$1" "$dest/icon_32x32@2x.png"
convert -background none -resize '!128x128' "$1" "$dest/icon_128x128.png"
convert -background none -resize '!256x256' "$1" "$dest/icon_128x128@2x.png"
cp "$dest/icon_128x128@2x.png" "$dest/icon_256x256.png"
convert -background none -resize '!512x512' "$1" "$dest/icon_256x256@2x.png"
cp "$dest/icon_256x256@2x.png" "$dest/icon_512x512.png"
convert -background none -resize '!1024x1024' "$1" "$dest/icon_512x512@2x.png"

iconutil -c icns "$dest"
rm -R "$dest"

echo "[ OK ] Finished $displayName!"
mkdir -p "$scriptPath/icns"
mv "$final" "$scriptPath/icns"
echo "[ OK ] Saved to Mage Folder! $scriptPath/icns/$displayName"