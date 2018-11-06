#!/bin/sh

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
set -eu

KEY=gnupg
KEY_MOUNTPOINT=/Volumes/${KEY}
KEY_BACKUPDIR=/Volumes/backups/${KEY}
FILENAME=$(date +%Y%m%d-%H%M%S).tgz.gpg

cd $KEY_MOUNTPOINT || exit

if ! [ -d ${KEY_BACKUPDIR} ] ; then mkdir -p 0700 ${KEY_BACKUPDIR} ; fi

tar -czvf - .gnupg | gpg --cipher-algo aes256 -co "$KEY_BACKUPDIR/$FILENAME"

# decrypt with:
#gpg -o - xxx.tgz.gpg | tar xzvf -
