#!/bin/sh

# Exit immediately on error.
set -e

SOURCE="$HOME/src/tomhoover-hugo"
FILENAME=$(echo "$*" | tr -d "[:punct:]" | tr "[:blank:]" "-" | tr "[:upper:]" "[:lower:]")
case "${FILENAME}" in
    *\.md ) ;;
    * ) FILENAME="${FILENAME}.md" ;;
esac
if [ -f "${SOURCE}/content/post/${FILENAME}" ]; then
    vim "${SOURCE}/content/post/${FILENAME}"
else
    cd "${SOURCE}" && hugo new "post/${FILENAME}" --editor vim
fi
