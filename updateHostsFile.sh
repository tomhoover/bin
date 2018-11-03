#!/bin/sh
# requires https://github.com/StevenBlack/hosts

cd ~/src/github.com/stevenblack/hosts/ || exit
git pull --rebase --autostash

cp ~/.config/hosts/* .
python3 updateHostsFile.py -a -o alternates/tch -e porn

#if [ ! "$1" = "runfromcron" ] ; then
#    scp ~/src/github.com/stevenblack/hosts/alternates/tch/hosts manuel:/tmp
#    echo "enter sudo password for manuel"
#    ssh -t manuel 'sudo mv /tmp/hosts /etc && sudo chown root /etc/hosts'
#    ssh manuel 'ls -l /etc/hosts'
#fi

git reset --hard HEAD
