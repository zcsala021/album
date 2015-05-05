#!/bin/bash -       
#title			:login.sh
#description	:Log in the image hoster abload.de
#author			:Bubelbub <bubelbub@gmail.com>
#date			:20130412
#version		:1.0
#github			:http://github.com/Bubelbub/Abload.de-Tools
#==============================================================================

# check if parameter 1 is a config file name, parameter 2 is optional debug
if [ "$1" != "" -a "$1" == "-d" ]; then
	DEBUG=1
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
ABLOADHOST=abload.de

# login
RESPONSE=`curl -s -F "name=${abluser}" -F "password=${ablpassword}" -F "cookie=on" -b ${COOKIEFILE} -c ${COOKIEFILE} http://www.abload.de/login.php?next=/`

if [[ $RESPONSE =~ 'login_php' ]]; then
	[ "$DEBUG" == "1" ] && echo "Login to ${ABLOADHOST} failed."
	exit 1
else
	[ "$DEBUG" == "1" ] && echo "Logged in successfully to ${ABLOADHOST} as $abluser."
	exit 0
fi
