#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

RED=$(tput setaf 1)
# GREEN=$(tput setaf 2)
# YELLOW=$(tput setaf 3)
# BLUE=$(tput setaf 4)
# MAGENTA=$(tput setaf 5)
# CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

vcsh list | while read -r REPOSITORY; do
    br=0
    rem=0
    st=0
    if [ "$( vcsh "${REPOSITORY}" branch -avv | sed -e '/[* ]*github/d' -e '/[* ]*main/d' -e '/[* ]*master/d' )" != "" ]; then
        br=1
    fi
    if [ "$( vcsh "${REPOSITORY}" status -s )" != "" ]; then
        st=1
    fi
    if [[ $br -gt 0  || $rem -gt 0 || $st -gt 0 ]]; then
        echo "" && echo "### ${REPOSITORY}"
        if [ $br = "1" ]; then
            echo "- Branches:"
            vcsh "${REPOSITORY}" branch -avv
        fi
        if [ $rem = "1" ]; then
            echo "- Remotes:"
            vcsh "${REPOSITORY}" remote
        elif [ $rem = "2" ]; then
            echo "- Remotes:"
            vcsh "${REPOSITORY}" remote -v
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
    eval cd "${REPOSITORY}" || { echo ""; echo "${RED}ABORTED!${RESET} ${REPOSITORY} does not exist!"; echo ""; exit 99; }
    if [ "$( git branch -avv | sed -e '/[* ]*github/d' -e '/[* ]*main/d' -e '/[* ]*master/d' )" != "" ]; then
        br=1
    fi
    if [ "$( git status -s )" != "" ]; then
        st=1
    fi
    if [[ $br -gt 0 || $rem -gt 0 || $st -gt 0 ]]; then
        echo "" && echo "### ${REPOSITORY}"
        if [ $br = "1" ]; then
            echo "- Branches:"
            git branch -avv
        fi
        if [ $rem = "1" ]; then
            echo "- Remotes:"
            git remote
        elif [ $rem = "2" ]; then
            echo "- Remotes:"
            git remote -v
        fi
        if [ $st = "1" ]; then
            echo "- Status:"
            git status -s
        fi
    fi
done
