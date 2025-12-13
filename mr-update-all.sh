#!/usr/bin/env bash

# set -e: exit script immediately upon error
# set -u: treat unset variables as an error
# set -o pipefail: cause a pipeline to fail, if any command within it fails
set -eu -o pipefail

cd && mr up && mr push
cd ~/src && mr up && mr push
cd ~/src/3dPrinting && mr up && mr push
cd ~/src/github.com && mr up && mr push
