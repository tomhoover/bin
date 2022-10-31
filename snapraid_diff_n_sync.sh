#! /bin/bash
#######################################################################
# this is a helper script that keeps SnapRAID parity info in sync with
# your data. Here's how it works:
#   1) it first calls diff to figure out if the parity info is out of sync
#   2) if there are changed files (i.e. new, changed, moved or removed),
#         it then checks how many files were removed.
#   3) if the deleted files exceed X (configurable), it triggers an
#         alert email and stops. (in case of accidental deletions)
#   4) otherwise, it will call sync.
#   5) when sync finishes, it sends an email with the output to user.
#
# $Author: sidney $
# $Revision: 5 $
# $Date: 2011-10-16 09:28:44 +1100 (Sun, 16 Oct 2011) $
# $HeadURL: file:///svnrepo/linuxScripts/snapraid_diff_n_sync.sh $
#
# Modified Zack Reed http://zackreed.me
# Date 2013-11-22
##### Revision 1 #####
# Updated the PARITY_FILE variable to accommodate multiple parity disks
# Updated the change counters to accommodate SnapRAID 5.0 changes.
#######################################################################

##### Revision 2 #####
# Updated the change counters to accommodate SnapRAID 6.0 changes.
#######################################################################

##### Revision 3 #####
# Updated greps to accommodate the keywords like updated being used in a filename from derailing the counter.
#######################################################################

##### Revision 4 #####
# Added ability to run weekly scrubs
#######################################################################

EMAIL_SUBJECT_PREFIX="bethel SnapRAID - "
EMAIL_ADDRESS="tom@hisword.net"
DEL_THRESHOLD=65
CONTENT_FILE="/var/snapraid/content"
PARITY_FILE=`cat /etc/snapraid.conf | grep snapraid.parity | head -n 1 | cut -d " " -f2`
LOG_FILE="/var/log/snapraid.log"
SNAPRAID_BIN="/usr/bin/snapraid"

### Section to support SnapRAID Scrub ###
# Set to true if you want to scrub after a successful sync
RUN_SCRUB="true"
SCRUB_FREQUENCY_IN_DAYS=7

mkdir -p /root/.snapraid/

if [[ -f /root/.snapraid/snapraid_scrub_counter ]]
then
  COUNTER=`cat /root/.snapraid/snapraid_scrub_counter`
else
  echo "1" > /root/.snapraid/snapraid_scrub_counter                
  COUNTER=1
fi
COUNTER=$(($COUNTER+0))
### End Scrub Section ###

## INTERNAL TEMP VARS ##
TMP_OUTPUT="/tmp/snapraid.out"
# redirect all stdout to log file (leave stderr alone though)
exec >> $LOG_FILE
# timestamp the job
echo "[`date`] SnapRAID Job started."
echo "SnapRAID DIFF Job started on `date`" > $TMP_OUTPUT
echo "----------------------------------------" >> $TMP_OUTPUT
#TODO - mount and unmount parity disk on demand!
#sanity check first to make sure we can access the content and parity files
if [ ! -e $CONTENT_FILE ]; then
  echo "[`date`] ERROR - Content file ($CONTENT_FILE) not found!"
  echo "ERROR - Content file ($CONTENT_FILE) not found!" >> $TMP_OUTPUT
  exit 1;
fi
if [ ! -e $PARITY_FILE ]; then
  echo "[`date`] ERROR - Parity file ($PARITY_FILE) not found!"
  echo "ERROR - Parity file ($PARITY_FILE) not found!" >> $TMP_OUTPUT
  exit 1;
fi
# run the snapraid DIFF command
echo "[`date`] Running DIFF Command."
$SNAPRAID_BIN diff >> $TMP_OUTPUT
# wait for the above cmd to finish
wait
echo "----------------------------------------" >> $TMP_OUTPUT
echo "SnapRAID DIFF Job finished on `date`" >> $TMP_OUTPUT
DEL_COUNT=$(grep -w '^ \{1,\}[0-9]* removed$' $TMP_OUTPUT | sed 's/^ *//g' | cut -d ' ' -f1)
ADD_COUNT=$(grep -w '^ \{1,\}[0-9]* added$' $TMP_OUTPUT | sed 's/^ *//g' | cut -d ' ' -f1)
MOVE_COUNT=$(grep -w '^ \{1,\}[0-9]* moved$' $TMP_OUTPUT | sed 's/^ *//g' | cut -d ' ' -f1)
COPY_COUNT=$(grep -w '^ \{1,\}[0-9]* copied$' $TMP_OUTPUT | sed 's/^ *//g' | cut -d ' ' -f1)
UPDATE_COUNT=$(grep -w '^ \{1,\}[0-9]* updated$' $TMP_OUTPUT | sed 's/^ *//g' | cut -d ' ' -f1)
echo "SUMMARY of changes - Added [$ADD_COUNT] - Deleted [$DEL_COUNT] - Moved [$MOVE_COUNT] - Copied [$COPY_COUNT] - Updated [$UPDATE_COUNT]" >> $TMP_OUTPUT
# check if files have changed
if [ $DEL_COUNT -gt 0 -o $ADD_COUNT -gt 0 -o $MOVE_COUNT -gt 0 -o $UPDATE_COUNT -gt 0 ]; then
    # YES, check if number of deleted files exceed DEL_THRESHOLD
    if [ $DEL_COUNT -gt $DEL_THRESHOLD ]; then
        # YES, lets inform user and not proceed with the sync just in case
        echo "Number of deleted files ($DEL_COUNT) exceeded threshold ($DEL_THRESHOLD). NOT proceeding with sync job. Please run sync manually if this is not an error condition." >> $TMP_OUTPUT
    /usr/bin/mutt -s "$EMAIL_SUBJECT_PREFIX WARNING - Number of deleted files ($DEL_COUNT) exceeded threshold ($DEL_THRESHOLD)" -a $TMP_OUTPUT -- "$EMAIL_ADDRESS"
    echo "WARNING - Deleted files ($DEL_COUNT) exceeded threshold ($DEL_THRESHOLD). Check $TMP_OUTPUT for details. NOT proceeding with sync job."
    else
        # NO, delete threshold not reached, lets run the sync job
        echo "Deleted files ($DEL_COUNT) did not exceed threshold ($DEL_THRESHOLD), proceeding with sync job." >> $TMP_OUTPUT
        echo "[`date`] Changes detected [A-$ADD_COUNT,D-$DEL_COUNT,M-$MOVE_COUNT,U-$UPDATE_COUNT] and deleted files ($DEL_COUNT) is below threshold ($DEL_THRESHOLD). Running SYNC Command."
        echo "SnapRAID SYNC Job started on `date`" >> $TMP_OUTPUT
        echo "----------------------------------------" >> $TMP_OUTPUT
        $SNAPRAID_BIN sync >> $TMP_OUTPUT
        #wait for the job to finish
        wait
        echo "----------------------------------------" >> $TMP_OUTPUT
        echo "SnapRAID SYNC Job finished on `date`" >> $TMP_OUTPUT

        # cleanup email body
        egrep -v ^[[:digit:]]+ $TMP_OUTPUT | /usr/bin/mutt -s "$EMAIL_SUBJECT_PREFIX Sync Job COMPLETED" -a $TMP_OUTPUT -- "$EMAIL_ADDRESS"

        # Run Scrub
        if [ $RUN_SCRUB = "true" ]; then
            if [ $COUNTER -lt $SCRUB_FREQUENCY_IN_DAYS ]; then
               echo "[`date`] Cycle count not met.  No scrub was run."
               COUNTER=$[$COUNTER + 1]
               echo "$COUNTER" > /root/.snapraid/snapraid_scrub_counter
            else
               echo "Running SnapRAID full scrub.  This will take a while" > $TMP_OUTPUT

               echo "SnapRAID SCRUB started on `date`" >> $TMP_OUTPUT
               echo "----------------------------------------" >> $TMP_OUTPUT

               $SNAPRAID_BIN scrub -p 100 -o 0 >> $TMP_OUTPUT

               #wait for the job to finish
               wait
               echo "----------------------------------------" >> $TMP_OUTPUT
               echo "SnapRAID SCRUB finished on `date`" >> $TMP_OUTPUT

               # Reset counter
               echo "1" > /root/.snapraid/snapraid_scrub_counter

               # cleanup email body
               egrep -v ^[[:digit:]]+ $TMP_OUTPUT | /usr/bin/mutt -s "$EMAIL_SUBJECT_PREFIX Full Scrub COMPLETED" -a $TMP_OUTPUT -- "$EMAIL_ADDRESS"

               $SNAPRAID_BIN status > $TMP_OUTPUT
               /usr/bin/mutt -s "$EMAIL_SUBJECT_PREFIX Status" "$EMAIL_ADDRESS" < $TMP_OUTPUT

            fi
        else
               echo "Array scrubbing is not enabled.  If you would like to enable it, please set the RUN_SCRUB option to true."
        fi
    fi
else
    # NO, so lets log it and exit
    echo "[`date`] No change detected. Nothing to do"
fi
echo "[`date`] Job ended."
exit 0;
