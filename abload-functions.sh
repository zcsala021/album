# Shell functions
#

read_config_file () {
	# shopt -s extglob
	local configfile=$1 # set the actual path name of your (DOS or Unix) config file
	local configfiletype=$2 # "d" for DOS/Windows, "u" for UNIX
	
	# Check if file exists
	if [ ! -f $configfile ]; then
		return 1
	fi
	
	if [ "$configfiletype" == "d" ]; then
		CFGFILE=$configfile.unix
		touch $CFGFILE
		chmod 0600 $CFGFILE
		tr -d '\r' < $configfile > $CFGFILE
	else
		CFGFILE=$configfile
	fi
	
	while IFS='= ' read lhs rhs
	do
		if [[ ! $lhs =~ ^\ *# && -n $lhs ]]; then
			rhs="${rhs%%\#*}"    # Del in line right comments
			rhs="${rhs%%*( )}"   # Del trailing spaces
			rhs="${rhs%\"*}"     # Del opening string quotes 
			rhs="${rhs#\"*}"     # Del closing string quotes
			rhs="${rhs%"${rhs##*[^ ]}"}"
			export $lhs="$rhs"
		fi
	done < $CFGFILE
	
	if [ "$configfiletype" == "d" ]; then
		rm -f $CFGFILE
	fi
	
	return 0
}