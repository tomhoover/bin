#!/usr/bin/env bash
# shellcheck disable=SC2016

pgrep -fq '^ssh -l tom .* rsync --server' && echo "An rsync process is already running." && exit 0

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
# set -eu -o pipefail
set -u -o pipefail

# shellcheck source=/dev/null
. "$HOME"/.keychain/"$(hostname)"-sh

# dow=$(date +%-a)

echo ""
echo "***** rsync /Users/tom to blueiris_external *****"
cd /Users && /opt/homebrew/bin/rsync -avzh --delete --delete-excluded \
    --exclude='$RECYCLE.BIN' --exclude='$Recycle.Bin' --exclude='.AppleDB' --exclude='.AppleDesktop' \
    --exclude='.AppleDouble' --exclude='.com.apple.timemachine.supported' --exclude='.dbfseventsd' \
    --exclude='.DocumentRevisions-V100*' --exclude='.DS_Store' --exclude='.fseventsd' \
    --exclude='.PKInstallSandboxManager' --exclude='.Spotlight*' --exclude='.SymAV*' --exclude='.symSchedScanLockxz' \
    --exclude='.TemporaryItems' --exclude='.Trash*' --exclude='.vol' --exclude='.VolumeIcon.icns' \
    --exclude='Desktop DB' --exclude='Desktop DF' --exclude='hiberfil.sys' --exclude='lost+found' \
    --exclude='Network Trash Folder' --exclude='pagefile.sys' --exclude='Recycled' --exclude='RECYCLER' \
    --exclude='System Volume Information' --exclude='Temporary Items' --exclude='Thumbs.db' \
    --exclude=".git" \
    --exclude=".sync/Archive" \
    --exclude="/.SynologyDrive/" \
    --exclude="/.cache" \
    --exclude="/.config-backup/" \
    --exclude="/.config-backup2/" \
    --exclude="/.config/op/op-daemon.sock" \
    --exclude="/.config/vcsh/repo.d/" \
    --exclude="/.dropbox/" \
    --exclude="/.duplicacy/cache/" \
    --exclude="/.duplicacy2/cache/" \
    --exclude="/.gnupg/S.dirmngr" \
    --exclude="/.pyenv/versions" \
    --exclude="/Backup" \
    --exclude="/Drive/Backup" \
    --exclude="/Downloads/" \
    --exclude="/Library/" \
    --exclude="/OneDrive" \
    --exclude="/Resilio Sync" \
    --exclude="/data" \
    --exclude="/gpg.git" \
    --exclude="/ha" \
    --exclude="/ibto" \
    --exclude="/logs" \
    --exclude="/pkg" \
    --exclude="/private" \
    --exclude="/src" \
    --exclude="/tmp" \
    --exclude="/tmux-config" \
    tom/ tom@BLUEIRIS:/mnt/e/rsync/"$(hostname -s)"/tom/ |grep -v '/$'

echo ""

echo " ------------------------------"
echo "| bethel_easystore to blueiris |"
echo " ------------------------------"

# [[ $(hostname -s) = "bethel" ]] && [[ $dow = 'Thu' ]] && cd /Volumes && /opt/homebrew/bin/rsync -Pavzh --delete --delete-excluded \
[[ $(hostname -s) = "bethel" ]] && cd /Volumes && /opt/homebrew/bin/rsync -Pavzh --delete --delete-excluded \
    --exclude='$RECYCLE.BIN' --exclude='$Recycle.Bin' --exclude='.AppleDB' --exclude='.AppleDesktop' \
    --exclude='.AppleDouble' --exclude='.com.apple.timemachine.supported' --exclude='.dbfseventsd' \
    --exclude='.DocumentRevisions-V100*' --exclude='.DS_Store' --exclude='.fseventsd' \
    --exclude='.PKInstallSandboxManager' --exclude='.Spotlight*' --exclude='.SymAV*' --exclude='.symSchedScanLockxz' \
    --exclude='.TemporaryItems' --exclude='.Trash*' --exclude='.vol' --exclude='.VolumeIcon.icns' \
    --exclude='Desktop DB' --exclude='Desktop DF' --exclude='hiberfil.sys' --exclude='lost+found' \
    --exclude='Network Trash Folder' --exclude='pagefile.sys' --exclude='Recycled' --exclude='RECYCLER' \
    --exclude='System Volume Information' --exclude='Temporary Items' --exclude='Thumbs.db' \
    --exclude=".git" \
    --exclude="/Arq/" \
    --exclude="/OneDrive/_duplicacy/" \
    --exclude="/OneDrive/Arq Backup Data/" \
    --exclude="/ariel2/rsync.old/System/Applications/" \
    --exclude="/ariel2/rsync.old/System/Developer/" \
    --exclude="/ariel2/rsync.old/System/DriverKit/" \
    --exclude="/ariel2/rsync.old/System/Library/" \
    --exclude="/ariel2/rsync.old/System/iOSSupport/" \
    --exclude="/ariel2/rsync.old/System/Volumes/BaseSystem/" \
    --exclude="/ariel2/rsync.old/System/Volumes/Data/private/var/" \
    --exclude="/ariel2/rsync.old/System/Volumes/Data/private/tmp/" \
    --exclude="/ariel2/rsync.old/System/Volumes/FieldService/" \
    --exclude="/ariel2/rsync.old/System/Volumes/FieldServiceRepair/" \
    --exclude="/ariel2/rsync.old/System/Volumes/Preboot/" \
    --exclude="/ariel2/rsync.old/System/Volumes/Update/" \
    --exclude="/ariel2/rsync.old/System/Volumes/iSCPreboot/" \
    --exclude="/ariel2/rsync.old/System/Volumes/FieldServiceDiagnostic/" \
    --exclude="/ariel2/rsync.old/System/Volumes/Hardware/" \
    --exclude="/ariel2/rsync.old/System/Volumes/Recovery/" \
    --exclude="/ariel2/rsync.old/System/Volumes/VM/" \
    --exclude="/ariel2/rsync.old/System/Volumes/xarts/" \
    --exclude="/tom/Databases/" \
    easystore/ tom@BLUEIRIS:/mnt/e/rsync/bethel/easystore/ |grep -v '/$'

echo ""
