#!/usr/bin/env bash

# Downloads all 'new' audiobooks since last run
# Last run date is tracked in "$BOOKS/.last_download"

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -euo pipefail
# set -uo pipefail  # only needed for standalone executation -- not needed for pip install

# shellcheck source=/dev/null
[[ -f ${HOME}/.SECRETS ]] && . "${HOME}"/.SECRETS

BOOKS="/Users/tom/data/books/audible"

cd ${BOOKS} || exit 1

mkdir -p "$BOOKS/dl"

LAST_DL="1900-01-01"
[[ -f .last_download ]] && read -r LAST_DL < .last_download

# audible download --output-dir dl --all --aax-fallback --pdf --cover --chapter --annotation --start-date "$LAST_DL" --no-confirm --overwrite --ignore-errors
audible download --output-dir dl --all --aaxc         --pdf --cover --chapter --annotation --start-date "$LAST_DL" --no-confirm --overwrite --ignore-errors

date -u '+%Y-%m-%dT%H:%M:%SZ' > .last_download

# for asin in B093883QL4
# do
#     echo
#     echo "$asin"
#     audible download --output-dir dl --asin "$asin" --aaxc --pdf --cover --chapter --annotation --no-confirm --overwrite --ignore-errors
# done
# exit

# for title in "The Martian"
# do
#     echo
#     echo "$title"
#     audible download --output-dir dl --title "$title" --aaxc --pdf --cover --chapter --annotation --overwrite --ignore-errors
# done
# exit
