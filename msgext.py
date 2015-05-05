#!/usr/bin/env python

# Configuration section

import codecs
import ConfigParser
import logging
import optparse
import os.path
import re
import sys


HELPTEXT = "%s <options>" % os.path.normpath(sys.argv[0])

def input_files_callback(option, opt_str, value, parser):
	args=[]
	for arg in parser.rargs:
		if arg[0] != "-":
			args.append(arg)
		else:
			del parser.rargs[:len(args)]
			break
	if getattr(parser.values, option.dest):
		args.extend(getattr(parser.values, option.dest))
	setattr(parser.values, option.dest, args)


if __name__ == "__main__":
	parser = optparse.OptionParser(usage=HELPTEXT)
	parser.add_option("-i", "--input", action="callback", dest="inputFiles",
		callback=input_files_callback,
		help="Name of input file or pattern matching files that will be processed")
	parser.add_option("-m", "--msg-dict", action="store", type="string", dest="msgFile",
		help="File with messages that can be localized (.pot file in gettext-parlance). If additional messages are found, a new message file will be created with extension .new")
	parser.add_option("-d", "--debug", action="store", type="int", dest="debug",
		help="Increase logging level")
	(options, args) = parser.parse_args()

	# Check parameters

	# Read messages destined for localization from file
	if not options.msgFile:
		print 'Message file was not specified, aborting ...'
		sys.exit(4)
	else:
		try:
			# Open message file for reading
			options.msgFile = os.path.normpath( options.msgFile )
			msgs = ConfigParser.SafeConfigParser( allow_no_value=True )
			msgs.optionxform = str
			
			if os.path.isfile( options.msgFile ):	
				msgs.readfp( codecs.open(options.msgFile, 'rb', 'utf-8') )
		except IOError:
			print 'Cannot open msg file "%s" for reading, aborting ...' % options.msgFile
			sys.exit(5)
		
		# Open message file with .new extension for writing
		options.msgNewFile = os.path.abspath( options.msgFile + '.new' )

	if not options.inputFiles:
		print 'Input files were not specified, aborting ...'
		sys.exit(7)

	regex = re.compile(r'\{% trans %\}([^\}]*)\{% endtrans %\}')
	# Open input files and extract placeholders for localized messages
	
	for fName in options.inputFiles:
		filePath = os.path.abspath( os.path.normpath( fName ) )
		tail, fileName = os.path.split( filePath )
		
		if not msgs.has_section( fileName ):
			msgs.add_section( fileName )

		INFILE = codecs.open( filePath, 'rb', 'utf-8' )
		
		for line in INFILE.readlines():
			placeholderList = regex.findall( line )
			
			if placeholderList != []:

				for token in placeholderList:
					if not msgs.has_option( fileName, token ) :
						msgs.set( fileName, token, '' )
				### end for token
		### end for line
		
		INFILE.close()
	### end for file
	
	try:
		with codecs.open( options.msgNewFile, 'wb', 'utf-8' ) as msgsNewFile:
			msgs.write(msgsNewFile)
	except IOError:
		print 'Cannot open new msg file %s for writing, aborting ...' % options.msgNewFile
		sys.exit(6)
