#!/bin/bash


# Git config
git config --global user.name 'twmartin'
echo 'Enter your email for git config: '
read -r GIT_EMAIL
git config --global user.email "$GIT_EMAIL"


# Install RVM, rubies, and global gems
echo 'Installing RVM, rubies, and gems...'
curl -sSL https://get.rvm.io | bash
rvm install 2.2.4
rvm --default use 2.2.4
cp ./.gemrc-template "$HOME/.gemrc"
echo "Installing bundler as a global gem..."
# shellcheck disable=SC1010
rvm @global do gem install bundler
rvm gemset use default
default_gems=( aws-sdk rubocop nokogiri activesupport )
for gem in ${default_gems[*]}; do
  echo "Installing $gem..."
  gem install "$gem"
done


# Install HomeBrew and packages
echo 'Installing HomeBrew and its packages...'
hombrew_url='https://raw.githubusercontent.com/Homebrew/install/master/install'
ruby -e "$(curl -fsSL $hombrew_url)"
brews=(
  ack
  docker
  docker-machine
  git
  nmap
  openssl
  shellcheck
  tree
  vim
  wget
)
for brew in ${brews[*]}; do
  echo "Installing $brew..."
  brew install "$brew"
done


# Configure/install python/virturalenv and packages
echo 'Installing and configuring python/virtualenv...'
brew install python
pip install --upgrade pip
pip freeze | sudo xargs pip uninstall -y
pip install --upgrade virtualenvwrapper
cp .bash_profile-template "$HOME/.bash_profile"
# shellcheck disable=SC1090
source ~/.bash_profile
mkvirtualenv default
python_packages=( awscli nose requests )
for py_pkg in ${python_packages[*]}; do
  echo "Installing $py_pkg..."
  pip install --upgrade "$py_pkg"
done
deactivate


# Install HomeBrew Cask and casks
echo 'Installing HomeBrew Cask and casks...'
brew install caskroom/cask/brew-cask
casks=(
  atom
  firefox
  google-chrome
  google-cloud-sdk
  iterm2
  vagrant
  virtualbox
)
for cask in ${casks[*]}; do
  echo "Installing $cask..."
  brew cask install "$cask" --appdir=/Applications
done

# Install atom packages
echo 'Installing atom packages...'
atom_pkgs=(
  Sublime-Style-Column-Selection
  color-picker
  csscomb
  file-icons
  highlight-selected
  indent-guide-improved
  language-docker
  language-groovy
  language-markdown
  linter
  linter-coffeelint
  linter-csslint
  linter-docker
  linter-js-yaml
  linter-jsonlint
  linter-markdown
  linter-pylint
  linter-shellcheck
  linter-rubocop
  minimap
  minimap-highlight-selected
  minimap-linter
  minimap-selection
  pigments
)
for atom_pkg in ${atom_pkgs[*]}; do
  echo "Installing $atom_pkg..."
  apm install "$atom_pkg"
done

# Configure .vim
echo 'Configuring vim...'
mkdir -p "$HOME/.vim/autoload" "$HOME/.vim/bundle"
curl -LSso "$HOME/.vim/autoload/pathogen.vim" https://tpo.pe/pathogen.vim
vim_bundles=(
  kien/rainbow_parentheses.vim
  vim-scripts/paredit.vim
  elzr/vim-json
  tpope/vim-sensible
)
for repo in ${vim_bundles[*]}; do
  directory=${repo#*/}
  if [ -d "$HOME/.vim/bundle/${directory}" ]; then
    cd "$HOME/.vim/bundle/${directory}" || exit
    git pull origin master
  else
    cd "$HOME/.vim/bundle/" || exit
    git clone "git@github.com:${repo}"
  fi
  cd - || exit
done
cp .vimrc-template "$HOME/.vimrc"

cp .profile-template "$HOME/.profile"
cp .rvmrc-template "$HOME/.rvmrc"
