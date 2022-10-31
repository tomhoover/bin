#!/usr/bin/env bash

# wrap in function to allow for local variables
fix_mosh_server() {

  # local variables for convenience
  local fw mosh_sym mosh_abs
  fw='/usr/libexec/ApplicationFirewall/socketfilterfw'
  mosh_sym="$(which mosh-server)"
  mosh_abs="$(greadlink -f "$mosh_sym")"

  # temporarily shut firewall off
  sudo "$fw" --setglobalstate off

  # add symlinked location to firewall
  sudo "$fw" --add "$mosh_sym"
  sudo "$fw" --unblockapp "$mosh_sym"

  # add symlinked location to firewall
  sudo "$fw" --add "$mosh_abs"
  sudo "$fw" --unblockapp "$mosh_abs"

  # re-enable firewall
  sudo "$fw" --setglobalstate on

}

fix_mosh_server
