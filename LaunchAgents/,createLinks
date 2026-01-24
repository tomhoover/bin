#!/usr/bin/env bash

[[ "$(uname)" = "Darwin" ]] || exit

cd "${HOME}/Library/LaunchAgents" || exit
ln -s ../../bin/LaunchAgents/*.plist . 2>/dev/null
for f in us.t0m.*.plist
do
    echo "$f"
    sudo launchctl bootstrap user/"$(id -u)/${HOME}/Library/LaunchAgents/$f"
done

cd /Library/LaunchDaemons || exit
sudo cp /Users/tom/bin/LaunchDaemons-System/us.t0m.*.plist .
for f in us.t0m.*.plist
do
    echo "$f"
    sudo launchctl bootout system /Library/LaunchDaemons/"$f"
    sudo launchctl bootstrap system /Library/LaunchDaemons/"$f"
done

sudo launchctl list |grep us.t0m
