#!/bin/sh

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

if [ $# -eq 0  ]; then
    echo "No arguments provided"
    exit 1
fi

echo "===== Creating /Volumes/annex/$1 git-annex repository on drobo ====="
echo ""
cd /Volumes/annex && mkdir "$1" && cd "$1" && git init && git annex init drobo
echo ""
echo "=================================================="
echo ""

echo "===== Adding special remotes ====="
echo ""
echo "     to ariel..."
cd "$HOME/annex/$1" && git annex initremote drobo type=directory directory="/Volumes/annex/$1/" encryption=shared && git annex sync
echo "     to RAID10..."
cd "/Volumes/RAID10/annex/$1" && git annex enableremote drobo && git annex sync
echo ""
echo "=================================================="
echo ""

echo "===== set wanted files ====="
echo ""
cd "$HOME/annex/$1" && git annex wanted drobo standard && git annex group drobo backup && git annex sync
echo ""
echo "=================================================="
echo ""

echo "===== git configs ====="
echo ""
cd ~/annex && \
    echo "ariel:"
    cat "$1/.git/config"
    echo "----------"
    echo ""
cd /Volumes/RAID10/annex && \
    echo "RAID10:"
    cat "$1/.git/config"
    echo "----------"
    echo ""
echo "unraid:"
# shellcheck disable=SC1078
# shellcheck disable=SC1079
# shellcheck disable=SC2086
ssh tom@unraid bash -c "'
cat "annex/$1/.git/config"
'"

echo "===== reminder to edit .gitattributes ====="
echo ""
cd "$HOME/annex/$1" && echo "* annex.numcopies=3" >> .gitattributes && vi .gitattributes
cd "$HOME/annex/$1" && git add .gitattributes && git commit -m 'updated annex.numcopies' && git annex sync
