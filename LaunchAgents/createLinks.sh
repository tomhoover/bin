#!/usr/bin/env bash

[[ "$(uname)" = "Darwin" ]] || exit

cd "${HOME}/Library/LaunchAgents" && ln -s ../../bin/LaunchAgents/*.plist .

cd "${HOME}/bin/LaunchDaemons-System" && sudo chown root:wheel us.t0m.*.plist
cd /Library/LaunchDaemons && sudo ln -s /Users/tom/bin/LaunchDaemons-System/us.t0m.*.plist .
