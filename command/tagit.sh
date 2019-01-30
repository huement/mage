#!/bin/bash

if [[ ! -e $1 ]] ; then

 echo 'file missing or not specified'

 exit 0

fi

if [ -z "$2" ]; then

 echo 'file tags not specified'

 exit 0

fi

BLOB="$(echo $2| plutil -convert binary1 - -o - | xxd -p -c 256 -u)"

xattr -xw com.apple.metadata:_kMDItemUserTags $BLOB $1