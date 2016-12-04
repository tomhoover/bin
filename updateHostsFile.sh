#!/bin/sh
# requires https://github.com/StevenBlack/hosts

cd ~/src/github.com/stevenblack/hosts/ || exit
cp ~/.config/hosts/* .
./makeHosts
