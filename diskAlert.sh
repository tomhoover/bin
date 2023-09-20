#!/usr/bin/env sh

df -H | grep -vE '^Filesystem|none|cdrom| /mnt' | awk '{ print $5 " " $1 }' | while read -r output;
do
  echo "$output"
  usep=$(echo "$output" | awk '{ print $1 }' | cut -d'%' -f1 )
  partition=$(echo "$output" | awk '{ print $2 }' )
  if [ "$usep" -ge 90 ]; then
    echo "Running out of space \"$partition ($usep%)\" on $(uname -n) as on $(date)" |
     mail -s "Alert: Almost out of disk space $usep%" tom@hisword.net
  fi
done
