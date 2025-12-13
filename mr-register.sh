#!/usr/bin/env bash
# shellcheck disable=SC2028

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

# manually check for duplicate entries:
echo
echo "*** Already registered with myrepos -- check for duplicate entries:"
read -rsn 1 -p "               (press any key to continue)"
clear
echo
echo "Searching for git repos..."

cd && echo '' > ~/tmp/tmp.mrconfig && /usr/bin/grep '^\[' .mrconfig src/.mrconfig src/3dPrinting/.mrconfig src/github.com/.mrconfig .config/mr/* |sed -E 's/^(.*):(.*)/\2 ::: \1/' |sed -E 's/^#(.*)/\1#####/' |grep -v '^ ' |grep -v ^skip |grep -v ^.DEFAULT |sort |less

echo "#!/bin/bash" > ~/tmp/register.sh
echo "cd || exit" >> ~/tmp/register.sh
echo ""

cd && time find . \( -path './Library' -o -path './data' -o -path './dl' -o -path './doc' -o -path './tmp' \) -prune -o -type d -name '.git' | \
    grep -v '^./.ansible/roles/trfore.omada_install/' | \
    grep -v '^./.cache/AUR/' | \
    grep -v '^./.cache/cookiecutters/' | \
    grep -v '^./.cache/pre-commit/' | \
    grep -v '^./.config/tmux/plugins/' | \
    grep -v '^./.local/share/nvim/lazy/' | \
    grep -v '^./.vim/plugged/' | \
    grep -v '^./Library$' | \
    grep -v '^./data$' | \
    grep -v '^./dl$' | \
    grep -v '^./doc$' | \
    grep -v '^./src/AUR/' | \
    grep -v '^./tmp$' | \
    sed -e 's|^./||' -e 's|/.git$||' | while read -r REPOSITORY; do
    grep -F "${REPOSITORY}]" ~/.mrconfig ~/src/.mrconfig ~/src/3dPrinting/.mrconfig ~/src/github.com/.mrconfig ~/.config/mr/* || echo "mr -c ~/tmp/tmp.mrconfig register '${REPOSITORY}'" >> ~/tmp/register.sh
done

{
    echo "sed -e 's/\/home\/tom\///' -e 's/\/Users\/tom\///' -e '/^\[\$HOME/! s/^\[/[\$HOME\//g' -e 's/^\[/~[/g' ~/tmp/tmp.mrconfig |tr '\n' '^' |tr '~' '\n' |sort |tr -s '^' |tr '^' '\n' > ~/tmp/tmp2.mrconfig"
    echo "mv ~/tmp/tmp2.mrconfig ~/tmp/tmp.mrconfig"
    echo "echo ''"
    echo "echo 'finally, edit the following to taste:'"
    echo "echo '     vi ~/tmp/tmp.mrconfig ~/.mrconfig ~/src/.mrconfig ~/src/3dPrinting/.mrconfig ~/src/github.com/.mrconfig ~/.config/mr/*'"
    echo "echo ''"
    echo "rm -f $HOME/tmp/register.sh"
} >> ~/tmp/register.sh

chmod +x ~/tmp/register.sh
~/tmp/register.sh
vi ~/tmp/tmp.mrconfig ~/.mrconfig ~/src/.mrconfig ~/src/3dPrinting/.mrconfig ~/src/github.com/.mrconfig ~/.config/mr/*
