#!/bin/sh

# Exit immediately on error.
set -e

SOURCE="$HOME/src/tomhoover-hugo"
FILENAME=`echo "$*" | tr "[:blank:]" "-" | tr "[:upper:]" "[:lower:]"`
case "${FILENAME}" in
    *\.md ) ;;
    * ) FILENAME="${FILENAME}.md" ;;
esac
if [ -f "${SOURCE}/content/page/${FILENAME}" ]; then
    vim "${SOURCE}/content/page/${FILENAME}"
else
    cd "${SOURCE}" && hugo new "page/${FILENAME}" --editor vim
fi
