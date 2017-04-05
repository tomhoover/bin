#!/bin/bash

# set -e: exit script immediately upon error
set -e

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

if [ "$(hostname -s)" = ariel ]; then
    mkdir -pm 700 /Users/tom/.config-backup
    CONFIG_DIR=/Users/tom/.config-backup/ariel
elif [ "$(hostname -s)" = lemuel ]; then
    mkdir -pm 700 /root/.config-backup
    CONFIG_DIR=/root/.config-backup/lemuel
else
    exit
fi

mkdir -p "$CONFIG_DIR" || exit
cd "$CONFIG_DIR" && git pull --rebase --autostash

CONFIG_LIST=$CONFIG_DIR/config.txt

if [ "$1" != ""  ] ; then echo "$(pwd)/$1" >> "$CONFIG_LIST" ; fi
sort -uo "$CONFIG_LIST" "$CONFIG_LIST"
rsync -av --files-from=$CONFIG_LIST / "$CONFIG_DIR/"
cd "$CONFIG_DIR" && git add . && git commit -m "$(date)" && git push

tree -aI .git "$CONFIG_DIR/.."
