#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

# shellcheck source=/dev/null
source ~/bin/COLORS

git fetch --all --prune --tags

echo "${BLUE}"
git branch -avv | grep -E '^[* ] (main|master) *[a-z0-9]* ' | grep -Ev '\[origin/(main|master)\]' && (echo; echo "${RED}WARNING: (main|master) is tracking a remote other than origin${RESET}"; echo "${CYAN}Consider '${RED}git branch main --set-upstream-to origin/main${RESET}'"; echo '                            -- OR --'; echo "         '${RED}git branch master --set-upstream-to origin/master${RESET}'"; echo; exit 1)

# origin
for branch in $( git branch -r | grep -v 'HEAD ' | grep -Ev '  (gitea|localhost)/' | grep -Ev '  origin/(main|master)$' | grep '  origin/' ); do
    local_branch="${branch#origin/}"
    if ! git show-ref --quiet --verify "refs/heads/$local_branch"; then
        echo -n "${GREEN}"
        git branch --track "$local_branch" "$branch"
    else
        echo "${BLUE}skipped existing branch: $local_branch"
    fi
done

# gitolite
for branch in $( git branch -r | grep -v 'HEAD ' | grep -Ev '  (gitea|localhost)/' | grep -Ev '  origin/(main|master)$' | grep '  gitolite/' ); do
    local_branch="${branch#gitolite/}"
    if ! git show-ref --quiet --verify "refs/heads/$local_branch"; then
        echo -n "${GREEN}"
        git branch --track "$local_branch" "$branch"
    else
        echo "${BLUE}skipped existing branch: $local_branch"
    fi
done

echo "${RED}"
# Remove branches that have already been merged with current branch
git branch --merged | grep -v '\*' | grep -Ev '[/ ]+(dev|main|master)$' | \
    tee /tmp/merged-branches.txt | xargs --no-run-if-empty -n 1 git branch -d && \
    (
        echo "${CYAN}You may remove 'merged' branches from remote repos with:"
        while IFS=/ read -r REMOTE_BRANCH; do
            echo "     ${RED}git push <REMOTE_REPO> --delete ${REMOTE_BRANCH}"
        done < /tmp/merged-branches.txt
        echo
    )

echo -n "${RESET}"
git branch -avv
