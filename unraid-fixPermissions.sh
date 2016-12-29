#!/bin/sh

[ "$(hostname -s)" = unraid  ] || exit

# Exit immediately on error.
set -e

fixPermissions()
{
    cd "$1" && pwd
    find . -type d -exec chmod 775 {} \;
    find . -type f -exec chmod 664 {} \;
    chown -R tom *
}

fixPermissions "/mnt/user/Movies"
fixPermissions "/mnt/user/TV Shows"
fixPermissions "/mnt/user/PlayOn"
fixPermissions "/mnt/user/Media"
