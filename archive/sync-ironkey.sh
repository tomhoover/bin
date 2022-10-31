#!/usr/bin/env sh

cd /Volumes/IRONKEY8 || exit

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
    cd "$1" && pwd && \
    git push ironkey
}

listAnnex()
{
cd "$1" && for DIR in *
do
    syncAnnex "$1/$DIR"
done
}

~/bin/sync-annex.sh

echo "***** git annex sync --content: doc"
syncAnnex /Volumes/IRONKEY8/annex/doc

~/bin/sync-annex.sh fsck ironkey

~/bin/sync-annex.sh

echo "***** git push ironkey: .gnupg"
syncGit ~/.gnupg

echo "***** vcsh private push ironkey"
cd && vcsh private push ironkey
