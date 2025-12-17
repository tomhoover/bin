#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -o pipefail

# duplicacy -d -log backup -enum-only -stats | tee .duplicacy/check-filters.log
# exit

if [ $# -eq 0  ]; then
    echo "Please provide storage location as an argument"
    exit 1
fi

MYHOST=$(uname -n | sed 's/\..*//')     # alternative to $(hostname -s), as arch does not install 'hostname' by default

DUPLICACY=duplicacy
if [ "$(id -u)" -eq 0 ] && [[ "${MYHOST}" =~ ^pvhost[0-9]$ ]]; then
    DUPLICACY="/usr/local/sbin/duplicacy"
elif [[ "${MYHOST}" == "synology" ]]; then
    DUPLICACY="/var/services/homes/tom/bin/duplicacy"
fi

"${DUPLICACY}" -d -log backup -storage "${1}" -enum-only -stats | tee .duplicacy/check-filters.log
grep PATTERN_EXCLUDE .duplicacy/check-filters.log | tee .duplicacy/check-filters-excluded.log | less
grep PATTERN_INCLUDE .duplicacy/check-filters.log | tee .duplicacy/check-filters-included.log | less
