#!/usr/bin/env bash

# shellcheck source=/dev/null
source ~/bin/get_os.sh

isdarwin || exit

date '+%Y-%m-%d %H:%M:%S' >>"/Users/tom/.lastSuperDuperBackupDate"
