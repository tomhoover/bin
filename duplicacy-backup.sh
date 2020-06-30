#!/bin/bash

exit

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

[[ -f ${HOME}/.SECRETS ]] && . ${HOME}/.SECRETS

# wasabi://us-west-1@s3.us-west-1.wasabisys.com/bucket/path

backupRepositoryVerbose()
{
    echo ""
    echo ""
    echo "********** Verbose backup of $1 **********"
    echo ""
    cd "$1" && pwd
    cat .duplicacy/filters
    $DUPLICACY -v -d backup
    $DUPLICACY list
}

backupRepository()
{
    echo ""
    echo ""
    echo "********** Backup of $1 **********"
    echo ""
    cd "$1" && pwd
    $DUPLICACY backup
    #$DUPLICACY prune -keep 30:180 -keep 7:30 -keep 1:7
    # wasabi charges for 90 days minimum, so no financial reason for early pruning of snapshots
    $DUPLICACY prune -keep 7:90 -keep 30:180 -keep 0:360
    #$DUPLICACY list
}

copyDefault2b2()
{
    echo ""
    echo ""
    echo "********** Copy $1 to B2 **********"
    echo ""
    cd "$1" && pwd
    $DUPLICACY copy -from default -to b2
    #$DUPLICACY prune -keep 30:180 -keep 7:30 -keep 1:7
}

if [ "$(hostname -s)" = "ariel" ]; then
    DUPLICACY="/Users/tom/bin/duplicacy"
    backupRepository /Users/tom
    #backupRepository /Volumes/RAID10/Music
    #backupRepository /Volumes/RAID10/Photos
elif [ "$(hostname -s)" = "gabriel" ]; then
    DUPLICACY="/root/bin/duplicacy"
    # gabriel_tom
    time backupRepositoryVerbose /home/tom
    # gabriel_root
    time backupRepositoryVerbose /root
    # gabriel_etc
    time backupRepositoryVerbose /etc
    #time backupRepository /mnt/user/Media
    #time backupRepository /mnt/user/Music
    #time backupRepository /mnt/user/Photos
    #time backupRepository /mnt/user/Vault
    #time backupRepository /mnt/user/Warehouse
    #time copyDefault2b2 /mnt/user/Photos
fi
