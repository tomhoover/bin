#!/bin/bash

# Exit immediately on error.
set -e

#ssh root@unraid echo "export TERM=linux" >> .bash_profile
ssh-copy-id root@unraid
ssh root@unraid 'cat .ssh/authorized_keys'

#ssh root@unraid mkdir -p bin
scp ~/.boto root@unraid:
ssh root@unraid 'mkdir -p Dropbox'
ssh root@unraid 'curl -L https://github.com/sequenceiq/docker-alpine-dig/releases/download/v9.10.2/dig.tgz|tar -xzv -C /usr/local/bin/'
scp ~/bin/ddns.sh root@unraid:/etc/cron.hourly
ssh root@unraid 'ls -l /etc/cron.hourly'
scp ~/src/bootstrap/bootstrap.sh root@unraid:
echo "ssh to unraid and execute bootstrap.sh"
