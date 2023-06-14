#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

MYHOST=$(uname -n | sed 's/\..*//')     # alternative to $(hostname -s), as arch does not install 'hostname' by default

# shellcheck source=/dev/null
[ -r "$HOME"/.keychain/"$(uname -n)"-sh ] && . "$HOME"/.keychain/"$(uname -n)"-sh

brew bundle dump --force --file="$HOME/.homebrew-brewfile/Brewfile.${MYHOST}"
cd "$HOME/.homebrew-brewfile" && git pull && git commit -am "${MYHOST} - $(date)" && git push origin; git push gitea
