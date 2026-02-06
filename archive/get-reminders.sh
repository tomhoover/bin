#!/usr/bin/env bash

cd ~/Dropbox/txt/nvALT || exit

FILE=$(grep -l "^;; " ./*.txt | head -1)

until [[ "$FILE" == "" ]]
do
   TASK=$(grep "^;; " "$FILE" | head -1 | sed -e 's/;; //')
   automator -i "$TASK" ~/bin/reminders.workflow
   sed -i "" -e '1s/^;; /:: /;t' -e '1,/^;; /s//:: /' "$FILE"

   FILE=$(grep -l "^;; " ./*.txt | head -1)
done
