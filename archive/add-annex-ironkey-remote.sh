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

#createRepo
cd /Volumes/IRONKEY8/annex && mkdir "$1" && cd "$1" && pwd
git init && git annex init ironkey

#addRemotes
cd "$HOME/annex/$1" && pwd && \
    git remote add ironkey "/Volumes/IRONKEY8/annex/$1" && \
    git annex wanted ironkey standard && git annex group ironkey client && \
    git annex sync
cd "/Volumes/RAID10/annex/$1" && pwd && \
    git remote add ironkey "/Volumes/IRONKEY8/annex/$1" && \
    git annex sync
cd "/Volumes/IRONKEY8/annex/$1" && pwd && \
    git remote add ariel "$HOME/annex/$1" && \
    git remote add RAID10 "/Volumes/RAID10/annex/$1" && \
    git annex sync --content
