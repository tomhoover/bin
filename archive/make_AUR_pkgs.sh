#!/usr/bin/env sh
cd /home/tom/src/AUR/termite && git pull && less -Ke PKGBUILD && makepkg -si
