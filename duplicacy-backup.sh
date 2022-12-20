#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -e -o pipefail

DUPLICACY=duplicacy

backupRepository()
{
    cd "$1" || exit
    chmod -R g=,o= .duplicacy

    DUPLICACY_LOGS=.duplicacy/logs
    [[ -d $DUPLICACY_LOGS ]] || mkdir -p $DUPLICACY_LOGS

    DATETIME=$(date "+%Y%m%d-%H%M%S")
    # DOW=$(date +%-a)
    # HR=$(date "+%H")

    echo ""
    echo "### backupRepository $1 ###"

    echo "# Delete old logs..."
    find ./$DUPLICACY_LOGS -name "*.log" -type f -mtime +14 -delete
    echo "# Done"

    echo "# Start Backup..."
    $DUPLICACY -log backup -stats -threads 2 | tee "$DUPLICACY_LOGS/$DATETIME-backup.log"
    echo "# Done"

    # if [[ "$DOW" = 'Sun' && "$HR" = "00" ]]; then
    if [[ $2 = "check" ]]; then
        echo "# Start Check..."
        $DUPLICACY -log check -all | tee "$DUPLICACY_LOGS/$DATETIME-check.log"
        echo "# Done"
    fi
}

if [ "$(whoami)" = "root" ] && [ "$(hostname -s)" = "ariel" ]; then
    backupRepository /etc "$1"
elif [ "$(whoami)" = "tom" ] && [ "$(hostname -s)" = "ariel" ]; then
    backupRepository /Users/tom "$1"
elif [ "$(whoami)" = "tom" ] && [ "$(hostname -s)" = "bethel" ]; then
    backupRepository /Users/tom "$1"
elif [ "$(whoami)" = "root" ] && [ "$(hostname -s)" = "theophilus" ]; then
    :
    # backupRepository /etc
    # backupRepository /root
    # backupRepository /usr/local "$1"
elif [ "$(whoami)" = "tom" ] && [ "$(hostname -s)" = "theophilus" ]; then
    backupRepository /home/tom "$1"
elif [ "$(whoami)" = "tom" ] && [ "$(hostname -s)" = "synology" ]; then
    # DUPLICACY="/Users/tom/bin/duplicacy"
    backupRepository /home/tom "$1"
fi

if [ "$(hostname -s)" = "pvhost2" ]; then
    backupRepository /etc
    backupRepository /root
    backupRepository /usr/local
    backupRepository /home/tom "$1"
    chown -R 101002:101002 /mnt/bindmounts/duplicacy_backups
    cd /root || exit

    echo ""
    echo "### Copy to Backblaze... ###"
    DATETIME=$(date "+%Y%m%d-%H%M%S")
    $DUPLICACY -log copy -from default -to b2 -threads 20 | tee "$DUPLICACY_LOGS/$DATETIME-copy-b2.log"
    echo "# Done"

    echo ""
    echo "### Copy to OneDrive... ###"
    DATETIME=$(date "+%Y%m%d-%H%M%S")
    $DUPLICACY -log copy -from default -to onedrive -threads 20 | tee "$DUPLICACY_LOGS/$DATETIME-copy-onedrive.log"
    echo "# Done"

    echo ""
    echo "### Prune Backups... ###"
    # $DUPLICACY -log prune                   -all -keep 0:360 -keep 30:180 -keep 7:30 -keep 1:7 | tee "$DUPLICACY_LOGS/$DATETIME-prune.log"
    DATETIME=$(date "+%Y%m%d-%H%M%S")
    $DUPLICACY -log prune                   -all -keep 30:180 -keep 7:30 -keep 1:7 | tee "$DUPLICACY_LOGS/$DATETIME-prune.log"
    DATETIME=$(date "+%Y%m%d-%H%M%S")
    $DUPLICACY -log prune -storage b2       -all -keep 30:180 -keep 7:30 -keep 1:7 | tee "$DUPLICACY_LOGS/$DATETIME-prune-b2.log"
    DATETIME=$(date "+%Y%m%d-%H%M%S")
    $DUPLICACY -log prune -storage onedrive -all -keep 30:180 -keep 7:30 -keep 1:7 | tee "$DUPLICACY_LOGS/$DATETIME-prune-onedrive.log"
    echo "# Done"

    echo ""
    echo "### Check Backups... ###"
    DATETIME=$(date "+%Y%m%d-%H%M%S")
    $DUPLICACY -log check                   -all | tee "$DUPLICACY_LOGS/$DATETIME-check.log"
    DATETIME=$(date "+%Y%m%d-%H%M%S")
    $DUPLICACY -log check -storage b2       -all | tee "$DUPLICACY_LOGS/$DATETIME-check-b2.log"
    DATETIME=$(date "+%Y%m%d-%H%M%S")
    $DUPLICACY -log check -storage onedrive -all | tee "$DUPLICACY_LOGS/$DATETIME-check-onedrive.log"
    echo "# Done"
fi
