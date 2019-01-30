#!/bin/bash

if [[ ! -e $1 ]] ; then

 echo '["no_file"]'

 exit 0

fi

JSON="$(xattr -p com.apple.metadata:_kMDItemUserTags $1 | xxd -r -p | plutil -convert json - -o -)"

IFS="," tag_split=("${JSON:1:${#JSON}-2}")

#echo -n "["
JSONSTRING="[";
ATRING="";

for i in ${tag_split[@]}

do

 #echo -n "$i",
 ATRING+="${i},";

done

#echo "]"
BSTRING="]";

AASTRING=${ATRING/\,]/\]};

echo "[${AASTRING}]";
# mdls -raw -name kMDItemUserTags "file.txt"
