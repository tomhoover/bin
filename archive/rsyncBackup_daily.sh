#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

# shellcheck source=/dev/null
[ -r "$HOME"/.keychain/"$(uname -n)"-sh ] && . "$HOME"/.keychain/"$(uname -n)"-sh

echo " ---------------"
echo "| tom_Documents |"
echo " ---------------"
cd /Users/tom && rsync -avzh --delete Documents/ tom@bethel:/mnt/rsync/tom_Documents/
echo ""
echo " ---------------"
echo "| tom_Downloads |"
echo " ---------------"
cd /Users/tom && rsync -avzh --delete Downloads/ tom@bethel:/mnt/rsync/tom_Downloads/
echo ""
echo " -----------"
echo "| tom_Music |"
echo " -----------"
cd /Users/tom && rsync -avzh --delete Music/ tom@bethel:/mnt/rsync/tom_Music/
echo ""
echo " --------------"
echo "| tom_Pictures |"
echo " --------------"
cd /Users/tom && rsync -avzh --delete Pictures/ tom@bethel:/mnt/rsync/tom_Pictures/
echo ""
echo " -------"
echo "| tom_b |"
echo " -------"
cd /Volumes && rsync -avzh --delete \
				--exclude=.DocumentRevisions-V100 --exclude=.MobileBackups --exclude=.Trashes --exclude=.Spotlight-V100 \
				b/ tom@bethel:/mnt/rsync/tom_b/

exit 0
echo ""
echo " --------------"
echo "| RAID_Archive |"
echo " --------------"
cd /Volumes/RAID10 && rsync -avzh --delete Archive/ tom@bethel:/mnt/rsync/RAID10_Archive/
echo ""
echo " ----------------"
echo "| RAID_Downloads |"
echo " ----------------"
cd /Volumes/RAID10 && rsync -avzh --delete Downloads/ tom@bethel:/mnt/rsync/RAID10_Downloads/
echo ""
echo " ------------"
echo "| RAID_Music |"
echo " ------------"
cd /Volumes/RAID10 && rsync -avzh --delete Music/ tom@bethel:/mnt/rsync/RAID10_Music/
echo ""
echo " ---------------"
echo "| RAID_Pictures |"
echo " ---------------"
cd /Volumes/RAID10 && rsync -avzh --delete Pictures/ tom@bethel:/mnt/rsync/RAID10_Pictures/
echo ""
echo " --------------"
echo "| RAID_backups |"
echo " --------------"
cd /Volumes/RAID10 && rsync -avzh --delete backups/ tom@bethel:/mnt/rsync/RAID10_backups/
