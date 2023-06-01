#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -o pipefail

DUPLICACY=duplicacy

##### TODO #####
# duplicacy init -e -storage-name synology ariel-etc--synology            sftp://tom@SYNOLOGY//zz_duplicacy-backups
# duplicacy init -e -storage-name synology bethel-etc--synology           sftp://tom@SYNOLOGY//zz_duplicacy-backups

backupRepository()
{
    if [[ -d "${1}" ]]; then
        cd "${1}" || exit 1
    else
        echo ""
        echo "### ${1} not mounted"
        return
    fi
    chmod -R g=,o= .duplicacy

    DUPLICACY_LOGS=.duplicacy/logs
    mkdir -p $DUPLICACY_LOGS

    echo ""
    echo "### backupRepository ${1} ###"

    echo "# Backup filters, known_hosts & preferences..."
    BACKUP_DIR="${HOME}/.duplicacy-backup${1}"
    mkdir -p "${BACKUP_DIR}"
    cp -a .duplicacy/{filters,known_hosts,preferences} "${BACKUP_DIR}"
    chmod -R g=,o= "${HOME}/.duplicacy-backup"
    echo "# Done"

    echo "# Delete old logs..."
    find ./$DUPLICACY_LOGS -name "*.log" -type f -mtime +14 -delete
    echo "# Done"

    echo "# Start Backup..."
    DATETIME=$(date "+%Y%m%d-%H%M%S")
    if [[ "${2}" == "hash" ]]; then
        $DUPLICACY -log backup -stats -threads 4 -hash | tee "$DUPLICACY_LOGS/$DATETIME-backup.log"
    else
        $DUPLICACY -log backup -stats -threads 4       | tee "$DUPLICACY_LOGS/$DATETIME-backup.log"
    fi
    echo "# Done"

    if [[ "${2}" == "check" ]]; then
        echo ""
        echo "### Check Backups... ###"
        DATETIME=$(date "+%Y%m%d-%H%M%S")
        # $DUPLICACY -log check -all | tee "$DUPLICACY_LOGS/$DATETIME-check.log"
        $DUPLICACY -log check -all -storage synology -tabular -threads 40 -persist | tee "$DUPLICACY_LOGS/$DATETIME-check.log"
        echo "# Done"
    fi
}

if   [ "$(id -u)" -eq 0 ] && [[ "$(hostname -s)" =~ (ariel|bethel) ]]; then
    ##### cd /etc             && duplicacy init -e -storage-name synology $(hostname -s)-etc--synology       sftp://tom@SYNOLOGY//zz_duplicacy-backups
    backupRepository /etc "${1}"
elif [ "$(id -u)" -eq 0 ] && [[ "$(hostname -s)" == "pvhost[0-9]*" ]]; then
    ##### cd /etc             && duplicacy init -e -storage-name synology $(hostname -s)-etc--synology       sftp://tom@SYNOLOGY//zz_duplicacy-backups
    ##### cd /root            && duplicacy init -e -storage-name synology $(hostname -s)-root--synology      sftp://tom@SYNOLOGY//zz_duplicacy-backups
    ##### cd /usr/local       && duplicacy init -e -storage-name synology $(hostname -s)-usr_local--synology sftp://tom@SYNOLOGY//zz_duplicacy-backups
    ##### cd /home/tom        && duplicacy init -e -storage-name synology $(hostname -s)-tom--synology       sftp://tom@SYNOLOGY//zz_duplicacy-backups
    DUPLICACY="/usr/local/sbin/duplicacy"
    backupRepository /etc
    backupRepository /root
    backupRepository /usr/local
    backupRepository /home/tom "${1}"
elif [ "$(id -u)" -eq 0 ] && [[ "$(hostname -s)" == "theophilus" ]]; then
    ##### cd /etc             && duplicacy init -e -storage-name synology $(hostname -s)-etc--synology       sftp://tom@SYNOLOGY//zz_duplicacy-backups
    ##### cd /root            && duplicacy init -e -storage-name synology $(hostname -s)-root--synology      sftp://tom@SYNOLOGY//zz_duplicacy-backups
    ##### cd /usr/local       && duplicacy init -e -storage-name synology $(hostname -s)-usr_local--synology sftp://tom@SYNOLOGY//zz_duplicacy-backups
    backupRepository /etc
    backupRepository /root
    backupRepository /usr/local "${1}"
elif [[ "$(whoami)" == "tom" ]] && [[ "$(hostname -s)" =~ (ariel|bethel) ]]; then
    ##### cd                       && duplicacy init -e -storage-name synology                       $(hostname -s)-tom--synology sftp://tom@SYNOLOGY//zz_duplicacy-backups
    ##### cd /Users/tom/Dropbox/tc && duplicacy init -e -storage-name synology -c 1M -max 1M -min 1M tc--synology                 sftp://tom@SYNOLOGY//zz_duplicacy-backups
    ##### cd /Volumes/USBAC        && duplicacy init -e -storage-name synology -c 1M -max 1M -min 1M USBAC--synology              sftp://tom@SYNOLOGY//zz_duplicacy-backups
    backupRepository /Users/tom/Dropbox/tc hash
    backupRepository /Volumes/USBAC hash
    backupRepository /Users/tom "${1}"
elif [[ "$(whoami)" == "tom" ]] && [[ "$(hostname -s)" == "theophilus" ]]; then
    ##### cd /home/tom        && duplicacy init -e -storage-name synology $(hostname -s)-tom--synology       sftp://tom@SYNOLOGY//zz_duplicacy-backups
    backupRepository /home/tom "${1}"
fi

if [[ "$(hostname -s)" == "synology" ]]; then
    ##### cd /volume1/archive && ~/bin/duplicacy init -e                 -storage-name synology synology-archive--synology /volume1/zz_duplicacy-backups
    ##### cd /volume1/archive && ~/bin/duplicacy add  -e -bit-identical -copy synology bethel   synology-archive--bethel   sftp://tom@bethel//Volumes/exFAT/duplicacy
    ##### cd /volume1/archive && ~/bin/duplicacy add  -e -bit-identical -copy synology b2       synology-archive--b2       b2://duplicacy-tch-backup
    DUPLICACY="/var/services/homes/tom/bin/duplicacy"
    backupRepository /volume1/archive
    backupRepository /volume1/audio
    backupRepository /volume1/homes
    backupRepository /volume1/music
    backupRepository /volume1/photo
    # backupRepository /volume1/reference
    backupRepository /volume1/video
    backupRepository /volume1/zz_backups

    echo ""
    echo "### Copy to bethel... ###"
    DATETIME=$(date "+%Y%m%d-%H%M%S")
    $DUPLICACY -log copy -from synology -to bethel -threads 40 | grep -v "INFO SNAPSHOT_EXIST Snapshot .* already exists at the destination storage" | tee "$DUPLICACY_LOGS/$DATETIME-copy-bethel.log"
    echo "# Done"

    echo ""
    echo "### Copy to Backblaze... ###"
    DATETIME=$(date "+%Y%m%d-%H%M%S")
    $DUPLICACY -log copy -from synology -to b2       -threads 4  | grep -v "INFO SNAPSHOT_EXIST Snapshot .* already exists at the destination storage" | tee "$DUPLICACY_LOGS/$DATETIME-copy-b2.log"
    echo "# Done"

    # echo ""
    # echo "### Prune Backups... ###"
    # # $DUPLICACY -log prune                   -all -keep 0:360 -keep 30:180 -keep 7:30 -keep 1:7 | tee "$DUPLICACY_LOGS/$DATETIME-prune.log"
    # DATETIME=$(date "+%Y%m%d-%H%M%S")
    # $DUPLICACY -log prune                   -all -keep 30:180 -keep 7:30 -keep 1:7 | tee "$DUPLICACY_LOGS/$DATETIME-prune.log"
    # DATETIME=$(date "+%Y%m%d-%H%M%S")
    # $DUPLICACY -log prune -storage b2       -all -keep 30:180 -keep 7:30 -keep 1:7 | tee "$DUPLICACY_LOGS/$DATETIME-prune-b2.log"
    # DATETIME=$(date "+%Y%m%d-%H%M%S")
    # $DUPLICACY -log prune -storage onedrive -all -keep 30:180 -keep 7:30 -keep 1:7 | tee "$DUPLICACY_LOGS/$DATETIME-prune-onedrive.log"
    # echo "# Done"

    if [[ "${1}" == "check" ]]; then
        cd /volume1/archive || exit
        echo ""
        echo "### Check Backups... ###"
        DATETIME=$(date "+%Y%m%d-%H%M%S")
        $DUPLICACY -log check -all -storage synology -tabular -chunks -threads 40 -persist | tee "$DUPLICACY_LOGS/$DATETIME-check.log"
        DATETIME=$(date "+%Y%m%d-%H%M%S")
        $DUPLICACY -log check -all -storage bethel                                         | tee "$DUPLICACY_LOGS/$DATETIME-check-bethel.log"
        DATETIME=$(date "+%Y%m%d-%H%M%S")
        $DUPLICACY -log check -all -storage b2                                             | tee "$DUPLICACY_LOGS/$DATETIME-check-b2.log"
        echo "# Done"
    fi
fi

# cd /volume1/archive && ~/bin/duplicacy -d -log backup -enum-only -stats | tee .duplicacy/check-filters.log
# cd /volume1/archive && grep PATTERN_EXCLUDE .duplicacy/check-filters.log | less
# cd /volume1/archive && grep PATTERN_INCLUDE .duplicacy/check-filters.log | less
