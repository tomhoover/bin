#!/usr/bin/env sh
# shellcheck disable=all

# SSH-Agent forwarding breaks when screen is re-attached on a different host
# http://www.deadman.org/sshscreen.html
#alias Attach='grabssh ; screen -d -R'
#alias fixssh='source $HOME/bin/fixssh'

SSHVARS="SSH_CLIENT SSH_TTY SSH_AUTH_SOCK SSH_CONNECTION DISPLAY"

for x in ${SSHVARS} ; do
    (eval echo $x=\$$x) | sed  's/=/="/
                                s/$/"/
                                s/^/export /'
done 1>$HOME/bin/fixssh
