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
BEGINTRANS = '{% trans %}'
ENDTRANS = '{% endtrans %}'

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
	parser.add_option("-o", "--output", action="store", type="string", dest="outputDir",
		help="Directory where program's output will be stored")
	parser.add_option("-m", "--msg-dict", action="store", type="string", dest="msgFile",
		help="File with localized messages")
	parser.add_option("-d", "--debug", action="store", type="int", dest="debug",
		help="Increase logging level")
	(options, args) = parser.parse_args()

	# Check parameters
	
	# Check if output directory exists
	if not options.outputDir:
		print 'No output directory was specified, aborting ...'
		sys.exit(2)
	else:
		if not os.path.isdir( options.outputDir ):
			print 'Output directory "%s" does not exist, aborting ...' % options.outputDir
			sys.exit(3)
		else:
			options.outputDir = os.path.abspath( os.path.normpath( options.outputDir ) )

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
				# Read configuration file
				msgs.readfp( codecs.open(options.msgFile, 'rb', 'utf-8') )
		except IOError:
			print 'Cannot open msg file "%s" for reading, aborting ...' % options.msgFile
			sys.exit(5)

	if not options.inputFiles:
		print 'Input files were not specified, aborting ...'
		sys.exit(7)

	# Compile regular expression that will find strings that need
	# to be localized
	regex = re.compile(r'\{%\s*trans\s*%\}([^\}]*)\{%\s*endtrans\s*%\}')
	
	# Open input files and extract placeholders for localized messages
	
	for fName in options.inputFiles:
		filePath = os.path.abspath( os.path.normpath( fName ) )
		tail, fileName = os.path.split( filePath )

		INFILE = codecs.open( filePath, 'rb', 'utf-8' )
		# Create output file, with all strings localized
		outFilePath = os.path.join(options.outputDir, fileName)
		
		try:
			OUTFILE = codecs.open( outFilePath, 'wb', 'utf-8' )
		except IOError:
			print 'Cannot open file "%s" for writing, aborting ...' % outFilePath
			sys.exit(8)
			
		for line in INFILE.readlines():
			# Find strings that need to be localized
			placeholderList = regex.findall( line )
			
			newLine = line
			if placeholderList != []:

				for token in placeholderList:
					if msgs.has_option( fileName, token ):
						strTrans = msgs.get( fileName, token )
						if strTrans == '':
							strTrans = token
						toBeReplaced = BEGINTRANS + token + ENDTRANS
						newLine = newLine.replace( toBeReplaced, strTrans )
				### end for token
			OUTFILE.write( newLine )
		### end for line
		
		INFILE.close()
		OUTFILE.close()
	### end for file
