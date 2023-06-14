#!/usr/bin/env bash
# shellcheck disable=SC2016

pgrep -fq '^ssh -C .* rdiff-backup --server' && echo "An rdiff-backup process is already running." && exit 0

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
# set -eu -o pipefail
set -u -o pipefail

# shellcheck source=/dev/null
[ -r "$HOME"/.keychain/"$(uname -n)"-sh ] && . "$HOME"/.keychain/"$(uname -n)"-sh

# verbosity levels:
#  -v0 No information given
#  -v1 Fatal Errors displayed
#  -v2 Warnings
#  -v3 Important notes, and maybe later some global statistics (default)
#  -v4 Some global settings, miscellaneous messages (obsolete)
#  -v5 Mentions which files were changed, and other info
#  -v6 More information on each file processed (obsolete)
#  -v7 More information on various things (obsolete)
#  -v8 Debug, without timestamp
#  -v9 Also debug, but with timestamp

echo ""
echo "***** rdiff-backup \$HOME to zz_rdiff-backups *****"
rdiff-backup --print-statistics --remote-schema 'ssh -C %s /usr/local/bin/rdiff-backup --server' \
    --exclude='**/$RECYCLE.BIN' --exclude='**/$Recycle.Bin' --exclude='**/.AppleDB' --exclude='**/.AppleDesktop' \
    --exclude='**/.AppleDouble' --exclude='**/.com.apple.timemachine.supported' --exclude='**/.dbfseventsd' \
    --exclude='**/.DocumentRevisions-V100*' --exclude='**/.DS_Store' --exclude='**/.fseventsd' \
    --exclude='**/.PKInstallSandboxManager' --exclude='**/.Spotlight*' --exclude='**/.SymAV*' --exclude='**/.symSchedScanLockxz' \
    --exclude='**/.TemporaryItems' --exclude='**/.Trash*' --exclude='**/.vol' --exclude='**/.VolumeIcon.icns' \
    --exclude='**/Desktop DB' --exclude='**/Desktop DF' --exclude='**/hiberfil.sys' --exclude='**/lost+found' \
    --exclude='**/Network Trash Folder' --exclude='**/pagefile.sys' --exclude='**/Recycled' --exclude='**/RECYCLER' \
    --exclude='**/System Volume Information' --exclude='**/Temporary Items' --exclude='**/Thumbs.db' \
    --exclude="**/.sync/Archive" \
    --exclude="**/.SynologyDrive" \
    --exclude="**/.cache" \
    --exclude="**/.config-backup" \
    --exclude="**/.config-backup2" \
    --exclude="**/.config/op/op-daemon.sock" \
    --exclude="**/.config/vcsh/repo.d" \
    --exclude="**/.dropbox" \
    --exclude="**/.duplicacy/cache" \
    --exclude="**/.duplicacy2/cache" \
    --exclude="**/.gnupg/S.dirmngr" \
    --exclude="**/.pyenv/cache" \
    --exclude="**/.pyenv/versions" \
    --exclude="**/.rbenv/cache" \
    --exclude="**/.rbenv/versions" \
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
    --exclude="**/tmp" \
    --exclude="**/tmux-config" \
    /Users/tom tom@SYNOLOGY::/volume1/zz_rdiff-backups/"$(hostname -s)"/tom

# echo ""
# echo "***** rdiff-backup /Users/tom to blueiris_external *****"
# rdiff-backup -v5 --print-statistics \
#     /Users/tom tom@BLUEIRIS::/mnt/e/rdiff-backup/"$(hostname -s)"/tom |grep -v '^Incrementing mirror file'

echo ""
echo "***** remove rdiff-backups older than 1 year *****"

# rdiff-backup -–force -–remove-older-than 15W /backup/
rdiff-backup --remove-older-than 1Y --remote-schema 'ssh -C %s /usr/local/bin/rdiff-backup --server' tom@SYNOLOGY::/volume1/zz_rdiff-backups/"$(hostname -s)"/tom
# rdiff-backup --remove-older-than 1Y tom@BLUEIRIS::/mnt/e/rdiff-backup/"$(hostname -s)"/tom

echo ""
