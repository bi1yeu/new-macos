#!/bin/bash

# Mostly taken from https://gist.github.com/bi1yeu/93682801e496a2f7a9a5c3e9bd437834

set -e

echo '=== Installing (or updating) Homebrew ==='

# https://brew.sh/

which brew > /dev/null && brew update
which brew > /dev/null || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# This should also be part of startup script
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

echo '=== Tapping ==='

brew tap caskroom/cask
brew tap caskroom/versions
brew tap caskroom/fonts
brew tap tldr-pages/tldr

echo '=== Installing Casks ==='

brew cask install alfred                   # https://www.alfredapp.com/
brew cask install authy                    # https://authy.com
brew cask install darktable                # http://www.darktable.org
brew cask install dropbox                  # https://dropbox.com
brew cask install firefox                  # https://www.mozilla.org/en-US/firefox/
brew cask install flux                     # https://justgetflux.com/
brew cask install font-fira-code           # https://github.com/tonsky/FiraCode
brew cask install iterm2-nightly           # http://iterm2.com/
brew cask install java                     # https://java.com/en/download/
brew cask install keepingyouawake          # https://github.com/newmarcel/KeepingYouAwake
brew cask install licecap                  # http://www.cockos.com/licecap/
brew cask install middleclick              # http://rouge41.com/labs/
brew cask install private-internet-access  # https://www.privateinternetaccess.com
brew cask install spectacle                # https://www.spectacleapp.com/
brew cask install transmission             # https://transmissionbt.com

echo '=== Installing Brews ==='

brew install aspell                        # http://aspell.net/
brew install bash-completion               # https://github.com/scop/bash-completion
brew install bash-git-prompt               # https://github.com/magicmonty/bash-git-prompt
brew install fd                            # https://github.com/sharkdp/fd
brew install git                           # https://git-scm.com/
brew install gnupg2                        # https://www.gnupg.org/
brew install htop                          # http://hisham.hm/htop/
brew install jq                            # https://stedolan.github.io/jq/
brew install leiningen                     # http://leiningen.org/
brew install markdown                      # http://daringfireball.net/projects/markdown/
brew install pandoc                        # http://pandoc.org/
brew install python3                       # https://www.python.org
brew install shellcheck                    # https://www.shellcheck.net/
brew install speedtest-cli                 # https://github.com/sivel/speedtest-cli
brew install the_silver_searcher           # https://github.com/ggreer/the_silver_searcher/
brew install tldr                          # http://tldr-pages.github.io/
brew install trash                         # http://hasseg.org/trash/
brew install tree                          # http://mama.indstate.edu/users/ice/tree/
brew install wget                          # https://www.gnu.org/software/wget/

echo '=== Configuring git ==='

git config --global user.name "$FULLNAME"
git config --global user.email $EMAIL
git config --global core.editor 'vim'
git config --global push.default simple

echo '=== Installing Spacemacs ==='

# https://github.com/syl20bnr/spacemacs

brew tap d12frosted/emacs-plus
brew unlink emacs-plus
brew install emacs-plus
brew linkapps emacs-plus

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
