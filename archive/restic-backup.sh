#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

[[ -f ${HOME}/.SECRETS ]] && . "${HOME}"/.SECRETS

# removed export RESTIC_REPOSITORY=sftp:restic.drobo:restic in ~/.exports
#restic -r $RESTIC_REPOSITORY init
#sftp restic.drobo
#restic -r b2:restic-tch-backup init
#exit

if [ "$(hostname -s)" = "ariel" ] ; then
    [ "$(command -v restic)" ] || brew install restic
    RESTIC="restic"

#    REPO=sftp:restic.drobo:restic
#    ${RESTIC} backup \
#        -r ${REPO} \
#        --exclude-file=.config/restic/ariel.exclude \
#        --exclude='/Users/tom/Music/iTunes/iTunes Media' \
#        ~ /Volumes/RAID10/Music /Volumes/RAID10/Photos
#    ${RESTIC} -r ${REPO} snapshots
##    ${RESTIC} -r ${REPO} prune

    REPO=b2:restic-tch-backup
    # ${RESTIC} -r ${REPO} unlock
    ${RESTIC} backup \
        -r ${REPO} \
        -o b2.connections=50 \
        --exclude-file="$HOME"/.config/restic/ariel.exclude \
        ~ /Volumes/RAID10/Photos
    ${RESTIC} -r ${REPO} check
    ${RESTIC} -r ${REPO} snapshots
    ${RESTIC} -r ${REPO} ls -l latest | sort -k 4 -n > restic-b2.txt
#    ${RESTIC} -r ${REPO} prune

    REPO=s3:https://s3.wasabisys.com/restic-tch-backup
    # ${RESTIC} -r ${REPO} unlock
    # ${RESTIC} -r ${REPO} rebuild-index
    ${RESTIC} backup \
        -r ${REPO} \
        --exclude-file="$HOME"/.config/restic/ariel.exclude \
        ~ /Volumes/RAID10/Photos
    ${RESTIC} -r ${REPO} check
    ${RESTIC} -r ${REPO} snapshots
    ${RESTIC} -r ${REPO} ls -l latest | sort -k 4 -n > restic-wasabi.txt
#    ${RESTIC} -r ${REPO} prune

elif [ "$(hostname -s)" = "gabriel" ] ; then
    RESTIC="docker run --rm restic/restic"

    REPO=sftp:restic.drobo:restic
    ${RESTIC} backup \
        -r ${REPO} \
        --exclude-file=.config/restic/gabriel.exclude \
        --exclude='/home/tom/src/github.com' \
        ~
    ${RESTIC} -r ${REPO} snapshots
#    ${RESTIC} -r ${REPO} prune

    REPO=b2:restic-tch-backup
    ${RESTIC} backup \
        -r ${REPO} \
        -o b2.connections=20 \
        --exclude-file=.config/restic/gabriel.exclude \
        --exclude='/home/tom/src/github.com' \
        ~
    ${RESTIC} -r ${REPO} snapshots
#    ${RESTIC} -r ${REPO} prune

fi
