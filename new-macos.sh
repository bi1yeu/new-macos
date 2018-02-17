#!/bin/bash

# Mostly taken from https://gist.github.com/bi1yeu/93682801e496a2f7a9a5c3e9bd437834

set -e

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

if [ ! -f ~/.bash_profile ]; then
    echo '=== No ~/.bash_profile found; creating one ==='
    touch ~/.bash_profile
    echo 'export PATH=/usr/local/bin:/usr/local/sbin:$PATH' >> ~/.bash_profile
    echo '[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion' >> ~/.bash_profile
    echo 'if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
    source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi' >> ~/.bash_profile
    echo 'GIT_PROMPT_ONLY_IN_REPO=1' >> ~/.bash_profile
fi

echo '=== Done :) ==='
