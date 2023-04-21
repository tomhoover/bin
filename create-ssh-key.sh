#!/usr/bin/env bash

HOST=$(hostname -s)
USER=$(whoami)
ssh-keygen -t rsa -b 4096 -C "${USER}@${HOST}" -f "$HOME"/.ssh/id_rsa_"${HOST}"
# IdentityFile ~/.ssh/id_rsa_%L
