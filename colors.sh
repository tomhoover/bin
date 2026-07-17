# shellcheck shell=sh disable=SC2034

# Only use colors in interactive shells, not from crontab; honor NO_COLOR (https://no-color.org) #{{{
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    RED=$(tput setaf 1 2>/dev/null || true)
    GREEN=$(tput setaf 2 2>/dev/null || true)
    YELLOW=$(tput setaf 3 2>/dev/null || true)
    BLUE=$(tput setaf 4 2>/dev/null || true)
    MAGENTA=$(tput setaf 5 2>/dev/null || true)
    CYAN=$(tput setaf 6 2>/dev/null || true)
    BOLD=$(tput bold 2>/dev/null || true)
    DIM=$(tput dim 2>/dev/null || true)
    STANDOUT_ON=$(tput smso 2>/dev/null || true)
    STANDOUT_OFF=$(tput rmso 2>/dev/null || tput sgr0 2>/dev/null || true)
    UNDERLINE_ON=$(tput smul 2>/dev/null || true)
    UNDERLINE_OFF=$(tput rmul 2>/dev/null || tput sgr0 2>/dev/null || true)
    ITALICS_ON=$(tput sitm 2>/dev/null || true)
    ITALICS_OFF=$(tput ritm 2>/dev/null || tput sgr0 2>/dev/null || true)
    RESET=$(tput sgr0 2>/dev/null || true)
else
    RED=
    GREEN=
    YELLOW=
    BLUE=
    MAGENTA=
    CYAN=
    BOLD=
    DIM=
    STANDOUT_ON=
    STANDOUT_OFF=
    UNDERLINE_ON=
    UNDERLINE_OFF=
    ITALICS_ON=
    ITALICS_OFF=
    RESET=
fi

# Usage example:
#   # shellcheck source=/dev/null
#   source ~/bin/colors.sh
#   echo "${RED}ABORTED!${RESET} ${REPOSITORY} does not exist!"

# echo "${RED}RED"
# echo "${GREEN}GREEN"
# echo "${YELLOW}YELLOW"
# echo "${BLUE}BLUE"
# echo "${MAGENTA}MAGENTA"
# echo "${CYAN}CYAN"
# echo "${BOLD}BOLD"
# echo "${DIM}DIM${RESET}"
# echo "${STANDOUT_ON}STANDOUT_ON"
# echo "${STANDOUT_OFF}STANDOUT_OFF"
# echo "${UNDERLINE_ON}UNDERLINE_ON"
# echo "${UNDERLINE_OFF}UNDERLINE_OFF"
# echo "${ITALICS_ON}ITALICS_ON"
# echo "${ITALICS_OFF}ITALICS_OFF"
# echo "${RESET}RESET"
