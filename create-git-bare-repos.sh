#!/bin/sh

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
set -eu

if [ $# -eq 0  ]; then
    echo "No arguments provided"
    exit 1
fi

echo "===== Creating $1.git bare repos ====="
echo ""
echo "     bethel..."
ssh tom@bethel bash -c "'
cd git && mkdir "$1.git" && cd "$1.git" && pwd
git init --bare
'"
echo ""
echo "     drobo..."
ssh tom@drobo bash -c "'
cd git && mkdir "$1.git" && cd "$1.git" && pwd
git init --bare
'"
echo ""
echo "     gabriel..."
ssh tom@gabriel bash -c "'
cd git && mkdir "$1.git" && cd "$1.git" && pwd
git init --bare
'"
echo ""
