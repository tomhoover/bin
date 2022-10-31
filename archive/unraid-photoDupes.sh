#!/usr/bin/env bash

#[ "$(hostname -s)" = unraid  ] || exit

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

set -v
#sysctl vm.vfs_cache_pressure=200

#find . ! -empty -type f -links 1 -iname '*.jpg' -print0 | xargs -0 exiftool -all= -o - | md5 -r > ./photoDupes.txt
#echo "" > ./photoDupes0.txt
#find . ! -empty -type f -links 1 -iname '*.jpg' -exec zsh -c "exiftool -all= -o - {} | md5 -r | sed -e 's^$^ {}^' >> ./photoDupes0.txt" \;
#find . ! -empty -type f -links 1 -iname '*.jpg' -print0 | xargs -0 -p -L 1 exiftool -all= -o - | md5 -r | sed -e 's^$^ {}^' >> ./photoDupes0.txt
#find . -name "*'*"
find . ! -empty -type f -links 1 \( -iname '*.jpg' -o -iname '*.jpeg' \) > ./photoDupes0.txt
#< ./photoDupes0.txt sed -e 's;^;exiftool -all= -o - ";' -e 's;$;" | md5 -r | {};' >> ./photoDupes1.txt
echo "" > ./photoDupes1.txt
echo "" > ./photoDupes2.txt
#< ./photoDupes0.txt sed -e 's;\(.*\);exiftool -all= -o - "\1" | md5 -r | "\1";' >> ./photoDupes1.txt
#< ./photoDupes0.txt sed -e 's;\(.*\);exiftool -all= -o - "\1" | md5 -r | sed -e s@$@"\1"@;' >> ./photoDupes1.txt
#< ./photoDupes0.txt sed -e 's;\(.*\);exiftool -all= -o - "\1" | md5 -r | awk "{print $0 \1}" ' >> ./photoDupes1.txt
#awk         '{print "exiftool -all= -o - \"" $0 "\" | md5 -r | #" $0 }' ./photoDupes0.txt >> ./photoDupes1.txt
awk -v q=\' '{print "exiftool -all= -o - \"" $0 "\" | md5 -r | sed " q "s;$; \"" $0 "\";" q }' ./photoDupes0.txt >> ./photoDupes1.txt
sh ./photoDupes1.txt > ./photoDupes2.txt
sort ./photoDupes2.txt | guniq -w32 -d --all-repeated=separate > ./photoDupes.txt
# -E in following line enables extended regex, so '+' can be used after [:space:]
< ./photoDupes.txt sed -E -e '/^$/! s/^[^[:space:]]+/#rm/' > ./photoDupes.sh

exit

find . ! -empty -type f -links 1 -iname '*.jpg' > ./dupes_tmp0
xargs md5 -r < ./dupes_tmp0 > ./dupes_tmp1
find . ! -empty -type f -links 1 -iname '*.jpg' -print0 | xargs -0 -I {} exiftool -all= -o - {} | md5 -r > ./photoDupes.txt
#-I {} -L 1
#xargs exiftool -all= -o - < ./dupes_tmp0 | xargs md5 > ./dupes_tmp2
#xargs exiftool -all= -o - | /sbin/md5 -r - < ./dupes_tmp0 > ./dupes_tmp2
exit

#exiftool image.jpg -all= -o - | md5 -
#exiftool -all= -o - | md5 -
#-print0 | xargs -0 md5 -r > ./photoDupes.txt
#find . ! -empty -type f -links 1 -iname '*.jpg' -print0 | xargs -0 md5 -r > ./photoDupes.txt

exit

find . ! -empty -type f -links 1 > ./dupes_tmp0
# shellcheck disable=SC1001
grep .jpg$ ./dupes_tmp0 \
	| grep -v \/\.sync\/ \
	> ./dupes_tmp1
#	| grep -v \/\.DS_Store\"$ \
#	| grep -v \/\._\.DS_Store\"$ \
#	| grep -v \/\.Recycle.Bin\/ \
#	| grep -v \/\.TemporaryItems\/ \
#	| grep -v \.vmwarevm\/ \
#	| grep -v \/VIDEO_TS\/ \
#	| grep -v \/C300_CTFDDAC128MAG_00000000110703039BAE-part1\/ \
#	| grep -v \/Photos\/ \
#	| grep -v \/mnt\/disk.\/BitTorrent\ Sync\/bridgett_Bridgett\'s\ Photo\ Library\/ \
#	| grep -v \/mnt\/disk.\/BitTorrent\ Sync\/bridgett_pics\ from\ Tom\ to\ Bridgett\/LindaStuff\/ \
#	| grep -v \/mnt\/disk.\/BitTorrent\ Sync\/mitzi_Pictures\/Photos\ Library.photoslibrary\/ \
#	| grep -v \/mnt\/disk.\/BitTorrent\ Sync\/teh_Documents\/ \
#	| grep -v \/mnt\/disk.\/BitTorrent\ Sync\/Vault\/Documents\/Roy\ Dearmore\/ \
#	| grep -v \/mnt\/disk.\/CommunityApplicationsAppdataBackup\/ \
#	| grep -v \/mnt\/disk.\/Media\ -\ Originals/TV\ Shows/Gilmore\ Girls\/ \
#	| grep -v \/mnt\/disk.\/Music\/iTunes\/iTunes\ Media\/Music\/Ronnie\ Dunn\/ \
#	| grep -v \/mnt\/disk.\/Photos\/Aperture\ Library.aplibrary\/ \
#	| grep -v \/mnt\/disk.\/Photos\/mitzi_Pictures\/Photos\ Library.photoslibrary\/ \
#	| grep -v \/mnt\/disk.\/annex \
#	| grep -v \/mnt\/disk.\/backups\/SuperDuper\/ \
#	| grep -v \/mnt\/disk.\/dupes \
#	| grep -v \/mnt\/disk.\/vdisks\/ \
#	| grep -v \.BUP\"$ \
#	| grep -v \.IFO\"$ \
#	| grep -v \.VOB\"$ \
#	| grep -v \/btsync\/ \
#	| grep -v \/tmp\/ \
#	| grep -v \/BitTorrent\ Sync\/ \
#	| grep -v \/backups\/ \
#	| grep \/iTunes\/ \

#sort -n /mnt/disk1/dupes_tmp1 | awk '{ printf "%015d %s\n", $1, $0}' | cut -d" " -f1,3- |  uniq -D -w 15 | cut -d" " -f2- >/mnt/disk1/dupes_tmp2
#sed  "s/'/'\\\''/g" < /mnt/disk1/dupes_tmp2 | xargs -n 1 -I FiLeNaMeX sh -c "dd if='FiLeNaMeX' count=1 ibs=4M 2>/dev/null | md5sum -| tr -d '\n'; echo 'FiLeNaMeX'" >/mnt/disk1/dupes_tmp3
#sort /mnt/disk1/dupes_tmp3 | uniq -w32 --all-repeated| cut -c36- | sed -e 's/"/\\\"/g' -e 's/\(.*\)/"\1"/' >/mnt/disk1/dupes_tmp4
#xargs md5sum < /mnt/disk1/dupes_tmp4 >/mnt/disk1/dupes_tmp5
#sort /mnt/disk1/dupes_tmp5 | uniq -w32 -d --all-repeated=separate | cut -c35- >/mnt/disk1/dupes_out.txt
xargs md5 -r < ./dupes_tmp1 > ./dupes_out
