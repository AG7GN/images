#!/bin/bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+   ${SCRIPT_NAME} [-hv] 
#+   ${SCRIPT_NAME} USER@HOST 
#+   ${SCRIPT_NAME} [-n NAME] [-k FILE] [-m RECIPIENT[,RECIPIENT]...] [-p PORT] USER@HOST
#%
#% DESCRIPTION
#%   This script makes a compressed and zipped image file of a remote 
#%   Raspberry Pi's (the source's) microSD card over an SSH connection.  The
#%   resulting ZIP file will be stored on the host running this script (the 
#%   destination). The script will log it's activity to /dev/stdout upon 
#%   completion or error. ZIP files of the same name will be overwritten 
#%   without warning.
#%
#% COMMANDS (required)
#%    USER@HOST                   USER is user on remote host with NOPASSWD 
#%                                sudo privileges (usually 'pi').
#%                                HOST is the fully qualified domain name or 
#%                                IP address of the remote host from which you 
#%                                want to make an image.
#%  
#% OPTIONS
#%    -h, --help                  Print this help
#%    -v, --version               Print script information
#%    -n NAME, --name=NAME	Name of the source host (example: myraspberrypi)
#%                                Default: HOST in USER@HOST command
#%    -k FILE, --key=FILE         SSH private key file.  
#%                                Default: $HOME/.ssh/id_rsa
#%    -m RECIPIENT[,RECIPIENT]..., --mail=RECIPIENT[,RECIPIENT]...
#%                                Mail results of image backup
#%                                to one or more RECIPIENT email addresses. 
#%                                Separate each address with a comma. 
#%    -p PORT, --port=PORT        Connect to HOST using this port. Default:22
#% 
#% REQUIREMENTS
#%    The remote host you are creating an image of (the source) must have the
#%    ssh pubic key of the host on which you are running this script (the 
#%    destination) installed in the source's authorized_keys file. 
#%    This script is designed to run as a cron job, so the key must either be 
#%    passphrase-less or the destination host must use an enabled keychain 
#%    (example: https://www.funtoo.org/Keychain) so the destination will not 
#%    be prompted to enter the passphrase. This script will automatically use 
#%    $HOME/.keychain/$HOSTNAME-sh if it exists.
#%
#%    The destination host must have available disk space of twice
#%    the size of the source's microSD card.  The majority of the needed disk
#%    space is used during the shrinking and truncating process, and that disk
#%    space is freed up when the script completes. The resulting ZIP file is
#%    considerably smaller than the actual image.
#%                 
#%    This script should be run by a regular user, but the user or a group of 
#%    which the user is a member must have sudo NOPASSWD access to these apps: 
#%    
#%        parted, losetup, fsck, e2fsck, resize2fs, truncate.
#%
#%    Using the -m option to mail script results requires pat and patmail.sh.
#%    pat is a Winlink email client. patmail.sh allows you to use pat in 
#%    scripts. More information:
#%        pat: 
#%            https://getpat.io
#%        patmail.sh: 
#%            https://github.com/AG7GN/hampi-utilities/blob/master/patmail.sh
#%
#% EXAMPLES
#%    Make an image of host mypi.local, compress it into a zip file at 
#%    $HOME/mypi.local.zip:
#%
#%      ${SCRIPT_NAME} pi@mypi.local
#%
#%    Make an image of host mypi.local, compress it into a zip file at 
#%    $HOME/mypi.local.zip.  Use the SSH private key at $HOME/.ssh/id_rsa and 
#%    Send log output to $HOME/mypi.log rather than /dev/stdout.
#%
#%      ${SCRIPT_NAME} -k $HOME/.ssh/id_rsa pi@mypi.local >$HOME/mypi.log 2>&1
#%
#%    Make an image of host mypi.local via an ssh connection to port 222, 
#%    compress it into a zip file and store it at $HOME/mypi.zip.  Mail the 
#%    script log to me@example.com:
#%
#%      ${SCRIPT_NAME} -p 222 -n mypi -m me@example.com pi@mypi.local
#%
#================================================================
#- IMPLEMENTATION
#-    version         ${SCRIPT_NAME} 2.0.3
#-    author          Steve Magnuson, AG7GN
#-    license         CC-BY-SA Creative Commons License
#-    script_id       0
#-
#================================================================
#  HISTORY
#     20200622 : Steve Magnuson : Script creation
# 
#================================================================
#  DEBUG OPTION
#    set -n  # Uncomment to check your syntax, without execution.
#    set -x  # Uncomment to debug this shell script
#
#================================================================
# END_OF_HEADER
#================================================================

SYNTAX=false
DEBUG=false
Optnum=$#

#============================
#  FUNCTIONS
#============================

function cleanUp() {
	if [[ $LOOP != "" ]] && sudo $(command -v losetup) $LOOP >/dev/null 2>&1
	then
		sudo $(command -v losetup) -d "$LOOP" 
	fi
}

function TrapCleanup() {
	[[ -d "${TMPDIR}" ]] && rm -rf "${TMPDIR}/"
	cleanUp
	[ -s $GZIPIMAGE ] && rm -f $GZIPIMAGE
	#trap - ERR
}

function SafeExit() {
  # Mail the log file if recipients were provided.
  [[ $RECIPIENTS != "" ]] && mailLog pat
  cat $LOG
  TrapCleanup
  trap - INT TERM EXIT
  exit
}

function ScriptInfo() { 
	HEAD_FILTER="^#-"
	[[ "$1" = "usage" ]] && HEAD_FILTER="^#+"
	[[ "$1" = "full" ]] && HEAD_FILTER="^#[%+]"
	[[ "$1" = "version" ]] && HEAD_FILTER="^#-"
	head -${SCRIPT_HEADSIZE:-99} ${0} | grep -e "${HEAD_FILTER}" | \
	sed -e "s/${HEAD_FILTER}//g" \
	    -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g" \
	    -e "s/\${SPEED}/${SPEED}/g" \
	    -e "s/\${DEFAULT_PORTSTRING}/${DEFAULT_PORTSTRING}/g"
}

function Usage() { 
	printf "Usage: "
	ScriptInfo usage
	exit
}

function Die () {
	echo "${*}"
	exit 1
}

function mailLog () {
	SUBJECT="$NAME backup status for $(date "+%A, %B %e %Y")"
	MAIL_TYPE="${1^^}"
	case $MAIL_TYPE in
		PAT)
			# Following commands are for patmail.sh
			if command -v patmail.sh >/dev/null 
			then
				[ -s "$LOG" ] && cat "$LOG" | patmail.sh $RECIPIENTS "$SUBJECT" telnet
			else
				echo "patmail.sh is required for mail option."
			fi
			;;
		*)
			# You must have a mail agent configured for this to work.
			# Following 2 commands are for standard sendmail
			SENDER="From: $SENDER"
			[ -s "$LOG" ] && cat "$LOG" | mail -s "$SUBJECT" -a "$SENDER" $(echo "$RECIPIENTS" | tr ',' ' ')
			;;
	esac
}

function fixOrphans () {
   echo >&2 "   Fixing orphaned inodes in $STOREDIMAGE..."
   echo >&2 -n "      parted: Getting partition information..."
   PARTED_OUTPUT=$($PARTED -ms "$STOREDIMAGE" unit B print  | tail -n 1)
   (( $? == 0 )) && echo >&2 "OK" || { echo >&2 "parted FAILED"; return 1; }
   PARTNUM=$(echo "$PARTED_OUTPUT" | cut -d ':' -f 1)
   PARTSTART=$(echo "$PARTED_OUTPUT" | cut -d ':' -f 2 | tr -d 'B')
   echo >&2 "         Partition=$PARTNUM   Partition Start=$PARTSTART"
   echo >&2 -n "      losetup: Set up a loopback..."
   LOOP=$($LOSETUP -f --show -o $PARTSTART "$STOREDIMAGE" )
   (( $? == 0 )) && echo >&2 "$LOOP ready." || { echo >&2 "losetup FAILED"; return 1; }
   echo >&2 -n "      Running \"fsck -y "$LOOP"\"..."
   $FSCK -y "$LOOP" || { cleanUp; echo >&2; echo >&2; return 1; }
   echo >&2 -n "      losetup: Remove loopback $LOOP ..."
   $LOSETUP -d "$LOOP" >&2
   (( $? == 0 )) && echo >&2 "OK" || { echo >&2 "losetup FAILED"; return 1; }
   echo >&2 "   Orphaned inodes fixed."
   return 0
}

function Shrink() {

	#Usage checks
	if [[ ! -f "$STOREDIMAGE" ]]; then
   	echo >&2 "ERROR: $STOREDIMAGE is not a file."
   	return 1
	fi
	
	local SPAREBLOCKS=25000
	local BLOCK_SIZE=4096
	local COUNTER=0
	local TRIES=4

	# Prepare and shrink the image
	while (( $COUNTER <= $TRIES )) 
	do # It might take multiple passes to shrink the image.  Try up to 4 times
   	let COUNTER=COUNTER+1
		echo >&2 "$(date): Preparing image for shrinking: Pass #$COUNTER"
		echo >&2 -n "   parted: Determine Start location for partition 2:  "
		RESULT="$($PARTED -m $STOREDIMAGE unit B print | grep "^2.*ext")"
		START="$(echo "$RESULT" | tail -n 1 | cut -d: -f2 | tr -d 'B')"
		END="$(echo "$RESULT" | tail -n 1 | cut -d: -f3 | tr -d 'B')"
		SIZE="$(echo "$RESULT" | tail -n 1 | cut -d: -f4 | tr -d 'B')"
		echo >&2 "Start = $START Bytes    End = $END Bytes    Size = $SIZE Bytes"
		echo >&2 "   Setting up loopback using: $LOSETUP -f --show -o $START $STOREDIMAGE ..."
		LOOP="$($LOSETUP -f --show -o $START $STOREDIMAGE)"
		if (( $? == 0 ))
		then
			echo >&2 "   Loopback $LOOP ready"
		else
			echo >&2 "   Loopback setup FAILED"
			return 1
		fi
		echo >&2 "   Checking file system using: $E2FSCK -p -f $LOOP ..."
		RESULT="$($E2FSCK -p -f $LOOP 2>&1)" 
   	if (( $? == 0 ))
   	then # Looks OK
			echo >&2 "   Filesystem OK: $RESULT"
			echo >&2 "$(date): Image ready for shrinking.  It took $COUNTER pass(es)."
			echo >&2
      	break
   	else # Filesystem needs some repairs - probably due to orphaned inodes
			echo >&2 "   Filesystem NOT OK: e2fsck failed, probably because there are orphaned inodes."
			# Remove loopback because fixOrphans sets up it's own
   		$LOSETUP -d $LOOP >&2
   		(( $? == 0 )) && echo >&2 "   Loopback removed OK" || { echo >&2 "   Loopback removal FAILED"; return 1; }
			# Try up to 2 times to fix orphaned inodes.
      	fixOrphans || fixOrphans || { echo >&2 "Unable to fix inodes. Exiting."; return 1; }
			echo >&2 "$(date): End of image preparation pass $COUNTER.  Another pass is needed."
			echo >&2
   	fi
	done
	if (( $COUNTER > $TRIES ))
	then
		echo >&2 "ERROR: Unable to prepare image $STOREDIMAGE after $COUNTER attempts."
		return 1
	fi

	# Shrink
	echo >&2 "$(date): Shrinking image..."
	echo >&2 "   resize2fs: Resize filesystem using estimated minimum..."
	COUNTER=0
	TRIES=10
	while (( $COUNTER <= $TRIES ))
	do # Try up to $TRIES times to resize image
   	let COUNTER=COUNTER+1
		echo >&2 -n "   Resize pass # $COUNTER: "
		RESULT="$($RESIZE2FS -M $LOOP 2>&1)"
		if (( $? == 0 ))
		then # Resize complete
			echo >&2 "OK"
			echo "$RESULT" | grep -q "is already" && break
		else
			echo >&2 "FAILED: $RESULT"
			return 1
		fi
	done
	if (( $COUNTER == 1 ))
	then # No shrinking needed, but check if image was ever expanded
		IMAGE_SIZE="$($PARTED -m "$STOREDIMAGE" unit B print | grep :file: | cut -d: -f2 | tr -d 'B')"
		TRUNC="$($PARTED -m "$STOREDIMAGE" unit B print | tail -n1 | cut -d: -f3 | tr -d 'B')"
		if (( $(($TRUNC + 1)) == $IMAGE_SIZE ))
		then
			echo >&2 "   Image is already shrunk.  Nothing to do."
			return 0
		else
			echo >&2 "   Shrinking not required, but image needs to be truncated."
			(( $? == 0 )) && echo >&2 "   Endpoint = $TRUNC bytes" || { echo >&2 "   parted FAILED"; return 1; }
			echo >&2 "   truncate: Truncating $STOREDIMAGE to $(($TRUNC + 1)) Bytes..."
			$TRUNCATE -s $(($TRUNC + 1)) $STOREDIMAGE >&2
			(( $? == 0 )) && echo >&2 "   Truncated OK" || { echo >&2 "   truncate FAILED"; return 1; }
			echo >&2 "   Truncation completed."
			return 0
		fi
	fi
	if (( $COUNTER > $TRIES ))
	then
		echo >&2 "   FAILED after $COUNTER tries: $RESULT"
		return 1
	fi
	echo >&2 -n "   Resize finished on pass # $COUNTER. New length is "
	NEWLEN="$(echo "$RESULT"  | grep -i "blocks long" | sed 's/^.*already //;s/ (4k).*$//' | sed 's/ .*$//')"
	echo >&2 "$NEWLEN $BLOCK_SIZE-byte blocks"
	echo >&2 -n "   losetup: Remove loopback $LOOP..."
	$LOSETUP -d $LOOP >&2
	(( $? == 0 )) && echo >&2 "OK" || { echo >&2 "FAILED"; return 1; }

	# Truncate
	echo >&2 -n "   parted: Remove second partition..."
	$PARTED $STOREDIMAGE rm 2 >&2
	(( $? == 0 )) && echo >&2 "OK" || { echo >&2 "FAILED"; return 1; }
	echo >&2 -n "   parted: Make new smaller second partition from $START to $(($NEWLEN * $BLOCK_SIZE + $START))..."
	$PARTED -s $STOREDIMAGE unit B mkpart primary $START $(($NEWLEN * $BLOCK_SIZE + $START)) >&2
	(( $? == 0 )) && echo >&2 "OK" || { echo >&2 "parted FAILED"; return 1; }
	echo >&2 -n "   parted: Determine new second partition endpoint..."
	TRUNC="$($PARTED -m $STOREDIMAGE unit B print  | tail -n1 | cut -d: -f3 | tr -d 'B')"
	(( $? == 0 )) && echo >&2 "Endpoint = $TRUNC bytes" || { echo >&2 "parted FAILED"; return 1; }
	echo >&2 -n "   truncate: Truncating $STOREDIMAGE to $(($TRUNC + 1)) Bytes..."
	$TRUNCATE -s $(($TRUNC + 1)) $STOREDIMAGE >&2
	(( $? == 0 )) && echo >&2 "OK" || { echo >&2 "truncate FAILED"; return 1; }
	echo >&2 "$(date): Image shrink complete."
	echo >&2
	return 0
}

#============================
#  FILES AND VARIABLES
#============================

# Set Temp Directory
# -----------------------------------
# Create temp directory with three random numbers and the process ID
# in the name.  This directory is removed automatically at exit.
# -----------------------------------
  #== general variables ==#
SCRIPT_NAME="$(basename ${0})" # scriptname without path
SCRIPT_DIR="$( cd $(dirname "$0") && pwd )" # script directory
SCRIPT_FULLPATH="${SCRIPT_DIR}/${SCRIPT_NAME}"
SCRIPT_ID="$(ScriptInfo | grep script_id | tr -s ' ' | cut -d' ' -f3)"
SCRIPT_HEADSIZE=$(grep -sn "^# END_OF_HEADER" ${0} | head -1 | cut -f1 -d:)
VERSION="$(ScriptInfo version | grep version | tr -s ' ' | cut -d' ' -f 4)" 
TMPDIR="/tmp/${SCRIPT_NAME}.$RANDOM.$RANDOM.$RANDOM.$$"

(umask 077 && mkdir "${TMPDIR}") || {
  Die "Could not create temporary directory! Exiting."
}


#============================
#  PARSE OPTIONS WITH GETOPTS
#============================
  
#== set short options ==#
SCRIPT_OPTS=':n:k:m:p:hv-:'

#== set long options associated with short one ==#
typeset -A ARRAY_OPTS
ARRAY_OPTS=(
	[help]=h
	[version]=v
	[name]=n
	[key]=k
	[mail]=m
	[port]=p
)

LONG_OPTS="^($(echo "${!ARRAY_OPTS[@]}" | tr ' ' '|'))="

# Parse options
while getopts ${SCRIPT_OPTS} OPTION
do
	# Translate long options to short
	if [[ "x$OPTION" == "x-" ]]
	then
		LONG_OPTION=$OPTARG
		LONG_OPTARG=$(echo $LONG_OPTION | egrep "$LONG_OPTS" | cut -d'=' -f2-)
		LONG_OPTIND=-1
		[[ "x$LONG_OPTARG" = "x" ]] && LONG_OPTIND=$OPTIND || LONG_OPTION=$(echo $OPTARG | cut -d'=' -f1)
		[[ $LONG_OPTIND -ne -1 ]] && eval LONG_OPTARG="\$$LONG_OPTIND"
		OPTION=${ARRAY_OPTS[$LONG_OPTION]}
		[[ "x$OPTION" = "x" ]] &&  OPTION="?" OPTARG="-$LONG_OPTION"
		
		if [[ $( echo "${SCRIPT_OPTS}" | grep -c "${OPTION}:" ) -eq 1 ]]; then
			if [[ "x${LONG_OPTARG}" = "x" ]] || [[ "${LONG_OPTARG}" = -* ]]; then 
				OPTION=":" OPTARG="-$LONG_OPTION"
			else
				OPTARG="$LONG_OPTARG";
				if [[ $LONG_OPTIND -ne -1 ]]; then
					[[ $OPTIND -le $Optnum ]] && OPTIND=$(( $OPTIND+1 ))
					shift $OPTIND
					OPTIND=1
				fi
			fi
		fi
	fi

	# Options followed by another option instead of argument
	if [[ "x${OPTION}" != "x:" ]] && [[ "x${OPTION}" != "x?" ]] && [[ "${OPTARG}" = -* ]]
	then 
		OPTARG="$OPTION" OPTION=":"
	fi

	# Finally, manage options
	case "$OPTION" in
		h) 
			ScriptInfo full
			exit 0
			;;
		v) 
			ScriptInfo version
			exit 0
			;;
		n)
			NAME="$OPTARG"
			;;
		k)
			KEY="$OPTARG"
			;;
		m)
			RECIPIENTS="$OPTARG"
			;;
		p)
			PORT="$OPTARG"
			;;
		:) 
			Die "${SCRIPT_NAME}: -$OPTARG: option requires an argument"
			;;
		?) 
			Die "${SCRIPT_NAME}: -$OPTARG: unknown option"
			;;
	esac
done
shift $((${OPTIND} - 1)) ## shift options

#Check that what we need is installed
for COMMAND in ssh zip gzip parted losetup fsck e2fsck resize2fs truncate
do
	command -v $COMMAND 2>&1 >/dev/null
	if (( $? != 0 ))
	then
  		echo >&2 "ERROR: $COMMAND is not found."
  		exit -4
	fi
done

(( $# != 1 )) && Die "USER@HOST required."

TARGET="$1"

[[ $TARGET =~ @ ]] || Die "USER@HOST required."

USER="$(echo $TARGET | cut -d '@' -f1)"
HOST="$(echo $TARGET | cut -d '@' -f2)"

NAME=${NAME:-$HOST}
KEY=${KEY:-$HOME/.ssh/id_rsa}
PORT=${PORT:-22}
STOREDIMAGE="$HOME/$NAME.img"
GZIPIMAGE="$HOME/$NAME-$(date "+%Y%m%dT%H%M").gz"
RECIPIENTS=${RECIPIENTS:-}
# Set the SENDER variable to your email address if you want results mailed using a
# mail program on this host.  This variable is not used if you're using pat.
SENDER="me@example.com"
LOG="$TMPDIR/$NAME.log"

LOSETUP="sudo $(command -v losetup)"
PARTED="sudo $(command -v parted)"
TRUNCATE="sudo $(command -v truncate)"
FSCK="sudo $(command -v fsck)"
E2FSCK="sudo $(command -v e2fsck)"
RESIZE2FS="sudo $(command -v resize2fs)"
ZIP="$(command -v zip)"
GZIP="$(command -v gzip) -qdc"
SSHOPTIONS="-i $KEY -o CheckHostIP=no -o StrictHostKeyChecking=no -o ConnectTimeout=3 -o ConnectionAttempts=3"
SSH="$(command -v ssh) $SSHOPTIONS -p $PORT $TARGET"
# Use keychain file if it exists
KEYCHAINFILE="$HOME/.keychain/$HOSTNAME-sh"
[ -s $KEYCHAINFILE ] && source $KEYCHAINFILE
LOOP=""

#============================
#  MAIN SCRIPT
#============================

# Trap bad exits with cleanup function
trap SafeExit EXIT INT TERM
#trap TrapCleanup ERR

# Exit on error. Append '||true' when you run the script if you expect an error.
#set -o errexit

# Check Syntax if set
$SYNTAX && set -n
# Run in debug mode, if set
$DEBUG && set -x 

# SSH to source (host to back up), and start dd piped into gzip so we don't send so much traffic.
# When the data stream is received on this host, use dd to capture it into a .gz file
echo >&2 "$(date): Downloading compressed-on-the-fly dd image from $NAME via ssh into local file $GZIPIMAGE..." >> $LOG
$SSH "sudo dd if=/dev/mmcblk0 bs=1M 2>/dev/null | gzip - 2>/dev/null" 2>>$LOG | dd of=$GZIPIMAGE status=none 2>&1 >> $LOG
(( $? == 0 )) && echo >&2 "$(date): Download complete." >> $LOG || { echo >&2 "$(date): FAILED." >> $LOG; exit 1; }

# Check to see if we have an intact .gz file
if [ -s $GZIPIMAGE ]
then # Decompress the .gz file
	echo >&2 "$(date): Decompressing $GZIPIMAGE..." >> $LOG
	$GZIP $GZIPIMAGE > $STOREDIMAGE
	(( $? == 0 )) && echo >&2 -e "$(date): Decompressed OK.\n" >> $LOG || { echo >&2 "$(date): FAILED." >> $LOG; exit 1; }
else # Something went wrong during the ssh copy
	echo >&2 "$(date): Compressed file $GZIPIMAGE does not exist or is empty" >> $LOG
	exit 1
fi

# Decompress finished.  Make sure we have an image .img file.
[[ -z $STOREDIMAGE || ! -f $STOREDIMAGE ]] && { echo >&2 "$(date): Unable to decompress $GZIPIMAGE to $STOREDIMAGE" >> $LOG; exit 1; }
rm -f $GZIPIMAGE

# Shrink the image
Shrink >> $LOG 2>&1
if (( $? == 0 ))
then # Shrink was successful
	# ZIP the shrunken image.  ZIP file can be burned directly to new SD card using Balena Etcher.
	echo >&2 -n "$(date): Zipping image to $NAME.zip..." >> $LOG
	[ -s $NAME.zip ] && rm $NAME.zip
	$ZIP $NAME.zip $STOREDIMAGE >&2 >> $LOG
	(( $? == 0 )) && echo >&2 "OK" >> $LOG || { echo >&2 "FAILED" >> $LOG; exit 1; }
	echo >&2 "$(date): $NAME image backup complete. Image is in $NAME.zip." >> $LOG
	rm -f $STOREDIMAGE
   exit 0
else # Shrink failed.  Keep the unshrunk image and exit.
	echo >&2 "$(date): Shrinking $STOREDIMAGE failed." >> $LOG
	exit 1
fi