#!/bin/bash

# Exit immediately on error.
set -e

find ~ -type d -name '.Trash' -prune -o -name '.git'
