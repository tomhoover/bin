#!/bin/bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

[[ "`uname`" = "Darwin" ]] || exit

# mount.sh

# found on the limetech.com forum at:
#	discussion: http://lime-technology.com/forum/index.php?topic=10274.0
#	zip file:   http://lime-technology.com/forum/index.php?action=dlattach;topic=10274.0;attach=9412
# renamed from mount.sh to mountSMB-nas

###############################################################################
# SET YOUR PREFS HERE - READ BELOW BEFORE RUNNING SCRIPT                      #
# RUN AT YOUR OWN RISK, MAKE BACKUPS OF YOUR DATA ALWAYS                      #
#	   				                                      #
# PASSWORD: If your password contains symbols, they must be url encoded       #
#           ie: "@" becomes "%40". To encode your password, use this site:    #
#           http://www.opinionatedgeek.com/dotnet/tools/urlencode/Encode.aspx #
#                                                                             #
# SHARES:   Separated with spaces, case sensitive                             #
#           If shares have spaces, use %20 instead of space. ie HD%20Movies   #
#                                                                             #
# ITUNES:   FALSE = Don"t Open, TRUE = Open                                   #
#                                                                             #
# PROTOCOL: afp OR smb   - lowercase                                          #
#                                                                             #
# WAKE:     FALSE = Don't wake, TRUE = Wake                                   #
#           If you select True, server will initiate wake on lan at specified #
#           time. Requires wolcmd in script location, MAC address, subnet and #
#           the times it should wake the server.                              #
#                                                                             #
###############################################################################


#-----------------------------#
# Required for share mounting #
#-----------------------------#

# Script Location
SCRIPTLOCATION="/Users/tom/bin"

[[ -f ${HOME}/.SECRETS ]] && . ${HOME}/.SECRETS

# Username for server
USERNAME="username"				# you can set your username here, or
USERNAME=${MOUNT_drobo_USERNAME:-$USERNAME}	#  set the variable MOUNTSMB_USERNAME in ~/.SECRETS

# Password for server, check notes
PASSWORD="password"				# you can set your password here, or
PASSWORD=${MOUNT_drobo_PASSWORD:-$PASSWORD}	#  set the variable MOUNTSMB_PASSWORD in ~/.SECRETS

# IP Address/hostname for ping
PING="192.168.2.91"

# Hostname for server. Try sername.local, hostname or IP
HOSTNAME="drobo"

# Protocol in lowercase, afp or smb
PROTOCOL="smb"

# Shares, check notes
#SHARES="Archive BackupNAS Movies Music TV%20Shows"
SHARES="arq"

MOUNT="$HOME/mnt/$HOSTNAME"

#-----------------------------#
# Required for iTunes opening #
#-----------------------------#

# Do you want iTunes open, TRUE or FALSE
ITUNES="FALSE"

# Do you want iTunes to quit if server unavailable & iTunes open is set FALSE, TRUE or FALSE
ITUNESQUIT="FALSE"


#-----------------------------#
#   Required for Wake On Lan  #
#-----------------------------#

# Do you want to use Wake On Lan, TRUE or FALSE
WAKE="FALSE"

# The starting hour to attempt WOL, only if unavailable via ping. Must be 24 hour time without minutes
HOURSTART="17"

# The hour WOL attempts will stop. Must be 24 hour time without minutes.
HOUREND="20"

# Subnet Mask for network
SUBNET="255.255.255.0"

# MAC Address for server. Required for Wake On Lan
MACADDRESS="002fd0760ef9"


##############################
# Don"t edit past this point #
##############################


# Mountpoint - Don't edit this unless you know what you're doing.
#MOUNT="/Volumes"

# Check if server is available
if ( ping -q -c 5 $PING ); then

	AVAILABLE="TRUE"

	# Loop through shares to mount them
	for s in $SHARES

	do

		# Parse spaces for mkdir	
		SPACESHARE=$(echo $s|sed "s/%20/ /g")

		# Check to see if mount doesn't exist, then mounts either AFP or SMB.
		if [ ! -d "$MOUNT/$SPACESHARE" ]; then

			mkdir "$MOUNT/$SPACESHARE"

			if [ $PROTOCOL == "smb" ]; then

				echo "Mounting $SPACESHARE ..."
				mount_smbfs //$USERNAME:$PASSWORD@$HOSTNAME/$s "$MOUNT/$SPACESHARE"

				if [ ! "$?" -eq "0" ]; then

					if [ "$(ls -A "$MOUNT/$SPACESHARE")" ]; then

  						echo "Mount failed. Check settings/server. Could not delete $MOUNT/$SPACESHARE as it contains files. Please check."
						echo "*************"
						AVAILABLE="FALSE"

					else

						echo "$SPACESHARE mount failed. Check settings/server. Removing mount point."
						echo "*************"
						rmdir "$MOUNT/$SPACESHARE"
						AVAILABLE="FALSE"

					fi
						
				fi

			elif [ $PROTOCOL == "afp" ]; then

				echo "Mounting $SPACESHARE"
				mount_afp afp://$USERNAME:$PASSWORD@$HOSTNAME/$s "$MOUNT/$SPACESHARE"

				if [ ! "$?" -eq "0" ]; then

					if [ "$(ls -A "$MOUNT/$SPACESHARE")" ]; then

  						echo "Mount failed. Check settings/server. Could not remove $MOUNT/$SPACESHARE as it contains files. Please check."
						echo "*************"
						AVAILABLE="FALSE"

					else

						echo "$SPACESHARE mount failed. Check settings/server. Removing mount point."
						echo "*************"
						rmdir "$MOUNT/$SPACESHARE"
						AVAILABLE="FALSE"

					fi
						
				fi

			fi
		else

			# If shares are already mounted, don't do anything
			echo "$SPACESHARE already mounted"

		fi
	
	done	

else

	DATE=`date +%H`
	DATE=`echo $DATE|sed 's/^0*//'`
	AVAILABLE="FALSE"

	# Loop through shares to unmount them, if mounted.
	for s in $SHARES

	do

		# Parse spaces for umount	
		SPACESHARE=$(echo $s|sed "s/%20/ /g")

		# Check to see if mount exists, then unmount
		if [ -d "$MOUNT/$SPACESHARE" ]; then

			echo "Unmounting $SPACESHARE"
			umount "$MOUNT/$SPACESHARE"

		fi

	done

	if [ $WAKE == "TRUE" ]; then
	
		if [[ $DATE -ge $HOURSTART && $DATE -lt $HOUREND ]] || [ $1 == "wake" ]; then

			echo "Waking Server"
			$SCRIPTLOCATION/wolcmd $MACADDRESS $PING $SUBNET 4343

		fi

	fi

fi

# Opens iTunes if TRUE and Server 
if [ $ITUNES == "TRUE" ] && [ $AVAILABLE == "TRUE" ]; then

	if (! ps ax | grep -v grep | grep -v iTunesHelper | grep /Applications/iTunes.app/Contents/MacOS/iTunes > /dev/null ); then

	echo "Attempting to open iTunes"
	open /Applications/iTunes.app/
		
	fi

else

	if [ $ITUNESQUIT == "TRUE" ]; then

	echo "Attempting to close iTunes"
	osascript -e 'tell application "iTunes" to quit'

	fi
		
fi
