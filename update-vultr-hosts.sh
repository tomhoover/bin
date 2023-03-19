#!/usr/bin/env bash

[[ -f ${HOME}/.SECRETS ]] && . "${HOME}"/.SECRETS

vultr-cli instance list \
    | sed -e '$d' \
      -e '/^ID/d' \
      -e '/^==========/d' \
      -e '/^TOTAL/d' \
      -e 's/^[0-9a-z-]*[ 	]*\([0-9.]*\)[ 	]*\([0-9a-zA-Z]*\).*/Host \2 \2\n    User root\n    Hostname \1\n/' \
    | awk '/^Host/ {print $1 " " $2 " " toupper($3)} \
      !/^Host/ {print $0}' \
    > ~/.ssh/vultr_config
