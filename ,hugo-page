#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

SOURCE="$HOME/src/tomhoover-hugo"
FILENAME=$(echo "$*" | tr -d "[:punct:]" | tr "[:blank:]" "-" | tr "[:upper:]" "[:lower:]")
case "${FILENAME}" in
    *\.md ) ;;
    * ) FILENAME="${FILENAME}.md" ;;
esac
if [ -f "${SOURCE}/content/page/${FILENAME}" ]; then
    vim "${SOURCE}/content/page/${FILENAME}"
else
    cd "${SOURCE}" && hugo new "page/${FILENAME}" --editor vim
fi
