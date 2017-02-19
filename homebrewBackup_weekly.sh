#!/bin/sh

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

# shellcheck disable=SC1090
. "$HOME/.keychain/$(hostname -s)-sh"
/usr/local/bin/brew list > "$HOME/.config/homebrew/brew.installed"
/usr/local/bin/brew cask list > "$HOME/.config/homebrew/cask.installed"
/usr/local/bin/brew bundle dump --global --force
/usr/local/bin/vcsh homebrew add "$HOME/.Brewfile"
/usr/local/bin/vcsh homebrew add "$HOME/.config/homebrew/*"
/usr/local/bin/vcsh homebrew commit -m "$(date)"
/usr/local/bin/vcsh homebrew push
