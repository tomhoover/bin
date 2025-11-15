#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

# shellcheck source=/dev/null
source ~/bin/COLORS

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
            echo "${CYAN}- Branches:${RESET}"
            vcsh "${REPOSITORY}" branch -avv
            if [ "$( vcsh "${REPOSITORY}" branch -vv | sed -e '/\[/d' )" != "" ]; then
                echo "- Local branches without remote tracking branch:"
                vcsh "${REPOSITORY}" branch -vv | sed -e '/\[/d'
            fi
        fi
        if [ $rem = "1" ]; then
            echo "${CYAN}- Remotes:${RESET}"
            vcsh "${REPOSITORY}" remote
        elif [ $rem = "2" ]; then
            echo "${CYAN}- Remotes:${RESET}"
            vcsh "${REPOSITORY}" remote -v
        fi
        if [ $st = "1" ]; then
            echo "${CYAN}- Status:${RESET}"
            vcsh "${REPOSITORY}" status -s
        fi
    fi
done

# shellcheck disable=SC2002
cat ~/tmp/all-git-repos.txt | while read -r REPOSITORY; do
    br=0
    rem=0
    st=0
    eval cd "${REPOSITORY}" || { echo ""; echo "ABORTED! ${REPOSITORY} does not exist!"; echo ""; exit 99; }
    if [ "$( git branch -avv | sed -e '/[* ]*github/d' -e '/[* ]*main/d' -e '/[* ]*master/d' )" != "" ]; then
        br=1
    fi
    if [ "$( git status -s )" != "" ]; then
        st=1
    fi
    if [[ $br -gt 0 || $rem -gt 0 || $st -gt 0 ]]; then
        echo "" && echo "### ${REPOSITORY}"
        if [ $br = "1" ]; then
            echo "${CYAN}- Branches:${RESET}"
            git branch -avv
            if [ "$( git branch -vv | sed -e '/\[/d' )" != "" ]; then
                echo "- Local branches without remote tracking branch:"
                git branch -vv | sed -e '/\[/d'
            fi
        fi
        if [ $rem = "1" ]; then
            echo "${CYAN}- Remotes:${RESET}"
            git remote
        elif [ $rem = "2" ]; then
            echo "${CYAN}- Remotes:${RESET}"
            git remote -v
        fi
        if [ $st = "1" ]; then
            echo "${CYAN}- Status:${RESET}"
            git status -s
        fi
    fi
done
