#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -o pipefail

# shellcheck source=/dev/null
source ~/bin/COLORS

# shellcheck source=/dev/null
[[ -f ${HOME}/.SECRETS ]] && . "${HOME}"/.SECRETS

# uncomment the following line to delete logs older than 14 days (you may change '14' to whatever number of days you wish to keep)
#DELETE_LOGS=14

MYHOST=$(uname -n | sed 's/\..*//')     # alternative to $(hostname -s), as arch does not install 'hostname' by default

DUPLICACY=duplicacy

##### TODO #####
# duplicacy init -e -storage-name synology ariel-etc--synology "${SYNOLOGY_SFTP}"
# duplicacy init -e -storage-name synology bethel-etc--synology "${SYNOLOGY_SFTP}"
# cd /Volumes/USBAC && duplicacy add -e -bit-identical -copy synology rsyncNet USBAC--rsyncNet "${RSYNCNET_SFTP}"

backupRepository()
{
    if [[ -d "${1}" ]]; then
        cd "${1}" || exit 1
    else
        echo ""
        echo "${RED}### ${1} not mounted${RESET}"
        return
    fi
    chmod -R g=,o= .duplicacy

    DUPLICACY_LOGS=.duplicacy/logs
    mkdir -p "${DUPLICACY_LOGS}"

    echo ""
    echo "${CYAN}### backupRepository ${GREEN}${1}${CYAN} to ${GREEN}${2}${CYAN} ###${RESET}"

    echo "${MAGENTA}# Backup filters, known_hosts & preferences...${RESET}"
    BACKUP_DIR="${HOME}/.duplicacy-backup${1}"
    mkdir -p "${BACKUP_DIR}"
    cp -a .duplicacy/{filters,known_hosts,preferences} "${BACKUP_DIR}"
    chmod -R g=,o= "${HOME}/.duplicacy-backup"
    echo "${MAGENTA}# Done${RESET}"

    if [ "${DELETE_LOGS}" ]; then
        echo "${RED}# Delete logs older than ${DELETE_LOGS} days old...${RESET}"
        find "./${DUPLICACY_LOGS}" -name "*-backup.log" -type f -mtime "+${DELETE_LOGS}" -delete
        echo "${RED}# Done${RESET}"
    fi

    echo "${MAGENTA}# Start Backup...${RESET}"
    DATETIME=$(date "+%Y%m%d-%H%M%S")
    if [[ "${3}" == "hash" ]]; then
        "${DUPLICACY}" -log backup -storage "${2}" -stats -threads 4 -hash | tee "$DUPLICACY_LOGS/$DATETIME-backup.log"
    else
        "${DUPLICACY}" -log backup -storage "${2}" -stats -threads 4       | tee "$DUPLICACY_LOGS/$DATETIME-backup.log"
    fi
    echo "${MAGENTA}# Done${RESET}"

    if [[ "${3}" == "check" ]]; then
        echo ""
        echo "${CYAN}### Check Backups... ###${RESET}"
        DATETIME=$(date "+%Y%m%d-%H%M%S")
        "${DUPLICACY}" -log check -all -storage "${2}" -tabular -threads 40 -persist | tee "$DUPLICACY_LOGS/$DATETIME-check.log"
        echo "#{CYAN}# Done"
    fi
}

if   [ "$(id -u)" -eq 0 ] && [[ "${MYHOST}" =~ (ariel|bethel) ]]; then
    ##### cd /etc             && duplicacy init -e -storage-name synology $(hostname -s)-etc--synology        "${SYNOLOGY_SFTP}"
    backupRepository /etc synology "${1}"
elif [ "$(id -u)" -eq 0 ] && [[ "${MYHOST}" =~ ^pvhost[0-9]$ ]]; then
    DUPLICACY="/usr/local/sbin/duplicacy"
    if [[ "${MYHOST}" == "pvhost1" ]]; then
        ##### cd /mnt/pve/cephfs  && duplicacy init -e -storage-name synology $(hostname -s)-cephfs--synology "${SYNOLOGY_SFTP}"
        backupRepository /mnt/pve/cephfs synology
    fi
    ##### cd /etc             && duplicacy init -e -storage-name synology $(hostname -s)-etc--synology        "${SYNOLOGY_SFTP}"
    backupRepository /etc synology
    ##### cd /root            && duplicacy init -e -storage-name synology $(hostname -s)-root--synology       "${SYNOLOGY_SFTP}"
    backupRepository /root synology
    ##### cd /usr/local       && duplicacy init -e -storage-name synology $(hostname -s)-usr_local--synology  "${SYNOLOGY_SFTP}"
    backupRepository /usr/local synology
    ##### cd /home/tom        && duplicacy init -e -storage-name synology $(hostname -s)-tom--synology        "${SYNOLOGY_SFTP}"
    backupRepository /home/tom synology "${1}"
elif [ "$(id -u)" -eq 0 ] && [[ "${MYHOST}" == "theophilus" ]]; then
    ##### cd /etc             && duplicacy init -e -storage-name synology $(hostname -s)-etc--synology        "${SYNOLOGY_SFTP}"
    backupRepository /etc synology
    ##### cd /root            && duplicacy init -e -storage-name synology $(hostname -s)-root--synology       "${SYNOLOGY_SFTP}"
    backupRepository /root synology
    ##### cd /usr/local       && duplicacy init -e -storage-name synology $(hostname -s)-usr_local--synology  "${SYNOLOGY_SFTP}"
    backupRepository /usr/local synology "${1}"
elif [[ "$(whoami)" == "tom" ]] && [[ "${MYHOST}" =~ (ariel|bethel) ]]; then
    if [[ "${MYHOST}" == "bethel" ]]; then
        backupRepository /Volumes/external/Databases rsyncNet
        backupRepository /Volumes/external/Pictures rsyncNet
        backupRepository /Volumes/external/ResilioSync rsyncNet
        backupRepository /Volumes/external/Sync rsyncNet
        backupRepository /Volumes/external/backups rsyncNet
        backupRepository /Volumes/external/docker rsyncNet
        backupRepository /Volumes/external/git rsyncNet
        # backupRepository /Volumes/external/minio rsyncNet
        backupRepository /Volumes/external/podman rsyncNet
        backupRepository /Volumes/external/rsync rsyncNet
        # backupRepository /Volumes/USBAC rsyncNet hash
    fi
    ##### cd /Users/tom/Dropbox/tc && duplicacy init -e -storage-name synology -c 1M -max 1M -min 1M tc--synology                 "${SYNOLOGY_SFTP}"
    # TODO backupRepository /Users/tom/Dropbox/tc synology hash
    ##### cd /Volumes/USBAC        && duplicacy init -e -storage-name synology -c 1M -max 1M -min 1M USBAC--synology              "${SYNOLOGY_SFTP}"
    # TODO backupRepository /Volumes/USBAC synology hash
    ##### cd                       && duplicacy init -e -storage-name synology                       $(hostname -s)-tom--synology "${SYNOLOGY_SFTP}"
    # TODO backupRepository /Users/tom synology "${1}"

    ##### cd /Users/tom/Dropbox/tc && duplicacy init -e -storage-name rsyncNet -c 1M -max 1M -min 1M tc--rsyncNet                 "${RSYNCNET_SFTP}"
    backupRepository /Users/tom/Dropbox/tc rsyncNet hash
    ##### cd /Volumes/USBAC        && duplicacy init -e -storage-name rsyncNet -c 1M -max 1M -min 1M USBAC--rsyncNet              "${RSYNCNET_SFTP}"
    backupRepository /Volumes/USBAC rsyncNet hash
    ##### cd                       && duplicacy init -e -storage-name rsyncNet                       $(hostname -s)-tom--rsyncNet "${RSYNCNET_SFTP}"
    backupRepository /Users/tom rsyncNet "${1}"
elif [[ "$(whoami)" == "tom" ]] && [[ "${MYHOST}" == "theophilus" ]]; then
    ##### cd /home/tom        && duplicacy init -e -storage-name synology                            $(hostname -s)-tom--synology "${SYNOLOGY_SFTP}"
    backupRepository /home/tom synology "${1}"
fi

if [[ "${MYHOST}" == "synology" ]]; then
    ##### cd /volume1/archive && ~/bin/duplicacy init -e                -storage-name synology synology-archive--synology /volume1/zz_duplicacy-backups
    ##### cd /volume1/archive && ~/bin/duplicacy add  -e -bit-identical -copy synology bethel   synology-archive--bethel   "${SYNOLOGY_SFTP}"
    ##### cd /volume1/archive && ~/bin/duplicacy add  -e -bit-identical -copy synology b2       synology-archive--b2       "${B2_SFTP}"
    DUPLICACY="/var/services/homes/tom/bin/duplicacy"
    backupRepository /volume1/archive synology
    backupRepository /volume1/audio synology
    backupRepository /volume1/homes synology
    backupRepository /volume1/music synology
    backupRepository /volume1/photo synology
    # backupRepository /volume1/reference synology
    backupRepository /volume1/video synology
    backupRepository /volume1/zz_backups synology

    echo ""
    echo "${CYAN}### Copy to bethel... ###${RESET}"
    DATETIME=$(date "+%Y%m%d-%H%M%S")
    "${DUPLICACY}" -log copy -from synology -to bethel         | grep -v "INFO SNAPSHOT_EXIST Snapshot .* already exists at the destination storage" | tee "$DUPLICACY_LOGS/$DATETIME-copy-bethel.log"
    echo "${CYAN}# Done${RESET}"

    echo ""
    echo "${CYAN}### Copy to Backblaze... ###${RESET}"
    DATETIME=$(date "+%Y%m%d-%H%M%S")
    "${DUPLICACY}" -log copy -from synology -to b2 -threads 4  | grep -v "INFO SNAPSHOT_EXIST Snapshot .* already exists at the destination storage" | tee "$DUPLICACY_LOGS/$DATETIME-copy-b2.log"
    echo "${CYAN}# Done${RESET}"

    # echo ""
    # echo "${RED}### Prune Backups... ###${RESET}"
    # "${DUPLICACY}" -log prune                   -all -keep 0:360 -keep 30:180 -keep 7:30 -keep 1:7 | tee "$DUPLICACY_LOGS/$DATETIME-prune.log"
    # DATETIME=$(date "+%Y%m%d-%H%M%S")
    # "${DUPLICACY}" -log prune                   -all -keep 30:180 -keep 7:30 -keep 1:7 | tee "$DUPLICACY_LOGS/$DATETIME-prune.log"
    # DATETIME=$(date "+%Y%m%d-%H%M%S")
    # "${DUPLICACY}" -log prune -storage b2       -all -keep 30:180 -keep 7:30 -keep 1:7 | tee "$DUPLICACY_LOGS/$DATETIME-prune-b2.log"
    # echo "${RED}# Done${RESET}"

# TODO add prune/check for rsyncNet
    if [[ "${1}" == "check" ]]; then
        cd /volume1/archive || exit
        echo ""
        echo "${CYAN}### Check Backups... ###${RESET}"
        DATETIME=$(date "+%Y%m%d-%H%M%S")
        "${DUPLICACY}" -log check -all -storage synology -tabular -chunks -threads 40 -persist | tee "$DUPLICACY_LOGS/$DATETIME-check.log"
        DATETIME=$(date "+%Y%m%d-%H%M%S")
        "${DUPLICACY}" -log check -all -storage bethel                                         | tee "$DUPLICACY_LOGS/$DATETIME-check-bethel.log"
        DATETIME=$(date "+%Y%m%d-%H%M%S")
        "${DUPLICACY}" -log check -all -storage b2                                             | tee "$DUPLICACY_LOGS/$DATETIME-check-b2.log"
        echo "${CYAN}# Done${RESET}"
    fi
fi
