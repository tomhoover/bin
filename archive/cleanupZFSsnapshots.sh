#!/bin/bash
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/tom/bin:/home/tom/bin
zfsnap.sh destroy -rsSv -F 2d -p 15min-             tank/RAID10
zfsnap.sh destroy -rsSv -F 2w -p daily-             tank/RAID10
zfsnap.sh destroy -rsSv -F 2m -p weekly- -p reboot- tank/RAID10
zfsnap.sh destroy -rsSv -F 4m -p monthly-           tank/RAID10
zfsnap.sh destroy -rsSv       -p 15min- -p daily- -p weekly- -p reboot- external/backups

# ZFS check
simplesnap --host ariel   --setname gabriel --store backups --check "1 day ago"
#simplesnap --host bethel  --setname gabriel --store backups --check "1 day ago"
simplesnap --host gabriel --setname gabriel --store backups --check "1 day ago"
simplesnap --host proxmox --setname gabriel --store backups --check "1 day ago"

