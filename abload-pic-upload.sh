#!/bin/bash -       
#title			:abload-pic-upload.sh
#description	:This script uploads a image to the image hoster abload.de
#author			:Zoltan Csala
#github			:https://github.com/zcsala021/album
#=========================================================================

# check if parameter 1 is a file
if [ "$1" == "" ] || [ ! -f $1 ]; then
	echo "(E) Parameter 1 should be a (image) file."
	exit 1
fi

# check parameter 2 - optional gallery ID
if [ "$2" != "" ]; then
	GALLERY="-F gallery=$2"
fi

ABLOAD_COOKIE_FILE=abload-cookies.txt

if [ -d ${HOME}/sys/run ]; then
	COOKIEFILE=${HOME}/sys/run/${ABLOAD_COOKIE_FILE}
else
	COOKIEFILE=/tmp/${ABLOAD_COOKIE_FILE}
fi

RESPONSE=`curl -F "img0=@$1" -F "resize=none" -F "delete=never" $GALLERY -s -b ${COOKIEFILE} -c ${COOKIEFILE} http://www.abload.de/upload.php`
# echo $RESPONSE > ${HOME}/tmp/response.txt

# grab the key
KEY=`grep -Po '(?<=name="key" value=")([A-Za-z0-9]+)(?=")' <<< $RESPONSE`

# get the image list in html format
IMAGESHTML=`curl -s -b ${COOKIEFILE} -c ${COOKIEFILE} "http://www.abload.de/uploadComplete.php?key=$KEY"`

# get direct link in plain text
IMGURL=`grep -Po '(?<=")http://abload.de/img/([A-Za-z0-9._,% -]+)' <<< $IMAGESHTML`

# output direct link
if [ ! -z $IMGURL ]; then
	echo $IMGURL
	exit 0
else
	exit 1
fi

