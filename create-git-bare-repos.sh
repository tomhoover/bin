#!/usr/bin/env sh
# shellcheck disable=SC1078,SC1079,SC2086

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails

if [ $# -eq 0  ]; then
    echo "No arguments provided"
    exit 1
fi

echo "===== Creating $1.git bare repos ====="
echo ""
echo "     bethel..."
ssh tom@bethel git init --bare git/$1.git
# echo ""
# echo "     drobo..."
# ssh tom@drobo bash -c "'
# cd git && mkdir "$1.git" && cd "$1.git" && pwd
# git init --bare
# '"
# echo ""
# echo "     gabriel..."
# ssh tom@gabriel bash -c "'
# cd git && mkdir "$1.git" && cd "$1.git" && pwd
# git init --bare
# '"
# echo ""
# echo "     synology..."
# ssh tom@SYNOLOGY bash -c "'
# cd git && mkdir "$1.git" && cd "$1.git" && pwd
# git init --bare
# '"
# echo ""
