#!/usr/bin/env bash

for repo in $(vcsh list)
do
    echo ""
    echo "##### $repo":
    vcsh run "$repo" git log --pretty=format: --name-only | sort -u | sed '/^$/d' > ~/vcsh-"$repo"-all-files.txt
    vcsh run "$repo" git ls-tree -r master --name-only > ~/vcsh-"$repo"-files.txt
    diff ~/vcsh-"$repo"-all-files.txt ~/vcsh-"$repo"-files.txt
done
