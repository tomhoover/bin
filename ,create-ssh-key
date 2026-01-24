#!/usr/bin/env bash

MYHOST=$(uname -n | sed 's/\..*//')     # alternative to $(hostname -s), as arch does not install 'hostname' by default

USER=$(whoami)
ssh-keygen -t rsa -b 4096 -C "${USER}@${MYHOST}" -f "$HOME"/.ssh/id_rsa_"${MYHOST}"
# IdentityFile ~/.ssh/id_rsa_%L
