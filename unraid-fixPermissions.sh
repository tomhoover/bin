#!/bin/sh

[ "$(hostname -s)" = unraid  ] || exit

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

fixPermissions()
{
    cd "$1" && pwd
    find . -type d -exec chmod 775 {} \;
    find . -type f -exec chmod 664 {} \;
    chown -R tom:users -- *
}

fixPermissions "/mnt/user/Movies"
fixPermissions "/mnt/user/TV Shows"
fixPermissions "/mnt/user/PlayOn"
fixPermissions "/mnt/user/Media"
