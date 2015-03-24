#!/bin/bash

# Install RVM, rubies, and global gems
echo 'Installing RVM, rubies, and gems...'
\curl -sSL https://get.rvm.io | bash
rvm install 2.1.5
rvm --default use 2.1.5
cp ./.gemrc $HOME/.gemrc
echo "Installing bundler as a global gem..."
rvm @global do gem install bundler
rvm gemset use default
default_gems=( aws-sdk rubocop nokogiri activesupport )
for gem in ${default_gems[*]}; do
  echo "Installing $gem..."
  gem install $gem
done

# Install HomeBrew and packages
echo 'Installing HomeBrew and its packages...'
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brews=( vim git wget ack openssl tree nmap )
for brew in ${brews[*]}; do
  echo "Installing $brew..."
  brew install $brew
done

# Configure/install python/virturalenv and packages
echo 'Installing and configuring python/virtualenv...'
brew install python
pip install --upgrade pip
pip freeze | sudo xargs pip uninstall -y
pip install virtualenvwrapper
cp .bash_profile $HOME/.bash_profile
# source $HOME/.bash_profile
mkvirtualenv default
python_packages=( awscli nose requests )
for pkg in ${python_packages[*]}; do
  echo "Installing $pkg..."
  pip install $pkg
done
deactivate

# Install HomeBrew Cask and casks
echo 'Installing HomeBrew Cask and casks...'
brew install caskroom/cask/brew-cask
casks=( firefox google-chrome iterm2 textwrangler sublime-text vagrant virtualbox intellij-idea )
for cask in ${casks[*]}; do
  echo "Installing $cask..."
  brew cask install $cask --appdir=/Applications
done

# Configure .vim
echo 'Configuring vim...'
mkdir -p $HOME/.vim/bundle
vim_bundles=(
  kien/rainbow_parentheses.vim
  vim-scripts/paredit.vim
  elzr/vim-json
  tpope/vim-sensible
)
for repo in ${vim_bundles[*]}; do
  directory=${repo#*/}
  if [ -d $HOME/.vim/bundle/${directory} ]; then
    cd $HOME/.vim/bundle/${directory}
    git pull origin master
  else
    cd $HOME/.vim/bundle/
    git clone git@github.com:${repo}
  fi
  cd -
done
cp .vimrc $HOME/.vimrc

cp .profile $HOME/.profile
cp .rvmrc $HOME/.rvmrc
