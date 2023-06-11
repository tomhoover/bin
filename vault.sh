#!/usr/bin/env bash

# shellcheck source=/dev/null
[ -r "$HOME"/.keychain/"$(uname -n)"-sh ] && . "$HOME"/.keychain/"$(uname -n)"-sh

vcsh vault pull 2>/dev/null 2>&1
vcsh vault add "*.md" 2>/dev/null
vcsh vault commit -am "$(date '+%Y-%m-%d %H:%M')" >/dev/null 2>&1 && vcsh vault push origin
