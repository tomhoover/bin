#!/bin/bash

# set -e: exit script immediately upon error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -e -o pipefail

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

if [ "$(hostname -s)" = ariel ]; then
    CONFIG_DIR=/Users/tom/.config-backup
elif [ "$(hostname -s)" = lemuel ]; then
    CONFIG_DIR=/root/.config-backup
else
    exit
fi

CONFIG_LIST=$CONFIG_DIR/config.txt

mkdir -pm 700 "$CONFIG_DIR" || exit

if [ "$1" != ""  ] ; then echo "$(pwd)/$1" >> "$CONFIG_LIST" ; fi
sort -uo "$CONFIG_LIST" "$CONFIG_LIST"
rsync -av --files-from=$CONFIG_LIST / "$CONFIG_DIR/"
cd "$CONFIG_DIR" && git add . && git commit -m "$(date)"

tree -aI .git "$CONFIG_DIR"
