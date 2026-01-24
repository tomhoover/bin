#!/usr/bin/env sh

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
set -eu

KEY=IRONKEY64
KEY_MOUNTPOINT=/Volumes/${KEY}
KEY_BACKUPDIR=/Volumes/zz_backups/${KEY}
FILENAME=$(date +%Y%m%d-%H%M%S).tgz.gpg

cd "${KEY_MOUNTPOINT}" || exit

# shellcheck disable=SC2174
if ! [ -d ${KEY_BACKUPDIR} ] ; then mkdir -pm 0700 ${KEY_BACKUPDIR} ; fi

# tar --exclude IronKey-System-Files --exclude SECUR02B.ico --exclude autorun.inf -czvf - ./* | gpg --cipher-algo aes256 -co "$KEY_BACKUPDIR/$FILENAME"
tar --exclude .Spotlight-V100 --exclude .fseventsd -czvf - ./* | gpg --cipher-algo aes256 -co "$KEY_BACKUPDIR/$FILENAME"

# decrypt with:
#gpg -o - xxx.tgz.gpg | tar xzvf -
