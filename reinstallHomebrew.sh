#!/usr/bin/env bash

[[ "$(uname)" = "Darwin" ]] || exit

# uncomment the following to install from scratch
#ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
#exit

brew update || exit
brew doctor || exit
brew upgrade || exit

brew install bash-completion exiftool fdupes gawk getmail gnupg keychain midnight-commander rbenv ruby-build s3cmd ssh-copy-id wget duplicity

# python stuff
brew install python --with-brewed-openssl
brew install python3 --with-brewed-openssl

## # mutt
## #brew install --sidebar-patch mutt
## #brew install urlview
## #brew install notmuch
## #brew install msmtp
##
## # build Avidemux-2.5.6 stable
## #   http://www.avidemux.org/smf/index.php?topic=9960.msg53651#msg53651
## brew install pkg-config
## brew install cmake
## brew install aften
## brew -v install qt
##
## cd /usr/local/Library/Formula && wget -N https://raw.github.com/2bits/homebrew/newAdm/Library/Formula/avidemux.rb
## #brew rm -f avidemux
## brew -v install --use-llvm avidemux
##
## # To build or upgrade the lasted unstable revision past 2.5.6
## #brew rm -f avidemux
## #brew install --use-llvm --HEAD avidemux
##
## # Info On Building 2.6
## cd /usr/local/Library/Formula && wget -N https://raw.github.com/2bits/homebrew/newAdm3/Library/Formula/avidemux3.rb
## #brew rm -f avidemux3
## brew -v install -d --use-llvm avidemux3

brew linkapps
brew cleanup

# http://gillesfabio.github.io/homebrew-cask-homepage/
# https://github.com/caskroom/homebrew-cask
# http://caskroom.io
brew tap phinze/homebrew-cask
brew install brew-cask
brew upgrade brew-cask

brew cleanup && brew cask cleanup

brew list

exit

## 120730 ariel: a52dec aften avidemux avidemux3 cmake exiftool faac faad2 fdupes fribidi gawk getmail gettext glib gnupg keychain lame libdca libffi libogg libvorbis libvpx mad midnight-commander oniguruma opencore-amr pcre pkg-config qt rbenv readline ruby-build s-lang s3cmd sqlite two-lame wget x264 xvid xz yasm

## 13128 ariel:
#a52dec			duplicity		frei0r			gnupg			libdca			libtool			mu			orc			rbenv-gem-rehash	speex			wget
#aften			exiftool		fribidi			graphviz		libffi			libvo-aacenc		mutt			pcre			readline		sqlite			x264
#autoconf		faac			gawk			imagemagick		libgpg-error		libvorbis		notmuch			pkg-config		rsync			ssh-copy-id		xapian
#automake		faad2			gdbm			jpeg			libogg			libvpx			oniguruma		popt			rtmpdump		talloc			xvid
#avidemux		fdk-aac			getmail			keychain		libpng			libyaml			opencore-amr		python			ruby-build		theora			xz
#avidemux3		fdupes			gettext			lame			librsync		little-cms2		openjpeg		python3			s-lang			tokyo-cabinet		yasm
#bash-completion		fontconfig		glib			libass			libssh2			mad			openssl			qt			s3cmd			two-lame
#cmake			freetype		gmime			libcaca			libtiff			midnight-commander	opus			rbenv			schroedinger		urlview

## 140322 ariel:
#a52dec			duplicity		frei0r			gnupg			libdca			libtool			mu			orc			rbenv-gem-rehash	speex			wget
#aften			exiftool		fribidi			graphviz		libffi			libvo-aacenc		mutt			pcre			readline		sqlite			x264
#autoconf		faac			gawk			imagemagick		libgpg-error		libvorbis		notmuch			pkg-config		rsync			ssh-copy-id		xapian
#automake		faad2			gdbm			jpeg			libogg			libvpx			oniguruma		popt			rtmpdump		talloc			xvid
#avidemux		fdk-aac			getmail			keychain		libpng			libyaml			opencore-amr		python			ruby-build		theora			xz
#avidemux3		fdupes			gettext			lame			librsync		little-cms2		openjpeg		python3			s-lang			tokyo-cabinet		yasm
#bash-completion		fontconfig		glib			libass			libssh2			mad			openssl			qt			s3cmd			two-lame
#cmake			freetype		gmime			libcaca			libtiff			midnight-commander	opus			rbenv			schroedinger		urlview

## 140403 ariel:
#autoconf		exiftool		gdbm			glib			libffi			libssh2			pkg-config		python3			ruby-build		sqlite			xz
#bash-completion	fdupes			getmail			gnupg			libpng			midnight-commander	popt			rbenv			s-lang			ssh-copy-id
#duplicity		gawk			gettext			keychain		librsync		openssl			python			readline		s3cmd			wget

## 140823 ariel:
# autoconf bash-completion duplicity exiftool faac fdupes ffmpeg gawk gdbm getmail gettext glib gnupg keychain lame libffi libpng librsync libssh2 midnight-commander openssl pkg-config popt python python3 rbenv readline ruby-build s-lang s3cmd sqlite ssh-copy-id wget x264 xvid xz youtube-dl

## 140823 rMBP
# bash-completion		fdupes			getmail			gnupg			libpng			midnight-commander	popt			readline		sqlite			xz
# duplicity		gawk			gettext			keychain		librsync		openssl			python			s-lang			ssh-copy-id
# exiftool		gdbm			glib			libffi			libssh2			pkg-config		python3			s3cmd			wget

## 150102 rMBP
# autoconf bash-completion brew-cask duplicity exiftool fdupes gawk gdbm getmail gettext glib gnupg keychain libffi libpng librsync libssh2 midnight-commander mr openssl pkg-config popt python python3 rbenv readline ruby-build s-lang s3cmd sleepwatcher sqlite ssh-copy-id tree vcsh wget xz
