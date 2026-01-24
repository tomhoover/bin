#!/usr/bin/env bash
# shellcheck disable=SC1078,SC1079,SC2086

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails

if [ "$(pwd)" = "/Users/tom/src/3dPrinting" ] ; then
    echo
    if [ $# -eq 0 ]; then
        find -s . -d 2 -type d | while read -r REPOSITORY; do
            if [[ "${REPOSITORY}" = "./z_"* ]] \
                || [[ "${REPOSITORY}" = "./github.com"* ]] \
                || [ "${REPOSITORY}" = "./cults3d.com/en" ] \
                || [ "${REPOSITORY}" = "./makerworld.com/en" ] \
                || [ "${REPOSITORY}" = "./printables.com/413761-gridfinity-refined" ] \
                || [ "${REPOSITORY}" = "./printables.com/417152-gridfinity-specification" ] \
                || [ "${REPOSITORY}" = "./wiki.qidi3d.com/en" ] \
                || [ "${REPOSITORY}" = "./stl/makita" ] \
            ; then
                continue
            fi
            if compgen -G "${REPOSITORY}/*.zip" > /dev/null; then
                echo "${REPOSITORY}/*.zip file found"
                echo
                unzip -l "${REPOSITORY}/*.zip"
                exit 1
            fi

            GIT_MISSING=""
            if ! [ -d "${REPOSITORY}/.git" ] ; then
                GIT_MISSING="True"
                echo "${REPOSITORY} -- .git missing"
                ls "${REPOSITORY}"
                echo
                echo "  pushd '${REPOSITORY}' && git init && git add -A && git commit -m 'Initial commit' && popd"
                echo
            fi
            if ! [ "${GIT_MISSING}" = "" ] ; then
                continue
            fi

            REMOTE_REPO=$(echo "${REPOSITORY}" | sed -e 's/^\.\///' -e 's/thing://' -e 's/---.*$//' -e 's/[# ,]/-/g' | tr '[:upper:]' '[:lower:]')
            grep -q '\[remote "origin"\]' "${REPOSITORY}/.git/config" || git -C "${REPOSITORY}" remote add origin "gitolite:${REMOTE_REPO}.git"
            grep -q '\[branch "master"\]' "${REPOSITORY}/.git/config" || git -C "${REPOSITORY}" push -u origin master

            if ! [ -z "$(git -C "${REPOSITORY}" status --porcelain)" ]; then
                echo "${REPOSITORY}"
                git -C "$REPOSITORY" status -s
                echo
            fi
        done
    else
        REPO_PATH=$(echo "$1" | sed -e "s/\/[^\/]*$//")
        echo "$REPO_PATH"
        git -C "$REPO_PATH" status -s
    fi
    {
        find -s ./cults3d.com/en/3d-model/tool/ -type dir -d 1 | sed -e '/.\/cults3d.com\/en\/3d-model\/tool\/en/d'
        find -s ./makerworld.com/en/models/ -type dir -d 1 | sed -e '/.\/makerworld.com\/en\/models\/en/d'
        find -s ./printables.com/model/ -type dir -d 1 | sed -e '/.\/printables.com\/model\/413761-gridfinity-refined/d' \
            -e '/.\/printables.com\/model\/417152-gridfinity-specification/d'
        find -s ./thingiverse.com/ -type dir -d 1
        find -s ./vector3d.shop/products/ -type dir -d 1
        echo "./wiki.qidi3d.com/en/Q2/Printable-Components"
        echo
        echo "./printables.com/model/413761-gridfinity-refined"
        echo "./printables.com/model/417152-gridfinity-specification"
    } > urls.sh
    {
        find -s ./cults3d.com/en/3d-model/tool/ -type dir -d 1 | sed -e 's/^./https:\//' \
            -e '/https:\/\/cults3d.com\/en\/3d-model\/tool\/en/d'
        find -s ./makerworld.com/en/models/ -type dir -d 1 | sed -E -e 's/^./https:\//' \
            -e '/https:\/\/makerworld.com\/en\/models\/en/d' \
            -e 's/(.*)---(.*)/\1 ;\2/'
        find -s ./printables.com/model/ -type dir -d 1 | sed -e 's/^./https:\//' \
            -e '/https:\/\/printables.com\/model\/413761-gridfinity-refined/d' \
            -e '/https:\/\/printables.com\/model\/417152-gridfinity-specification/d'
        find -s ./thingiverse.com/ -type dir -d 1 | sed -E -e 's/^./https:\//' \
            -e 's/(.*)---(.*)/\1 ;\2/'
        find -s ./vector3d.shop/products/ -type dir -d 1 | sed -e 's/^./https:\//'
        echo "https://wiki.qidi3d.com/en/Q2/Printable-Components"
        echo
        echo "https://printables.com/model/413761-gridfinity-refined"
        echo "https://printables.com/model/417152-gridfinity-specification"
    } > urls.txt

    echo "vcsh list-untracked OrcaSlicer:"
    vcsh list-untracked OrcaSlicer
    echo
    echo "vcsh list-untracked QIDIStudio:"
    vcsh list-untracked QIDIStudio
    echo
fi
