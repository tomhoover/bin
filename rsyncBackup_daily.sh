#!/bin/bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
# set -eu -o pipefail
set -u -o pipefail

. $HOME/.keychain/$(hostname)-sh

dow=$(date +%-a)

echo ""

cd /Users && /opt/homebrew/bin/rsync -avzh --delete --delete-excluded \
    --exclude='$RECYCLE.BIN' --exclude='$Recycle.Bin' --exclude='.AppleDB' --exclude='.AppleDesktop' \
    --exclude='.AppleDouble' --exclude='.com.apple.timemachine.supported' --exclude='.dbfseventsd' \
    --exclude='.DocumentRevisions-V100*' --exclude='.DS_Store' --exclude='.fseventsd' \
    --exclude='.PKInstallSandboxManager' --exclude='.Spotlight*' --exclude='.SymAV*' --exclude='.symSchedScanLockxz' \
    --exclude='.TemporaryItems' --exclude='.Trash*' --exclude='.vol' --exclude='.VolumeIcon.icns' \
    --exclude='Desktop DB' --exclude='Desktop DF' --exclude='hiberfil.sys' --exclude='lost+found' \
    --exclude='Network Trash Folder' --exclude='pagefile.sys' --exclude='Recycled' --exclude='RECYCLER' \
    --exclude='System Volume Information' --exclude='Temporary Items' --exclude='Thumbs.db' \
    --exclude="/.SynologyDrive/" \
    --exclude="/.config-backup/" \
    --exclude="/.config-backup2/" \
    --exclude="/.config/op/op-daemon.sock" \
    --exclude="/.dropbox/" \
    --exclude="/.duplicacy/cache/" \
    --exclude="/.duplicacy2/cache/" \
    --exclude="/.gnupg/S.dirmngr" \
    --exclude="/Arq" \
    --exclude="/Library/Application Support/Adobe/Acrobat/DC/Reader/Synchronizer/Commands" \
    --exclude="/Library/Application Support/Adobe/Acrobat/DC/Reader/Synchronizer/Notification" \
    --exclude="/Library/Application Support/FileProvider/2B7D15E9-4FC7-46AC-B137-40469D621B32/wharf/tombstone/a" \
    --exclude="/Library/Application Support/iTerm2/iterm2-daemon-1.socket" \
    --exclude="/Library/Arq/Cache.noindex/" \
    --exclude="/Library/Caches/" \
    --exclude="/Library/CloudStorage/OneDrive-Personal/" \
    --exclude="/Library/Containers/com.apple.Safari/Data/Library/Caches/" \
    --exclude="/Library/Containers/com.apple.mail/Data/DataVaults/" \
    --exclude="/Library/Developer/Xcode/GPUToolsAgent.sock" \
    --exclude="/Library/Group Containers/" \
    --exclude="/Library/Logs/" \
    --exclude="/OneDrive/" \
    --exclude="/data/" \
    tom/ tom@BLUEIRIS:/mnt/e/rsync/$(hostname -s)/tom/ |grep -v '/$'

echo ""

echo " ------------------------------"
echo "| bethel_easystore to blueiris |"
echo " ------------------------------"

[[ $(hostname -s) = "bethel" ]] && [[ dow = 'Wed' ]] && cd /Volumes && /opt/homebrew/bin/rsync -Pavzh --delete --delete-excluded \
    --exclude='$RECYCLE.BIN' --exclude='$Recycle.Bin' --exclude='.AppleDB' --exclude='.AppleDesktop' \
    --exclude='.AppleDouble' --exclude='.com.apple.timemachine.supported' --exclude='.dbfseventsd' \
    --exclude='.DocumentRevisions-V100*' --exclude='.DS_Store' --exclude='.fseventsd' \
    --exclude='.PKInstallSandboxManager' --exclude='.Spotlight*' --exclude='.SymAV*' --exclude='.symSchedScanLockxz' \
    --exclude='.TemporaryItems' --exclude='.Trash*' --exclude='.vol' --exclude='.VolumeIcon.icns' \
    --exclude='Desktop DB' --exclude='Desktop DF' --exclude='hiberfil.sys' --exclude='lost+found' \
    --exclude='Network Trash Folder' --exclude='pagefile.sys' --exclude='Recycled' --exclude='RECYCLER' \
    --exclude='System Volume Information' --exclude='Temporary Items' --exclude='Thumbs.db' \
    --exclude="/Arq" \
    easystore/ tom@BLUEIRIS:/mnt/e/rsync/bethel/easystore/ |grep -v '/$'

echo ""
