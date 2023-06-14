#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

vcsh list | while read -r REPOSITORY; do
    br=0
    rem=0
    st=0
    if [ "$( vcsh "${REPOSITORY}" branch -vv | sed -e '/[* ]*github/d' -e '/[* ]*main/d' -e '/[* ]*master/d' )" != "" ]; then
        br=1
    fi
    if [ "$( vcsh "${REPOSITORY}" status -s )" != "" ]; then
        st=1
    fi
    if [[ $br = "1" || $rem = "1" || $st = "1" ]]; then
        echo "" && echo "### ${REPOSITORY}"
        if [ $br = "1" ]; then
            echo "- Branches:"
            vcsh "${REPOSITORY}" branch -vv
        fi
        if [ $rem = "1" ]; then
            echo "- Remotes:"
            vcsh "${REPOSITORY}" remote
        fi
        if [ $st = "1" ]; then
            echo "- Status:"
            vcsh "${REPOSITORY}" status -s
        fi
    fi
done

# shellcheck disable=SC2002
cat ~/tmp/all-git-repos.txt | while read -r REPOSITORY; do
    br=0
    rem=0
    st=0
    eval cd "${REPOSITORY}" || { echo ""; echo "$(tput setaf 1)ABORTED!$(tput sgr0)  ${REPOSITORY} does not exist!"; echo ""; exit 99; }
    if [ "$( git branch -vv | sed -e '/[* ]*github/d' -e '/[* ]*main/d' -e '/[* ]*master/d' )" != "" ]; then
        br=1
    fi
    if [ "$( git status -s )" != "" ]; then
        st=1
    fi
    if [[ $br = "1" || $rem = "1" || $st = "1" ]]; then
        echo "" && echo "### ${REPOSITORY}"
        if [ $br = "1" ]; then
            echo "- Branches:"
            git branch -vv
        fi
        if [ $rem = "1" ]; then
            echo "- Remotes:"
            git remote
        fi
        if [ $st = "1" ]; then
            echo "- Status:"
            git status -s
        fi
    fi
done
