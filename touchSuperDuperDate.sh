#!/bin/bash
[[ "`uname`" = "Darwin" ]] || exit

echo "`date '+%Y-%m-%d %H:%M:%S'`" >> "/Users/tom/.lastSuperDuperBackupDate"
