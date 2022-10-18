#!/bin/bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
# set -eu -o pipefail
set -u -o pipefail

. $HOME/.keychain/$(hostname)-sh

echo ""

cd /Users && /opt/homebrew/bin/rsync -avzh --delete --delete-excluded \
    --exclude=".DS_Store" \
    --exclude=".TemporaryItems" \
    --exclude=".Trashes" \
    --exclude=".fseventsd" \
    --exclude="/.SynologyDrive/" \
    --exclude="/.Trash/" \
    --exclude="/.config-backup/" \
    --exclude="/.config-backup2/" \
    --exclude="/.config/op/op-daemon.sock" \
    --exclude="/.dbfseventsd" \
    --exclude="/.dropbox/" \
    --exclude="/.duplicacy/cache/" \
    --exclude="/.duplicacy2/cache/" \
    --exclude="/.gnupg/S.dirmngr" \
    --exclude="/Arq" \
    --exclude="/Library/Application Support/iTerm2/iterm2-daemon-1.socket" \
    --exclude="/Library/Arq/Cache.noindex/" \
    --exclude="/Library/Caches/" \
    --exclude="/Library/CloudStorage/OneDrive-Personal/" \
    --exclude="/Library/Containers/com.apple.Safari/Data/Library/Caches/" \
    --exclude="/Library/Containers/com.apple.mail/Data/DataVaults/" \
    --exclude="/Library/Group Containers/" \
    --exclude="/Library/Logs/" \
    --exclude="/Library/Mobile Documents/com~apple~CloudDocs/.Trash/" \
    --exclude="/OneDrive/" \
    --exclude="/data/" \
    tom/ tom@BLUEIRIS:/mnt/e/rsync/$(hostname -s)/tom/ |grep -v '/$'

#     --exclude="/Library/" \
#     --exclude=".cache/darktable" \
#     --exclude=".cache/icedtea-web" \
#     --exclude=".cache/inkscape" \
#     --exclude=".cache/neosnippet" \
#     --exclude=".dbfseventsd" \
#     --exclude="/System/Library/Templates/Data/private/var/db/dslocal/nodes/Default/" \
#     --exclude="/System/Volumes/Data/.DocumentRevisions-V100" \
#     --exclude="/System/Volumes/Data/.dbfseventsd" \
#     --exclude="/System/Volumes/Data/.file" \
#     --exclude="/System/Volumes/Data/Users/tom/.gnupg/S.dirmngr" \

echo ""

echo " ------------------------------"
echo "| bethel_easystore to blueiris |"
echo " ------------------------------"

[[ $(hostname -s) = "bethel" ]] && cd /Volumes && /opt/homebrew/bin/rsync -avzh --delete --delete-excluded \
    --exclude=".DS_Store" \
    --exclude=".dbfseventsd" \
    --exclude=".fseventsd" \
    --exclude=".TemporaryItems" \
    --exclude=".Trashes" \
    --exclude="/Arq" \
    easystore/ tom@BLUEIRIS:/mnt/e/rsync/bethel/easystore/ |grep -v '/$'

echo ""
