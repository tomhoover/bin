#!/usr/bin/env bash
# shellcheck disable=SC2028

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

cd && find . \( -path './.Trash' -o -path './.config-backup' -o -path './.config-backup2' -o -path './Library/CloudStorage/OneDrive-Personal/.Trash' -o -path './Library/Containers' -o -path './Library/Preferences/fyne' -o -path './data' \) -prune \
    -o -type d -name '.git' | \
    grep -v '^./.Trash' | \
    grep -v '^./.asdf/plugins' | \
    grep -v '^./.asdf/repository' | \
    grep -v '^./.cache/pre-commit' | \
    grep -v '^./.config-backup' | \
    grep -v '^./.config-backup2' | \
    grep -v '^./.config/tmux/plugins' | \
    grep -v '^./.pyenv.old2' | \
    grep -v '^./.pyenv.old2/plugins' | \
    grep -v '^./.pyenv.old2/plugins' | \
    grep -v '^./.pyenv/plugins' | \
    grep -v '^./.tmux.old/plugins' | \
    grep -v '^./.tmux.tch/plugins' | \
    grep -v '^./.tmux/plugins/tpm' | \
    grep -v '^./.vim/plugged' | \
    grep -v '^./Library/Containers' | \
    grep -v '^./Library/Preferences/fyne' | \
    grep -v '^./Library/Preferences/fyne' | \
    grep -v '^./data' | \
    grep -v '^./pkg/mod/cache/download/git.apache.org/thrift.git' | \
    grep -v '^./test' | \
    grep -v '^./tmp' | \
    sed -e 's|^./|~/|' -e 's|/.git$||' -e 's| |\\ |g' | sort > ~/tmp/all-git-repos.txt
