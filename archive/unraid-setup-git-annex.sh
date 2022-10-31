#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

echo "===== setup git-annex"
# shellcheck disable=SC1078
# shellcheck disable=SC1079
ssh tom@unraid bash -c "'
wget https://downloads.kitenet.net/git-annex/linux/current/git-annex-standalone-amd64.tar.gz && tar xzvf git-annex-standalone-amd64.tar.gz && rm git-annex-standalone-amd64.tar.gz
echo PATH=\$HOME/git-annex.linux:\$PATH:\$HOME/bin > .bash_profile
git config --global user.email tom@example.com && git config --global user.name Tom\ Thumb
#echo "screen -t shell 0" > .screenrc
#echo "cd /mnt/user/annex/movies" >> .screenrc
#echo "screen -t movies 1 git annex sync --content" >> .screenrc
#echo "cd /mnt/user/annex/tv" >> .screenrc
#echo "screen -t tv 2 git annex sync --content" >> .screenrc
cat .bash_profile .gitconfig .screenrc
mkdir -p ~/bin
'"
scp ~/.rclone.conf tom@unraid:
scp ~/bin/git-annex-remote-rclone tom@unraid:bin
