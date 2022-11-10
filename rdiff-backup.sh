#!/usr/bin/env bash
# shellcheck disable=SC2016

pgrep -fq '^ssh -C .* rdiff-backup --server' && echo "An rdiff-backup process is already running." && exit 0

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
# set -eu -o pipefail
set -u -o pipefail

# shellcheck source=/dev/null
. "$HOME"/.keychain/"$(hostname)"-sh

echo ""
echo "***** rdiff-backup /Users/tom to blueiris_external *****"
rdiff-backup -v5 --print-statistics \
    --exclude='**/$RECYCLE.BIN' --exclude='**/$Recycle.Bin' --exclude='**/.AppleDB' --exclude='**/.AppleDesktop' \
    --exclude='**/.AppleDouble' --exclude='**/.com.apple.timemachine.supported' --exclude='**/.dbfseventsd' \
    --exclude='**/.DocumentRevisions-V100*' --exclude='**/.DS_Store' --exclude='**/.fseventsd' \
    --exclude='**/.PKInstallSandboxManager' --exclude='**/.Spotlight*' --exclude='**/.SymAV*' --exclude='**/.symSchedScanLockxz' \
    --exclude='**/.TemporaryItems' --exclude='**/.Trash*' --exclude='**/.vol' --exclude='**/.VolumeIcon.icns' \
    --exclude='**/Desktop DB' --exclude='**/Desktop DF' --exclude='**/hiberfil.sys' --exclude='**/lost+found' \
    --exclude='**/Network Trash Folder' --exclude='**/pagefile.sys' --exclude='**/Recycled' --exclude='**/RECYCLER' \
    --exclude='**/System Volume Information' --exclude='**/Temporary Items' --exclude='**/Thumbs.db' \
    --exclude="**/.SynologyDrive" \
    --exclude="**/.cache" \
    --exclude="**/.config-backup" \
    --exclude="**/.config-backup2" \
    --exclude="**/.config/op/op-daemon.sock" \
    --exclude="**/.dropbox" \
    --exclude="**/.duplicacy/cache" \
    --exclude="**/.duplicacy2/cache" \
    --exclude="**/.gnupg/S.dirmngr" \
    --exclude="**/.pyenv/versions" \
    --exclude="**/.sync/Archive" \
    --exclude="**/Backup" \
    --exclude="**/Drive/Backup" \
    --exclude="**/Downloads" \
    --exclude="**/Library" \
    --exclude="**/OneDrive" \
    --exclude="**/Resilio Sync" \
    --exclude="**/data" \
    --exclude="**/gpg.git" \
    --exclude="**/ha" \
    --exclude="**/ibto" \
    --exclude="**/logs" \
    --exclude="**/pkg" \
    --exclude="**/private" \
    --exclude="**/src" \
    --exclude="**/tmp" \
    --exclude="**/tmux-config" \
    /Users/tom tom@BLUEIRIS::/mnt/e/rdiff-backup/"$(hostname -s)"/tom

echo ""
echo "***** remove rdiff-backups older than 1 year *****"

# rdiff-backup -–force -–remove-older-than 15W /backup/
rdiff-backup --remove-older-than 1Y tom@BLUEIRIS::/mnt/e/rdiff-backup/"$(hostname -s)"/tom

echo ""
