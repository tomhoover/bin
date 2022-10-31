#!/usr/bin/env bash

PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/s#bin:/Users/tom/bin:/home/tom/bin
#syncoid --identifier=external --exclude=Music -r tank/RAID10 external/backups/RAID10
#syncoid --identifier=gabriel -r tank/RAID10/Photos root@gabriel:tank/backups/ariel/photos
#syncoid --identifier=gabriel -r tank/RAID10/Music root@gabriel:tank/backups/ariel/music

simplesnap --host ariel   --setname ariel --store external/backups --local
#simplesnap --host bethel  --setname ariel --store external/backups --sshcmd "ssh -i /root/.ssh/id_rsa_simplesnap"
#simplesnap --host gabriel --setname ariel --store external/backups --sshcmd "ssh -i /root/.ssh/id_rsa_simplesnap"
#simplesnap --host gabriel --setname ariel --store external/backups --sshcmd "ssh -i /root/.ssh/id_rsa_simplesnap" --backupdataset rpool/var/lib/docker
simplesnap --host proxmox --setname ariel --store external/backups --sshcmd "ssh -i /var/root/.ssh/id_rsa_simplesnap"
