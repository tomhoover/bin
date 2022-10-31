#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

# shellcheck source=/dev/null
. ~/.keychain/"$(uname -n)"-sh

screen -ls | grep "There is a screen" && screen -D -R
screen -ls | grep "No Sockets found" && screen -c ~/.screenrc-startup
