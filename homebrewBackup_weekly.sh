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

if [ "$MYHOST" = "bethel" ]; then
    if [ "$(find /opt/homebrew/Cellar/minio -name homebrew.mxcl.minio.plist)" ]; then
       exit 0
    fi
    brew services stop minio
    VERSION_DIR="$(find /opt/homebrew/Cellar/minio -type d -depth 1 | tail -1)"
    cp ~/bin/LaunchAgents/homebrew.mxcl.minio.plist.backup "$VERSION_DIR/homebrew.mxcl.minio.plist"
    brew services start minio
fi
