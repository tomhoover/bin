#!/usr/bin/env sh

cd /Volumes/IRONKEY64 || exit

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
set -eu

syncAnnex()
{
    cd "$1" && pwd && \
    git annex sync && \
    git annex sync --content
}

syncGit()
{
    cd "$1" && \
    echo "***** git push ironkey: $1 *****" && \
    git push ironkey
}

listAnnex()
{
cd "$1" && for DIR in *
do
    syncAnnex "$1/$DIR"
done
}

# ~/bin/sync-annex.sh

# echo "***** git annex sync --content: doc"
# syncAnnex /Volumes/IRONKEY64/annex/doc

# ~/bin/sync-annex.sh fsck ironkey

# ~/bin/sync-annex.sh

syncGit ~/.gnupg

echo "***** vcsh private push ironkey *****"
vcsh private push ironkey

rsync -avz --rsync-path=/bin/rsync --delete --delete-excluded --exclude='@eaDir' --exclude='#recycle' --exclude='#snapshot' synology:/volume1/paperless/ /Volumes/IRONKEY64/paperless/
