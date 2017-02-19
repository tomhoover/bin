#!/bin/sh

[ "$(hostname -s)" = unraid  ] || exit

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

set -v
sysctl vm.vfs_cache_pressure=200

find /mnt/disk* ! -empty -type f -links 1 -printf "%s " -exec ls -dQ {} \; >/mnt/disk1/dupes_tmp0
# shellcheck disable=SC1001
grep -v \/\.AppleDouble\/ /mnt/disk1/dupes_tmp0 \
	| grep -v \/\.DS_Store\"$ \
	| grep -v \/\._\.DS_Store\"$ \
	| grep -v \/\.Recycle.Bin\/ \
	| grep -v \/\.TemporaryItems\/ \
	| grep -v \/\.sync\/ \
	| grep -v \.vmwarevm\/ \
	| grep -v \/VIDEO_TS\/ \
	| grep -v \/C300_CTFDDAC128MAG_00000000110703039BAE-part1\/ \
	| grep -v \/Photos\/ \
	| grep -v \/mnt\/disk.\/BitTorrent\ Sync\/bridgett_Bridgett\'s\ Photo\ Library\/ \
	| grep -v \/mnt\/disk.\/BitTorrent\ Sync\/bridgett_pics\ from\ Tom\ to\ Bridgett\/LindaStuff\/ \
	| grep -v \/mnt\/disk.\/BitTorrent\ Sync\/mitzi_Pictures\/Photos\ Library.photoslibrary\/ \
	| grep -v \/mnt\/disk.\/BitTorrent\ Sync\/teh_Documents\/ \
	| grep -v \/mnt\/disk.\/BitTorrent\ Sync\/Vault\/Documents\/Roy\ Dearmore\/ \
	| grep -v \/mnt\/disk.\/CommunityApplicationsAppdataBackup\/ \
	| grep -v \/mnt\/disk.\/Media\ -\ Originals/TV\ Shows/Gilmore\ Girls\/ \
	| grep -v \/mnt\/disk.\/Music\/iTunes\/iTunes\ Media\/Music\/Ronnie\ Dunn\/ \
	| grep -v \/mnt\/disk.\/Photos\/Aperture\ Library.aplibrary\/ \
	| grep -v \/mnt\/disk.\/Photos\/mitzi_Pictures\/Photos\ Library.photoslibrary\/ \
	| grep -v \/mnt\/disk.\/annex \
	| grep -v \/mnt\/disk.\/backups\/SuperDuper\/ \
	| grep -v \/mnt\/disk.\/dupes \
	| grep -v \/mnt\/disk.\/vdisks\/ \
	> /mnt/disk1/dupes_tmp1
#	| grep -v \.BUP\"$ \
#	| grep -v \.IFO\"$ \
#	| grep -v \.VOB\"$ \
#	| grep -v \/btsync\/ \
#	| grep -v \/tmp\/ \
#	| grep -v \/BitTorrent\ Sync\/ \
#	| grep -v \/backups\/ \
#	| grep \/iTunes\/ \

sort -n /mnt/disk1/dupes_tmp1 | awk '{ printf "%015d %s\n", $1, $0}' | cut -d" " -f1,3- |  uniq -D -w 15 | cut -d" " -f2- >/mnt/disk1/dupes_tmp2
sed  "s/'/'\\\''/g" < /mnt/disk1/dupes_tmp2 | xargs -n 1 -I FiLeNaMeX sh -c "dd if='FiLeNaMeX' count=1 ibs=4M 2>/dev/null | md5sum -| tr -d '\n'; echo 'FiLeNaMeX'" >/mnt/disk1/dupes_tmp3
sort /mnt/disk1/dupes_tmp3 | uniq -w32 --all-repeated| cut -c36- | sed -e 's/"/\\\"/g' -e 's/\(.*\)/"\1"/' >/mnt/disk1/dupes_tmp4
xargs md5sum < /mnt/disk1/dupes_tmp4 >/mnt/disk1/dupes_tmp5
sort /mnt/disk1/dupes_tmp5 | uniq -w32 -d --all-repeated=separate | cut -c35- >/mnt/disk1/dupes_out.txt
