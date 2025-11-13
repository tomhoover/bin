#!/usr/bin/env bash
# shellcheck disable=SC2028

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

cd && time find . \( -path './Library' -o -path './data' -o -path './dl' -o -path './doc' -o -path './tmp' \) -prune \
    -o -type d -name '.git' | \
    grep -v '^./.ansible/roles/trfore.omada_install/' | \
    grep -v '^./.cache/AUR/' | \
    grep -v '^./.cache/cookiecutters/' | \
    grep -v '^./.cache/pre-commit/' | \
    grep -v '^./.config/tmux/plugins/' | \
    grep -v '^./.local/share/nvim/lazy/' | \
    grep -v '^./.vim/plugged/' | \
    grep -v '^./Library$' | \
    grep -v '^./data$' | \
    grep -v '^./dl$' | \
    grep -v '^./doc$' | \
    grep -v '^./src/AUR/' | \
    grep -v '^./tmp$' | \
    sed -e 's|^./|~/|' -e 's|/.git$|/|' -e 's| |\\ |g' -e 's|&|\\&|g' -e 's|(|\\(|g' -e 's|)|\\)|g'| sort > ~/tmp/all-git-repos.txt
