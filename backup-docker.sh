#!/usr/bin/env sh
# shellcheck disable=SC2029

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
set -eu

MYHOST=$(uname -n | sed 's/\..*//')     # alternative to $(hostname -s), as arch does not install 'hostname' by default
BACKUPDIR=/Volumes/external/backups/docker/${MYHOST}
BACKUPHOST=bethel

cd "${HOME}/data/docker" || exit

# TODO: find -s . -maxdepth 1 -type d | while read -r dir; do
#  the preceding line wasn't reading thru all dirs, so I substituted the
#  following line for now:
# shellcheck disable=SC2044
for dir in $(find -s . -maxdepth 1 -type d); do
    if [ "${dir}" = "." ]; then continue; fi
    DATADIR=$(echo "${dir}" | sed -e 's/^\.\///')
    FILENAME=$(date +%Y%m%d-%H%M%S)--${DATADIR}.tgz
    ssh ${BACKUPHOST} "[ -d ${BACKUPDIR}/${DATADIR} ]" || ssh ${BACKUPHOST} "mkdir -pm 0700 ${BACKUPDIR}/${DATADIR}"
    if [ "${MYHOST}" = "bethel" ]; then
        tar -czf "${BACKUPDIR}/${DATADIR}/${FILENAME}" "${DATADIR}"
    else
        tar -czf - "${DATADIR}" | ssh ${BACKUPHOST} "cat > ${BACKUPDIR}/${DATADIR}/${FILENAME}"
    fi
done
