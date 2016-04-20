#!/bin/bash

# Author           : Dominik Kinal ( kinaldominik@gmail.com )
# Created On       : 06.04.2016
# Last Modified By : Dominik Kinal ( kinaldominik@gmail.com )
# Last Modified On : 06.04.2016
# Version          : 1.0
#
# Description      :
# Creates "binary file differences" patches of every file in whole directory.
# Patch file contains data about all differences between "old" and "new" file.
# Patch files are saved in RFC 3284 (VCDIFF) format. (http://www.rfc-base.org/rfc-3284.html)
# Uses Xdelta3 (apt-get install xdelta3) to create patch, Tar and Gzip to compression.
#
# Process:
# 1) Directory structure of "SourceNew" is copied to "tmp" and is filled with all new files. ("New" file is that file which is in "SourceNew" but not in "SourceOld").
# 2) Then "tmp" directory is compressed to "newfiles.tgz" and removed.
# 3) For every file (if it is not "new") in "SourceNew" directory, program creates patch between this file (in "SourceNew") and the one in "SourceOld" and saves it (.patch file) to "out" directory.
# 4) Finally, creates an XML file containing all patch files.
#
#
# Options:
# -h			Help
# -v			Version and Credits
# -x 			Creates also XML file (mentioned in Process point 4)
# -o <directory>	Specify a "SourceOld" directory
# -n <directory>	Specify a "SourceNew" directory
# -t <directory>	Specify a "out" directory
# -z <name>		Specify a .tgz file name (mentioned in Process point 2)
# -l			Creates only an XML file (mentioned in Process point 4)
# -g [0-9]		Changes compression of gzip (0-9 level of compression)
#
#
# Default options are located in patcher_conf.rc
#
# TODO in future:
# Add info about deleted files/directories.
# Applying patch files.
#
#
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)
#
# Xdelta3 Licence:
# Xdelta3 is covered under the terms of the GPL, see COPYING (https://github.com/jmacd/xdelta/blob/release3_1/xdelta3/COPYING).


configFile="patcher_conf.rc"
outDirectory="out/"
oldDirectory="old/"
newDirectory="new/"
gzipCompression=5
tarFileName="newfiles"
createXMLFile=false

if [ -e patcher_conf.rc ]; then
	. $configFile
fi

options="hvxlo:t:n:z:g:"

while getopts $options WYBOR 2 > /dev/null
    do
	case $WYBOR in
	    x) createXMLFile=true
	    o) oldDirectory=$OPTARG;;
	    n) newDirectory=$OPTARG;;
	    t) outDirectory=$OPTARG;;
	    z) tarFileName=$OPTARG;;
	    g) gzipCompression=$OPTARG;; # TODO: Validations
	    h) help
	       exit;;
	    v) echo -en "Patcher\nAutor: Dominik Kinal\nWersja: 1.0\nLicencja: GPL"
	       exit;;
	    ?) echo "Nieprawidłowa opcja, wpisz -h w celu uzyskania pomocy."
	       exit;;
	esac	
    done