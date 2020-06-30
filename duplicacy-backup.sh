#!/usr/bin/env bash
# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

DUPLICACY=duplicacy

backupRepository()
{
    cd "$1" || exit
    chmod -R g=,o= .duplicacy

    DUPLICACY_LOGS=.duplicacy/logs
    [[ -d $DUPLICACY_LOGS ]] || mkdir -p $DUPLICACY_LOGS

    DATETIME=$(date "+%Y%m%d-%H%M%S")

    echo "# Delete old logs..."
    find ./$DUPLICACY_LOGS -name "*.log" -type f -mtime +14 -delete
    echo "# Done"

    echo "# Start Backup..."
    $DUPLICACY -log backup -stats -threads 2 | tee "$DUPLICACY_LOGS/$DATETIME-backup.log"
    echo "# Done"
}

if [ "$(hostname -s)" = "ariel" ]; then
    # DUPLICACY="/Users/tom/bin/duplicacy"
    backupRepository /etc
    backupRepository /Users/tom
    backupRepository /Volumes/RAID10/Music
    backupRepository /Volumes/RAID10/Photos
elif [ "$(hostname -s)" = "theophilus" ]; then
    # backupRepository /etc
    # backupRepository /root
    backupRepository /home/tom
    # backupRepository /usr/local
fi

if [ "$(hostname -s)" = "pvhost2" ]; then
    backupRepository /etc
    backupRepository /root
    backupRepository /usr/local
    backupRepository /home/tom
    chown -R 101000:101000 /mnt/bindmounts/duplicacy_backups
    cd /root || exit

    echo "# Copy to Backblaze..."
    $DUPLICACY -log copy -from default -to b2 -threads 20 | tee "$DUPLICACY_LOGS/$DATETIME-copy-b2.log"
    echo "# Done"

    echo "# Copy to OneDrive..."
    $DUPLICACY -log copy -from default -to onedrive -threads 20 | tee "$DUPLICACY_LOGS/$DATETIME-copy-onedrive.log"
    echo "# Done"

    echo "# Prune Backups..."
    # $DUPLICACY -log prune                   -all -keep 0:360 -keep 30:180 -keep 7:30 -keep 1:7 | tee "$DUPLICACY_LOGS/$DATETIME-prune.log"
    $DUPLICACY -log prune                   -all -keep 30:180 -keep 7:30 -keep 1:7 | tee "$DUPLICACY_LOGS/$DATETIME-prune.log"
    $DUPLICACY -log prune -storage b2       -all -keep 30:180 -keep 7:30 -keep 1:7 | tee "$DUPLICACY_LOGS/$DATETIME-prune-b2.log"
    $DUPLICACY -log prune -storage onedrive -all -keep 30:180 -keep 7:30 -keep 1:7 | tee "$DUPLICACY_LOGS/$DATETIME-prune-onedrive.log"
    echo "# Done"
fi
