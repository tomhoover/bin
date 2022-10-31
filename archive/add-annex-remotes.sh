#!/usr/bin/env sh
# shellcheck disable=all

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
set -eu

if [ $# -eq 0  ]; then
    echo "No arguments provided"
    exit 1
fi

cd "$1" && pwd
git status -s -uno || exit

echo "===== Adding git-annex remotes ====="
echo "     unraid..."
# shellcheck disable=SC1078
# shellcheck disable=SC1079
# shellcheck disable=SC2027
# shellcheck disable=SC2086
ssh tom@unraid bash -c "'
source .bash_profile
cd annex && mkdir "$1" && cd "$1" && pwd
git init && git annex init unraid
'"
echo "     drobo..."
# shellcheck disable=SC1078
# shellcheck disable=SC1079
# shellcheck disable=SC2027
# shellcheck disable=SC2086
ssh tom@drobo bash -c "'
cd annex && mkdir "$1.git" && cd "$1.git" && pwd
git init --bare && git annex init drobo
'"
echo "     manuel..."
# shellcheck disable=SC1078
# shellcheck disable=SC1079
# shellcheck disable=SC2027
# shellcheck disable=SC2086
ssh tom@manuel bash -c "'
cd annex && mkdir "$1.git" && cd "$1.git" && pwd
git init --bare && git annex init manuel
'"
echo ""
echo "=================================================="
echo ""

echo "===== Adding remotes ====="
echo ""
echo "     to ariel..."
cd "$HOME/annex/$1" && \
    git remote add RAID10 "/Volumes/RAID10/annex/$1" && \
    git remote add unraid "ssh://tom@unraid/~/annex/$1" && \
    git remote add drobo "drobo.local:/mnt/DroboFS/Shares/annex/$1.git" && \
    git remote add manuel "manuel.local:annex/$1.git" && \
    #git remote add origin "manuel.local:annex/$1.git" && \
    git config remote.manuel.annex-ignore true && \
    git config remote.unraid.annex-shell git-annex.linux/git-annex-shell
echo "     to RAID10..."
cd "/Volumes/RAID10/annex/$1" && \
    git remote add ariel "$HOME/annex/$1" && \
    git remote add unraid "ssh://tom@unraid/~/annex/$1" && \
    git remote add drobo "drobo.local:/mnt/DroboFS/Shares/annex/$1.git" && \
    git remote add manuel "manuel.local:annex/$1.git" && \
    #git remote add origin "manuel.local:annex/$1.git" && \
    git config remote.manuel.annex-ignore true && \
    git config remote.unraid.annex-shell git-annex.linux/git-annex-shell
echo ""
echo "=================================================="
echo ""

echo "===== initial git annex sync ====="
echo ""
cd "$HOME/annex/$1" && cat >> .gitattributes <<EOF
* annex.numcopies=2
.DS_Store annex.largefiles=nothing
._* annex.largefiles=nothing
._.DS_Store annex.largefiles=nothing
.gitconfig_* annex.largefiles=nothing
EOF
cd "$HOME/annex/$1" && git add .gitattributes && git commit -m 'initial commit' && git annex sync
echo ""
echo "=================================================="
echo ""

echo "===== Adding special remotes ====="
echo ""
echo "     to ariel..."
cd "$HOME/annex/$1" && git annex initremote amazon type=external externaltype=rclone target=amazon-annex prefix="annex-$1" chunk=50MiB encryption=shared rclone_layout=lower mac=HMACSHA512 && git annex sync
echo "     to RAID10..."
cd "/Volumes/RAID10/annex/$1" && git annex enableremote amazon && git annex sync
echo "     to unraid..."
# shellcheck disable=SC1078
# shellcheck disable=SC1079
# shellcheck disable=SC2086
ssh tom@unraid bash -c "'
source .bash_profile
cd "annex/$1" && git annex enableremote amazon && git annex sync
'"
echo ""
echo "=================================================="
echo ""

echo "===== set wanted files ====="
echo ""
cd "$HOME/annex/$1" && \
    git annex wanted ariel standard && git annex group ariel manual && \
    git annex wanted RAID10 "not (inallgroup=backup and inallgroup=client)" && \
    git annex wanted unraid standard && git annex group unraid backup && \
    git annex wanted amazon standard && git annex group amazon backup && \
    git annex wanted drobo standard && git annex group drobo manual && \
    git annex wanted manuel standard && git annex group manuel manual && \
    #git annex wanted origin standard && git annex group origin manual && \
    git annex sync
echo ""
echo "=================================================="
echo ""

echo "===== git configs ====="
echo ""
cd ~/annex && \
    echo "ariel:"
    cat "$1/.git/config"
    echo "----------"
    echo ""
cd /Volumes/RAID10/annex && \
    echo "RAID10:"
    cat "$1/.git/config"
    echo "----------"
    echo ""
echo "unraid:"
# shellcheck disable=SC1078
# shellcheck disable=SC1079
# shellcheck disable=SC2086
ssh tom@unraid bash -c "'
cat "annex/$1/.git/config"
'"
