#!/usr/bin/env bash

# shellcheck disable=SC1090
[ -r "$HOME"/.keychain/"$(uname -n)"-sh ] && . "$HOME"/.keychain/"$(uname -n)"-sh

cd ~/Vault || exit
git pull
git add "*.md" 2>/dev/null
git commit -am "$(date '+%Y-%m-%d %H:%M')" >/dev/null 2>&1 && git push origin
