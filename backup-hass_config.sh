#!/bin/sh

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
set -eu

MOUNTPOINT=/home/tom/appdata/hass
BACKUPDIR=/mnt/backups/hass
VERSION=`cat /home/tom/appdata/hass/.HA_VERSION`
FILENAME=$(date +%Y%m%d-%H%M%S)-$VERSION.tgz

cd $MOUNTPOINT || exit

if ! [ -d ${BACKUPDIR} ] ; then mkdir -p 0700 ${BACKUPDIR} ; fi

tar --exclude home-assistant_v2.db --exclude .git -czvf "$BACKUPDIR/$FILENAME" .
