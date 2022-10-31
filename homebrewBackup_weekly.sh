#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

# shellcheck source=/dev/null
. "$HOME"/.keychain/"$(hostname)"-sh

brew bundle dump --force --file="$HOME/.homebrew-brewfile/Brewfile.$(hostname -s)"
cd "$HOME/.homebrew-brewfile" && git pull && git commit -am "$(date)" && git push origin; git push gitolite
