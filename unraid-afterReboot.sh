#!/bin/bash

# Exit immediately on error.
set -e

echo "===== copy authorized_keys, config & github_rsa to .ssh"
ssh-copy-id -i ~/.ssh/id_rsa.pub root@unraid
ssh root@unraid 'cat .ssh/authorized_keys'
scp ~/.ssh/config root@unraid:.ssh
scp ~/.ssh/github_rsa root@unraid:.ssh
ssh root@unraid 'ls -al .ssh'
echo ""

echo "===== download dig"
ssh root@unraid 'curl -L https://github.com/sequenceiq/docker-alpine-dig/releases/download/v9.10.2/dig.tgz|tar -xzv -C /usr/local/bin/'
echo ""

echo "===== copy ddns.sh to /etc/cron.hourly"
scp ~/bin/ddns.sh root@unraid:/etc/cron.hourly
ssh root@unraid 'ls -l /etc/cron.hourly'
echo ""

echo "===== copy .boto & bootstrap.sh"
ssh root@unraid 'mkdir -p Dropbox'
ssh root@unraid 'touch Dropbox/lastip'
scp ~/.boto root@unraid:
scp ~/.dotfiles/script/bootstrap root@unraid:bootstrap.sh
ssh root@unraid 'ls -al'
echo ""

echo "ssh to unraid and execute bootstrap.sh"
