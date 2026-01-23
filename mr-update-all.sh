#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

mrpull() {
    mr --jobs 1 up
}

mrpush() {
    mr --jobs 1 push
}

mrpullv() {
    mr --verbose --jobs 1 up
}

mrpushv() {
    mr --verbose --jobs 1 push
}

vcsh crontab pull; vcsh dotfiles pull; vcsh git pull; vcsh mr pull; vcsh private pull

if [ $# -eq 0 ]; then
    cd                  && mrpull && mrpush
    cd ~/src            && mrpull && mrpush
    cd ~/src/github.com && mrpull && mrpush
    # cd ~/src/3dPrinting && mrpull && mrpush
else
    cd                  && mrpullv && mrpushv
    cd ~/src            && mrpullv && mrpushv
    cd ~/src/github.com && mrpullv && mrpushv
    # cd ~/src/3dPrinting && mrpullv && mrpushv
fi
