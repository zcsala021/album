#!/bin/bash    
#title			:abload-gallery-create.sh
#description	:This script uploads a image to the image hoster abload.de
#author			:Bubelbub <bubelbub@gmail.com>
#date			:20130412
#version		:1.1
#github			:http://github.com/Bubelbub/Abload.de-Tools
#==============================================================================

urlencode() {
	python -c "import sys, urllib as ul; print ul.quote(sys.argv[1])" "$@"
}

# check if parameter 1 is a file
if [ $# -eq 1 ]; then
	GALNAME=`urlencode "$1"`
	GALNAME="-d name=$GALNAME"
	GALDESC=
fi
if [ $# -eq 2 ]; then
	GALNAME=`urlencode "$1"`
	GALNAME="-d name=$GALNAME"
	GALDESC=`urlencode "$2"`
	GALDESC="-d desc=$GALDESC"
fi

ABLDIR=`dirname $0`
ABLFNCS=${ABLDIR}/abload-functions.sh

if [ -f ${ABLFNCS} ]; then
	. ${ABLFNCS}
else
	echo File ${ABLFNCS} does not exist.
	exit 1
fi

ABLCONFIG=${HOME}/.abloadrc
read_config_file ${ABLCONFIG} u

if [ $? -eq 1 ]; then
	echo Error reading config file ${ABLCONFIG}
	exit 1
fi

ABLOAD_COOKIE_FILE=abload-cookies.txt

if [ -d ${HOME}/sys/run ]; then
	COOKIEFILE=${HOME}/sys/run/${ABLOAD_COOKIE_FILE}
else
	COOKIEFILE=/tmp/${ABLOAD_COOKIE_FILE}
fi

# Get root
RESPONSE=`curl -s -c ${COOKIEFILE} -G http://www.abload.de/`

# Hash login
RESPONSE=`curl -s -c ${COOKIEFILE} -G http://www.abload.de/calls/hashlogin.php -d name=${abluser} -d hash=${ablpasshash} -d cookie=1`

if [ "$RESPONSE" != "logged in" ]; then
	echo $RESPONSE
	exit 1
fi

RESPONSE=`curl -s -b ${COOKIEFILE} -c ${COOKIEFILE} -G http://www.abload.de/calls/userXML.php`
# This step can be useful to verify password salt (<setting name="salt" value="saltValue" />)
# echo Response from userXml.php:
# echo $RESPONSE

# Create gallery on Abload.de
RESPONSE=`curl -s -b ${COOKIEFILE} -H "User-Agent: Abloadlib/0.1" -H "Connection: Keep-Alive" -H "Host: www.abload.de" -G 'http://www.abload.de/calls/createGallery.php' $GALNAME $GALDESC`

# Get gallery ID of such freshly created gallery
GALLERYID=`grep -Po '\d+' <<< $RESPONSE`

if [ ! -z $GALLERYID ]; then
	echo $GALLERYID
	exit 0
else
	echo $RESPONSE
	exit 1
fi
