#!/usr/bin/env bash

brew update
brew upgrade
brew cask upgrade

# Notes:
# GNU core utilities: Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
# GNU `find`, `locate`, `updatedb`, and `xargs` are `g`-prefixed.
# GNU `sed` overwrites the built-in `sed`.
# Bash: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# Wget: with IRI support.

# Brew
brew install gnu-sed --with-default-names
brew install imagemagick --with-webp
brew install wget --with-iri
brew install ack
brew install adns
brew install bash
brew install bdw-gc
brew install chunkwm
brew install cmake
brew install coreutils
brew install cowsay
brew install findutils
brew install freetype
brew install gcc
brew install gdb
brew install gdbm
brew install gettext
brew install git
brew install git-lfs
brew install gmp
brew install gnu-getopt
brew install gnupg
brew install gnupg@1.4
brew install gnutls
brew install grep
brew install htop
brew install icu4c
brew install isl
brew install jemalloc
brew install jpeg
brew install keychain
brew install libassuan
brew install libevent
brew install libffi
brew install libgcrypt
brew install libgpg-error
brew install libidn2
brew install libksba
brew install libmpc
brew install libpng
brew install libtasn1
brew install libtermkey
brew install libtiff
brew install libtool
brew install libunistring
brew install libusb
brew install libuv
brew install libvterm
brew install libyaml
brew install luajit
brew install moreutils
brew install mpfr
brew install msgpack
brew install neofetch
brew install neovim
brew install nettle
brew install node
brew install npth
brew install openssh
brew install openssl
brew install openssl@1.1
brew install p11-kit
brew install pass
brew install pcre
brew install perl
brew install pigz
brew install pinentry
brew install pinentry-mac
brew install pkg-config
brew install pv
brew install python
brew install python3
brew install qrencode
brew install readline
brew install rename
brew install rlwrap
brew install ruby
brew install screenresolution
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install skhd
brew install sl
brew install sqlite
brew install ssh-copy-id
brew install task
brew install tmux
brew install tree
brew install unibilium
brew install vbindiff
brew install w3m
brew install webp
brew install woff2
brew install xclip
brew install xz
brew install zopfli
brew install zsh

# Casks
brew cask install calibre
brew cask install firefoxnightly
brew cask install font-firacode-nerd-font-mono
brew cask install font-hack-nerd-font
brew cask install gitkraken
brew cask install haskell-platform
brew cask install iterm2-nightly
brew cask install java
brew cask install jetbrains-toolbox
brew cask install karabiner-elements
brew cask install kdiff3
brew cask install kicad
brew cask install mactex
brew cask install nextcloud
brew cask install qtpass
brew cask install transmission
brew cask install tunnelblick
brew cask install visual-studio-code

# Chunkwm
brew tap crisidev/homebrew-chunkwm
brew install chunkwm

# Cleanup
brew cleanup
brew cask cleanup
