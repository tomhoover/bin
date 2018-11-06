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
echo "     unraid..."
ssh tom@unraid bash -c "'
cd git && mkdir "$1.git" && cd "$1.git" && pwd
git init --bare
'"
echo "     drobo..."
ssh tom@drobo bash -c "'
cd git && mkdir "$1.git" && cd "$1.git" && pwd
git init --bare
'"
echo ""
