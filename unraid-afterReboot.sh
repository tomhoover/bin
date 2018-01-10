#!/bin/bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

read -n 1 -s -r -p "Settings/SSH, stop SSH daemon, set 'password authentication' to 'yes', apply"

echo ""
echo "===== (root) copy authorized_keys, config & github_rsa to .ssh"
echo "  NOTE: you may have to enter root password twice"
echo ""
ssh root@unraid 'mkdir -p .ssh && chmod 700 .ssh && ls -al'
ssh-copy-id -i ~/.ssh/id_rsa.pub root@unraid
ssh root@unraid 'cat .ssh/authorized_keys'
scp ~/.ssh/config root@unraid:.ssh
scp ~/.ssh/github_rsa root@unraid:.ssh
ssh root@unraid 'ls -al .ssh'
echo ""

echo "===== download dig"
ssh root@unraid 'curl -L https://github.com/sequenceiq/docker-alpine-dig/releases/download/v9.10.2/dig.tgz|tar -xzv -C /usr/local/bin/'
echo ""

echo "===== copy scripts to /etc/cron.hourly"
scp ~/bin/ddns.sh root@unraid:/etc/cron.hourly
scp ~/bin/unraid-hourlyFixPermissions.sh root@unraid:/etc/cron.hourly
ssh root@unraid 'ls -l /etc/cron.hourly'
echo ""

echo "===== copy scripts to /etc/cron.daily"
scp ~/bin/getMovieList.sh root@unraid:/etc/cron.daily
ssh root@unraid 'ls -l /etc/cron.weekly'
echo ""

echo "===== copy scripts to /etc/cron.weekly"
scp ~/bin/unraid-fixPermissions.sh root@unraid:/etc/cron.weekly
ssh root@unraid 'ls -l /etc/cron.weekly'
echo ""

echo "===== copy .boto & bootstrap.sh to root"
ssh root@unraid 'mkdir -p Dropbox'
ssh root@unraid 'touch Dropbox/lastip'
scp ~/.boto root@unraid:
scp ~/.dotfiles/script/bootstrap root@unraid:bootstrap.sh
ssh root@unraid 'ls -al'
echo ""

echo "===== diff /etc/passwd /boot/config/passwd"
ssh root@unraid 'diff /etc/passwd /boot/config/passwd || cp /boot/config/passwd /etc/passwd'
echo ""

echo "home directory should be /mnt/cache/appdata/home/tom"
echo ""
ssh root@unraid 'tail /etc/passwd'
echo ""

read -n 1 -s -r -p "Verify array has been started, and press any key to continue"

echo ""
echo "===== copy bootstrap.sh to tom"
scp ~/.dotfiles/script/bootstrap tom@unraid:bootstrap.sh
ssh tom@unraid 'ls -al'

echo "ssh to unraid (both root & tom) and execute bootstrap.sh"

echo ""
read -n 1 -s -r -p "Settings/SSH, stop SSH daemon, set 'password authentication' to 'no', apply"

