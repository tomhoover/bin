#!/usr/bin/env bash
# shellcheck disable=SC2028

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

cd && 2>/dev/null time find . \( -path './Library' -o -path './OrbStack' -o -path './data' -o -path './dl' -o -path './doc' -o -path './src.orig' -o -path './tmp' \) -prune \
    -o -type d -name '.git' | \
    grep -v '^./.ansible/roles/trfore.omada_install/' | \
    grep -v '^./.cache/AUR/' | \
    grep -v '^./.cache/cookiecutters/' | \
    grep -v '^./.cache/pre-commit/' | \
    grep -v '^./.config/tmux/plugins/' | \
    grep -v '^./.local/share/nvim/lazy/' | \
    grep -v '^./.vim/plugged/' | \
    grep -v '^./Library$' | \
    grep -v '^./OrbStack$' | \
    grep -v '^./data$' | \
    grep -v '^./dl$' | \
    grep -v '^./doc$' | \
    grep -v '^./src.orig$' | \
    grep -v '^./src/AUR/' | \
    grep -v '^./tmp$' | \
    sed -e 's|^./|~/|' -e 's|/.git$|/|' -e 's| |\\ |g' -e 's|&|\\&|g' -e 's|(|\\(|g' -e 's|)|\\)|g'| sort > ~/tmp/all-git-repos.txt
