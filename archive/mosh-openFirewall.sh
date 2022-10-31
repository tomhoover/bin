#!/usr/bin/env bash
# shellcheck disable=all

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

MOSH_SERVER=$(ls -l "$(which mosh-server)" | sed 's|^.*Cellar|/usr/local/Cellar|')

echo ""
echo "enter sudo password when prompted:"
echo ""

sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add "$MOSH_SERVER"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp "$MOSH_SERVER"
