#!/usr/bin/env sh

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
set -eu

BACKUPDIR=/Volumes/external/backups/docker
FILENAME=$(date +%Y%m%d-%H%M%S).tgz

cd "${HOME}/data/docker" || exit

# shellcheck disable=SC2174
if ! [ -d ${BACKUPDIR} ] ; then mkdir -pm 0700 ${BACKUPDIR} ; fi

tar -czvf "${BACKUPDIR}/gitolite-${FILENAME}" gitolite-git gitolite-sshkeys
