# shellcheck shell=sh
cd "$(git rev-parse --path-format=absolute --git-common-dir | sed -e 's|/\.git$||')" || true
