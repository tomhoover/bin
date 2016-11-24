#!/bin/bash

# Exit immediately on error.
set -e

# shellcheck disable=SC1090
. "$HOME/.keychain/$HOSTNAME-sh"
/usr/local/bin/brew list > ~/.config/homebrew/brew.installed
/usr/local/bin/brew cask list > ~/.config/homebrew/cask.installed
/usr/local/bin/vcsh homebrew add ~/.config/homebrew/*
/usr/local/bin/vcsh homebrew commit -m "$(date)"
/usr/local/bin/vcsh homebrew push
