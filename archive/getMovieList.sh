#!/usr/bin/env sh

if [ "$(hostname -s)" = "unraid" ]; then

    FILE=$HOME/Dropbox/MovieList.txt
    MOVIEDIR="/mnt/user/Plex/Movies"

    cd "$MOVIEDIR" || exit

    {   echo "Amazon Prime" ; echo "============" ; find . -iname '*.amzn' | sed -e 's/.amzn$//' -e 's/__/: /' -e 's/^\.\///' ; echo "" ; \
        echo "Apple TV" ;     echo "========" ;     find . -iname '*.atv' | sed -e 's/.atv$//' -e 's/__/: /' -e 's/^\.\///' ;   echo "" ; \
        echo "Movies Anywhere" ;     echo "==============" ;     find . -iname '*.many' | sed -e 's/.many$//' -e 's/__/: /' -e 's/^\.\///' ;   echo "" ; \
        echo "VUDU" ;         echo "====" ;         find . -iname '*.vudu' | sed -e 's/.vudu$//' -e 's/__/: /' -e 's/^\.\///' ; echo "" ; } > "$FILE"

    # shellcheck disable=SC2129
    { echo "Plex"; echo "===="; } >> "$FILE"

    find .  \( ! -regex '.*/\..*' \) \
        | grep -v ^$ | grep -v ^\.$ | grep -v \.amzn$ | grep -v \.atv$ | grep -v \.many$ | grep -v \.vudu$ | grep -v \.edl$ | grep -v \.log$ | grep -v \.txt$ \
        | sed -e 's/.rsls$//' -e 's/.rslsv$//' -e 's/.plex$//' -e 's/.m4v$//' -e 's/.mp4$//' -e 's/.mpg$//' -e 's/.mpeg$//' -e 's/.mkv//' -e 's/__/: /' -e 's/_ /: /' -e 's/^\.\///' \
              -e 's/^0-TV$//' -e 's/^1-comskip$//' -e 's/^1-retired$//' -e 's/^2edit$//' -e 's/^2encode$//' \
              -e 's/0-TV\/\(.*\)/\1 [0-TV]/' \
              -e 's/1-comskip\/\(.*\)/\1 [1-comskip]/' \
              -e 's/2edit\/\(.*\)/\1 [2edit]/' \
        | sort -u >> "$FILE"

    echo "" >> "$FILE"

fi

if [ "$(hostname -s)" = "ariel" ]; then

    scp root@unraid:Dropbox/MovieList.txt "$HOME"/Dropbox/txt/nvALT

    FILE=$HOME/Dropbox/txt/nvALT/MovieList.txt
    DBFILE=$HOME/Dropbox/Public/MovieList.txt
    cp "$FILE" "$DBFILE"

    cd "/Volumes/RAID10/cTivo/Movies" && \
        { echo "in work: /Volumes/RAID10/z_Media/cTivo/Movies" ; echo "=============================================" ; find . | grep -v ^\.$ | sed -e 's/^\.\///' 2>/dev/null ; echo "" ; } >> "$FILE"

    cd "/Volumes/RAID10/Media/z_Media/Batch Rip/Batch Rip Movies" && \
        { echo "in work: /Volumes/RAID10/z_Media/Batch Rip/Batch Rip Movies" ; echo "===========================================================" ; find . | grep -v ^\.$ | grep -v .DS_Store | grep -v .placeholder | sed -e 's/^\.\///' 2>/dev/null ; echo "" ; } >> "$FILE"

fi
