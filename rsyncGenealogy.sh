#!/bin/bash
[[ "`/bin/hostname`" = "ariel" ]] || exit

## Dropbox
# rsync datafile only if my version is newer
cd ~/Documents/Genealogy/ && rsync -avu --delete --delete-excluded RootsMagic/ ../../Dropbox/_Shared/Genealogy/RootsMagic

cat /dev/null > /tmp/rsyncGenealogy
diff -r ~/Documents/Genealogy/RootsMagic ~/Dropbox/_Shared/Genealogy/RootsMagic |grep "/Users/tom/Dropbox" |grep -v .DS_Store >> /tmp/rsyncGenealogy
diff -r ~/Documents/Genealogy/Surnames   ~/Dropbox/_Shared/Genealogy/Surnames   |grep "/Users/tom/Dropbox" |grep -v .DS_Store >> /tmp/rsyncGenealogy
diff -r ~/Documents/Genealogy/Places     ~/Dropbox/_Shared/Genealogy/Places     |grep "/Users/tom/Dropbox" |grep -v .DS_Store >> /tmp/rsyncGenealogy

if [ -s /tmp/rsyncGenealogy ]
then
	cat /tmp/rsyncGenealogy |grep "^diff -r" |sed -e 's/^diff -r //' |tr ' ' '\n' |tee /tmp/red |while read REF
	do
	  #echo "$REF" | tee -a colorCleared.txt
  	  label 2 "$REF"
	done

	# /\'$'\n'/ in the next line required to insert newline into sed substitution expression under BSD
	cat /tmp/rsyncGenealogy |grep "^Binary files " |grep " differ$" |sed -e 's/^Binary files //' -e 's/ differ$//' -e 's/ and /\'$'\n'/ |tee -a /tmp/red |while read REF
	do
  	  label 2 "$REF"
	done

	cat /tmp/rsyncGenealogy |grep "^Only in" | sed -e 's/^Only in //' -e 's/: /\//' | tee /tmp/orange | while read REF
	do
	  label 1 "$REF"
	done
else
	cd ~/Documents/Genealogy/ && rsync -av --delete --delete-excluded --exclude '* alias' Surnames/ ../../Dropbox/_Shared/Genealogy/Surnames
	cd ~/Documents/Genealogy/ && rsync -av --delete --delete-excluded --exclude '* alias' Places/   ../../Dropbox/_Shared/Genealogy/Places
fi
exit

