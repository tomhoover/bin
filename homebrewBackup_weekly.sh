#!/bin/sh

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

GIT=/usr/local/bin/git

# shellcheck disable=SC1090
. "$HOME/.keychain/$(hostname -s)-sh"

/usr/local/bin/brew bundle dump --force --file="$HOME/.homebrew-brewfile/Brewfile"
cd "$HOME/.homebrew-brewfile" && $GIT add Brewfile && $GIT commit -m "$(date)" && $GIT push origin; $GIT push gitolite
