#!/bin/sh

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
set -eu

MOUNTPOINT=/mnt/user/appdata/home-assistant
BACKUPDIR=/mnt/user/backups/hass_config
FILENAME=$(date +%Y%m%d-%H%M%S).tgz

cd $MOUNTPOINT || exit

if ! [ -d ${BACKUPDIR} ] ; then mkdir -p 0700 ${BACKUPDIR} ; fi

tar --exclude home-assistant_v2.db --exclude .git -czvf "$BACKUPDIR/$FILENAME" .
