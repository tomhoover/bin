#!/usr/bin/env bash
# shellcheck disable=SC2028

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

# manually check for duplicate entries:
echo ""
echo "*** Already registered with myrepos -- check for duplicate entries:"
read -rsn 1 -p "               (press any key to continue)"
echo ""

cd && echo '' > tmp.mrconfig && /usr/bin/grep '\[' .mrconfig src/.mrconfig src/github.com/.mrconfig .config/mr/* |sed -E 's/^(.*):(.*)/\2 ::: \1/' |sed -E 's/^#(.*)/\1#####/' |grep -v '^ ' |grep -v ^skip |grep -v ^.DEFAULT |sort |less

echo "#!/bin/bash" > ~/register.sh
echo "cd /Users/tom || exit" >> ~/register.sh
echo ""

cd && find . \( -path './.config-backup' -o -path './.config-backup2' -o -path './Library/Containers' -o -path './Library/Preferences/fyne' -o -path './data' \) -prune -o -type d -name '.git' | \
    grep -v '^./.asdf/plugins' | \
    grep -v '^./.asdf/repository' | \
    grep -v '^./.cache/pre-commit' | \
    grep -v '^./.config-backup' | \
    grep -v '^./.config-backup2' | \
    grep -v '^./.config/tmux/plugins' | \
    grep -v '^./.tmux.old/plugins' | \
    grep -v '^./.tmux.tch/plugins' | \
    grep -v '^./.vim/plugged' | \
    grep -v '^./Library/Containers' | \
    grep -v '^./data' | \
    grep -v '^./test' | \
    grep -v '^./tmp' | \
    sed -e 's|^./||' -e 's|/.git$||' | while read -r REPOSITORY; do
    grep -F "${REPOSITORY}]" ~/.mrconfig ~/src/.mrconfig ~/src/github.com/.mrconfig ~/.config/mr/* || echo "mr -c ~/tmp.mrconfig register $REPOSITORY" >> ~/register.sh
done

{
    echo "sed -e '/^\[\$HOME/! s/^\[/[\$HOME\//g' -e 's/^\[/~[/g' tmp.mrconfig |tr '\n' '^' |tr '~' '\n' |sort |tr -s '^' |tr '^' '\n' > tmp2.mrconfig"
    echo "mv tmp2.mrconfig tmp.mrconfig"
    echo "echo ''"
    echo "echo 'finally, edit the following to taste:'"
    # echo 'echo "     vi ~/tmp.mrconfig ~/.mrconfig ~/src/.mrconfig ~/src/github.com/.mrconfig ~/data/software/github.com/.mrconfig ~/.config/mr/*"'
    echo "echo '     vi ~/tmp.mrconfig ~/.mrconfig ~/src/.mrconfig ~/src/github.com/.mrconfig ~/.config/mr/*'"
    echo "echo ''"
    echo "rm -f /Users/tom/register.sh"
} >> ~/register.sh

chmod +x ~/register.sh

echo ""
echo "edit, and then execute, ~/register.sh"
echo ""
