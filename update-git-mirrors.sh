#!/bin/bash

# set -e: exit script immediately upon error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -e -o pipefail

updateMirror()
{
    echo "***** sync $1 *****"
    cd "$1" && echo ""
    git remote update
    echo ""
}

listMirrors()
{
    echo ""
    cd "$1" && for DIR in *
    do
        updateMirror "$1/$DIR"
    done
}

echo "PATH = $PATH" && echo ""

listMirrors /srv/git/github.com-tomhoover
listMirrors /srv/git/git.joeyh.name
listMirrors /srv/git/git.joeyh.name-joey
listMirrors /srv/git/git.spwhitton.name
