#!/usr/bin/env bash
# shellcheck disable=SC2317

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -euo pipefail

# shellcheck source=/dev/null
source ~/bin/COLORS

usage(){
>&2 cat << EOF
${GREEN}
Usage:
  $0 <project_directory>
  $0 -h | --help

Options:
   -h --help           Show this help.
${RESET}
EOF
exit 1
}

GETOPT=getopt
if [[ "$(uname)" = Darwin ]] ; then
    # shellcheck disable=SC2015
    [[ -x "${HOMEBREW_PREFIX}/opt/gnu-getopt/bin/getopt" ]] \
        && GETOPT="${HOMEBREW_PREFIX}/opt/gnu-getopt/bin/getopt" \
        || { echo ""; echo "${RED}gnu-getopt not installed${RESET}"; echo ""; exit 2; }
fi

shortopts=h
longopts=help
if ! args=$($GETOPT --options "${shortopts}" --longoptions "${longopts}" -- "$@"); then
  usage
fi

eval set -- "${args}"
while :
do
  case $1 in
    -h | --help)           usage           ; shift ;;
    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift ; break ;;
    *) >&2 echo "Unsupported option: $1"
       usage ;;
  esac
done

if [[ $# -eq 0 ]]; then
  usage
fi

cd "${1}" && { echo "${RED}${1} already exists -- choose another project directory${RESET}"; exit 3; }
mkdir -p "${1}"
rsync -Pahvz --exclude=".*/" --exclude="main.py" ~/src/z_template-python/ "${1}"
cd "${1}" && direnv allow || exit 4

git init && git add .
sed -I '' -e '/no-commit-to-branch/d' .pre-commit-config.yaml
git add .pre-commit-config.yaml && git commit -m "Initial commit"
git remote add origin "gitea:tom/$(basename "$1").git"
git push --set-upstream origin master
rsync -Pahvz --exclude=".*/" ~/src/z_template-python/ "${1}"
echo ""
echo "${BLUE}cd ${1} && make dev${RESET}"
echo ""
