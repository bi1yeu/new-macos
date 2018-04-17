#!/bin/bash

# Mostly taken from https://gist.github.com/bi1yeu/93682801e496a2f7a9a5c3e9bd437834

set -e

[ -z "$EMAIL" ] && echo "Need to set EMAIL. Please see README.md." && exit 1
[ -z "$FULLNAME" ] && echo "Need to set FULLNAME. Please see README.md." && exit 1

echo '=== Installing (or updating) Homebrew ==='

# https://brew.sh/

which brew > /dev/null && brew update
which brew > /dev/null || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# This should also be part of startup script
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

echo '=== Installing Homebrew dependencies ==='

brew bundle

echo '=== Configuring git ==='

git config --global user.name "$FULLNAME"
git config --global user.email $EMAIL
git config --global core.editor 'vim'
git config --global push.default simple

echo '=== Installing Spacemacs ==='

# https://github.com/syl20bnr/spacemacs
# emacs-plus installed via Homebrew above

[ -f ~/.emacs.d ] && git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
[ -f ~/.dotfiles ] && git clone git@github.com:bi1yeu/dotfiles.git ~/.dotfiles && ./.dotfiles/link-dotfiles.sh

if [ ! -f ~/.zprofile ]; then
    echo '=== No ~/.zprofile found; creating one ==='
    touch ~/.zprofile
    echo 'export PATH=/usr/local/bin:/usr/local/sbin:$PATH' >> ~/.zprofile
    echo 'export PATH="/usr/local/opt/python/libexec/bin:$PATH"' >> ~/.zprofile
    echo 'alias spacemacs="/usr/local/opt/emacs-plus/bin/emacs -nw"' >> ~/.zprofile
fi

echo '=== Configuring zsh ==='

# zsh already installed via Homebrew above
if ! grep -q /usr/local/bin/zsh "/etc/shells"; then
  echo 'adding /usr/local/bin/zsh to /etc/shells'
  echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells
fi

echo 'Installing oh-my-zsh'
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo '=== Done :) ==='
