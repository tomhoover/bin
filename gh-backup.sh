#!/bin/bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
# set -eu -o pipefail
set -u -o pipefail

# . $HOME/.keychain/$(hostname)-sh
[[ -f ${HOME}/.SECRETS ]] && . ${HOME}/.SECRETS

cd $HOME/data/software/gh-backup || exit

DATETIME=$(date "+%Y%m%d-%H%M%S")
mv gh-backup.txt "$DATETIME--gh-backup.txt"

echo " ---------------------"
echo "| get tomhoover repos |"
echo " ---------------------"

pages=$(curl -Iu tomhoover:$GH_BACKUP_GITHUB_API_TOKEN https://api.github.com/users/tomhoover/repos | sed -nr 's/^[Ll]ink:.*page=([0-9]+).*/\1/p')

for page in $(seq 1 $pages); do
    curl -u tomhoover:$GH_BACKUP_GITHUB_API_TOKEN "https://api.github.com/users/tomhoover/repos?page=$page" | jq -r '.[].html_url' |
    while read rp; do
      # git clone $rp
      echo "$rp" | sed 's|^.*github.com/||' >> gh-backup.txt
    done
done

# echo "----------" >> gh-backup.txt

echo " -------------------"
echo "| get starred repos |"
echo " -------------------"

pages=$(curl -Iu tomhoover:$GH_BACKUP_GITHUB_API_TOKEN https://api.github.com/users/tomhoover/starred | sed -nr 's/^[Ll]ink:.*page=([0-9]+).*/\1/p')

for page in $(seq 1 $pages); do
    curl -u tomhoover:$GH_BACKUP_GITHUB_API_TOKEN "https://api.github.com/users/tomhoover/starred?page=$page" | jq -r '.[].html_url' |
    while read rp; do
      echo "$rp" | sed 's|^.*github.com/|starred/|' | \
          grep -v 'youtube-dl2/youtube-dl' | \
          grep -v 'voisine/breadwallet-ios' | \
          grep -v 'infochimps-away/infochimps.github.com' \
          >> gh-backup.txt
    done
done

# cd /Users/tom/data/software/gh-backup/starred && for i in */*; do mr -c .mrconfig register $i; done && mr up
# cd /Users/tom/data/software/gh-backup/tomhoover && for i in *; do mr -c .mrconfig register $i; done && mr up
