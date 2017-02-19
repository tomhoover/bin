#!/bin/bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

. $HOME/.keychain/$HOSTNAME-sh

echo " ---------------"
echo "| tom_Documents |"
echo " ---------------"
cd /Users/tom && rsync -avzh --delete --rsync-path=/mnt/DroboFS/Shares/DroboApps/rsync/bin/rsync \
				Documents/ tom@nas:/mnt/DroboFS/Shares/rsync/tom_Documents/
echo ""
echo " ---------------"
echo "| tom_Downloads |"
echo " ---------------"
cd /Users/tom && rsync -avzh --delete --rsync-path=/mnt/DroboFS/Shares/DroboApps/rsync/bin/rsync \
				Downloads/ tom@nas:/mnt/DroboFS/Shares/rsync/tom_Downloads/
echo ""
echo " -----------"
echo "| tom_Music |"
echo " -----------"
cd /Users/tom && rsync -avzh --delete --rsync-path=/mnt/DroboFS/Shares/DroboApps/rsync/bin/rsync \
				Music/ tom@nas:/mnt/DroboFS/Shares/rsync/tom_Music/
echo ""
echo " --------------"
echo "| tom_Pictures |"
echo " --------------"
cd /Users/tom && rsync -avzh --delete --rsync-path=/mnt/DroboFS/Shares/DroboApps/rsync/bin/rsync \
				Pictures/ tom@nas:/mnt/DroboFS/Shares/rsync/tom_Pictures/
echo ""
echo " -------"
echo "| tom_b |"
echo " -------"
cd /Volumes && rsync -avzh --delete --rsync-path=/mnt/DroboFS/Shares/DroboApps/rsync/bin/rsync \
				--exclude=.DocumentRevisions-V100 --exclude=.MobileBackups --exclude=.Trashes --exclude=.Spotlight-V100 \
				b/ tom@nas:/mnt/DroboFS/Shares/rsync/tom_b/

echo ""
echo " --------------"
echo "| RAID_Archive |"
echo " --------------"
cd /Volumes/RAID10 && rsync -avzh --delete --rsync-path=/mnt/DroboFS/Shares/DroboApps/rsync/bin/rsync \
				Archive/ tom@nas:/mnt/DroboFS/Shares/rsync/RAID10_Archive/
echo ""
echo " ----------------"
echo "| RAID_Downloads |"
echo " ----------------"
cd /Volumes/RAID10 && rsync -avzh --delete --rsync-path=/mnt/DroboFS/Shares/DroboApps/rsync/bin/rsync \
				Downloads/ tom@nas:/mnt/DroboFS/Shares/rsync/RAID10_Downloads/
echo ""
echo " ------------"
echo "| RAID_Music |"
echo " ------------"
cd /Volumes/RAID10 && rsync -avzh --delete --rsync-path=/mnt/DroboFS/Shares/DroboApps/rsync/bin/rsync \
				Music/ tom@nas:/mnt/DroboFS/Shares/rsync/RAID10_Music/
echo ""
echo " ---------------"
echo "| RAID_Pictures |"
echo " ---------------"
cd /Volumes/RAID10 && rsync -avzh --delete --rsync-path=/mnt/DroboFS/Shares/DroboApps/rsync/bin/rsync \
				Pictures/ tom@nas:/mnt/DroboFS/Shares/rsync/RAID10_Pictures/
echo ""
echo " --------------"
echo "| RAID_backups |"
echo " --------------"
cd /Volumes/RAID10 && rsync -avzh --delete --rsync-path=/mnt/DroboFS/Shares/DroboApps/rsync/bin/rsync \
				backups/ tom@nas:/mnt/DroboFS/Shares/rsync/RAID10_backups/

