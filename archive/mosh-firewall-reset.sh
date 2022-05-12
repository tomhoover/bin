#!/bin/sh

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

VERSION=$(ls -1 /usr/local/Cellar/mosh | tail -n 1)

sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /usr/local/Cellar/mosh/$VERSION/bin/mosh-server
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp /usr/local/Cellar/mosh/$VERSION/bin/mosh-server
