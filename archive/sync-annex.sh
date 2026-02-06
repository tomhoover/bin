#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -e -o pipefail

MYHOST=$(uname -n | sed -e 's/\..*//')     # alternative to $(hostname -s), as arch does not install 'hostname' by default

syncContentAll()
{
    echo "     ----- sync content all -----"
    cd "$1" && echo ""
    git annex sync --jobs=9 --content --all
    echo ""
}

syncContent()
{
    echo "     ----- sync content -----"
    cd "$1" && echo ""
    git annex sync --jobs=9 --content
    echo ""
}

saveConfig()
{
    echo "***** save config $1 *****"
    cd "$1" && echo ""
    if contains "$1" "/RAID10/" ; then
        SUFFIX="RAID10"
    else
        SUFFIX="${MYHOST}"
    fi
    cp .git/config ".gitconfig_$SUFFIX"
    if [ "${MYHOST}" = "ariel" ]; then
        git annex add ".gitconfig_$SUFFIX"
    fi
    echo ""
}

contains()
{
    string="$1"
    substring="$2"
    if test "${string#*"$substring"}" != "$string"
    then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}

expireAnnex()
{
    echo "     ----- expire status $1 -----"
    cd "$1" && echo ""
    git annex expire 30d --no-act
    echo ""
}

remoteList()
{
    echo "     ----- remote list $1 -----"
    cd "$1" && echo ""
    grep "^\[remote " .git/config
    echo ""
}

syncAnnex()
{
    echo "***** sync $1 *****"
    cd "$1" && echo ""
    git annex sync --jobs=9
    echo ""
}

fsckAnnex()
{
    echo ""
    START=$(cat /tmp/sync-annex-start)
    #END=$((START+21600))                # 6 hrs
    END=$((START+14400))                # 4 hrs
    NOW=$(date +%s)

    if [ "$NOW" -gt "$END" ] ; then return ; fi

    args=(. --incremental-schedule 28d --time-limit 3h --jobs=9)

    if [ "$2" = "amazon" ] ; then args+=(--from=amazon) ; fi
    if [ "$2" = "drobo" ] ; then args+=(--from=drobo) ; fi
    if [ "$2" = "gdrive" ] ; then args+=(--from=gdrive) ; fi
    if [ "$2" = "hubic" ] ; then args+=(--from=hubic) ; fi
    if [ "$2" = "ironkey" ] ; then args+=(--from=ironkey) ; fi
    if [ "$2" = "manuel" ] ; then args+=(--from=manuel) ; fi
    if [ "$2" = "origin" ] ; then args+=(--from=origin) ; fi

    if [ "$3" = "fast" ] ; then args+=(--fast) ; fi

    echo "     ----- fsck for $1 [$2] $3          -- started: $(date) -----"
    cd "$1" && echo ""
    git annex fsck "${args[@]}" && git annex sync --jobs=9 >/dev/null
    echo ""
    echo "     ----- fsck for $1 [$2] $3          -- ended: $(date) -----"
    echo ""
}

fsckRemotes()
{
    echo ""
    cd "$1" && for DIR in */
    do
        syncAnnex "$1/$DIR"
        cd "$1/$DIR" || exit
        if git remote | grep -q "$2" ; then
            fsckAnnex "$1/$DIR" "$2" "$3"
        else
            continue
        fi
    done
}

listAnnex()
{
    echo ""
    cd "$1" && for DIR in */
    do
        if [ "$2" = "config" ] || [ "$2" = "configs" ] ; then
            saveConfig "$1/$DIR"
        else
            syncAnnex "$1/$DIR"
            if [ "$2" = "content" ] ; then
                syncContent "$1/$DIR"
            elif [ "$2" = "all" ] ; then
                syncContentAll "$1/$DIR"
            elif [ "$2" = "fsck" ] ; then
                fsckAnnex "$1/$DIR"
            fi
            expireAnnex "$1/$DIR"
            #remoteList "$1/$DIR"
        fi
    done
}

if [ "${MYHOST}" = "ariel" ]; then
    # shellcheck source=/dev/null
    [ -r "$HOME"/.keychain/"$(uname -n)"-sh ] && . "$HOME"/.keychain/"$(uname -n)"-sh
fi

echo "PATH = $PATH"

date +%s > /tmp/sync-annex-start

if [ "$1" = "fsck" ] && [ "$2" = "ironkey" ] ; then
    fsckRemotes /Volumes/RAID10/annex ironkey "$3"
elif [ "$1" = "fsck" ] && [ "$2" = "remotes" ] ; then
    if [ "${MYHOST}" = "ariel" ]; then
        fsckRemotes /Volumes/RAID10/annex drobo "$3"
        fsckRemotes /Volumes/RAID10/annex manuel "$3"
        #fsckRemotes /Volumes/RAID10/annex origin "$3"
        #fsckRemotes ~/annex drobo "$3"
        #fsckRemotes ~/annex manuel "$3"
        #fsckRemotes ~/annex origin "$3"
    elif [ "${MYHOST}" = "unraid" ]; then
#        fsckRemotes ~/annex amazon "$3"
        fsckRemotes ~/annex gdrive "$3"
        fsckRemotes ~/annex hubic "$3"
    fi
elif [ "$1" = "fsck" ] && [ "$2" = "all" ] ; then
    if [ "${MYHOST}" = "ariel" ]; then
        listAnnex /Volumes/RAID10/annex "$1"
        listAnnex ~/annex "$1"
        fsckRemotes /Volumes/RAID10/annex drobo "$3"
        fsckRemotes /Volumes/RAID10/annex manuel "$3"
        #fsckRemotes /Volumes/RAID10/annex origin "$3"
        #fsckRemotes ~/annex drobo "$3"
        #fsckRemotes ~/annex manuel "$3"
        #fsckRemotes ~/annex origin "$3"
    elif [ "${MYHOST}" = "unraid" ]; then
        listAnnex ~/annex "$1"
#        fsckRemotes ~/annex amazon "$3"
        fsckRemotes ~/annex gdrive "$3"
        fsckRemotes ~/annex hubic "$3"
    fi
else
    if [ "${MYHOST}" = "ariel" ] ; then listAnnex /Volumes/RAID10/annex "$1" ; fi
    listAnnex ~/annex "$1"
fi
