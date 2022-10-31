#!/usr/bin/env sh
# shellcheck disable=all

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
set -eu

if [ $# -eq 0  ]; then
    echo "No arguments provided"
    exit 1
fi

mkdir -p /Volumes/IRONKEY8/annex || exit

#createBareRepo
cd /Volumes/IRONKEY8/annex && mkdir "$1.git" && cd "$1.git" && pwd
git init --bare && git annex init ironkey

#addRemotes
cd "$HOME/annex/$1" && pwd && \
    git remote add ironkey "/Volumes/IRONKEY8/annex/$1.git" && \
    git annex wanted ironkey standard && git annex group ironkey manual && \
    git annex sync
cd "/Volumes/RAID10/annex/$1" && pwd && \
    git remote add ironkey "/Volumes/IRONKEY8/annex/$1.git" && \
    git annex sync
