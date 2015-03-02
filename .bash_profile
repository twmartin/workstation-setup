
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

#### PYTHON CONFIGURATION ####
export PIP_REQUIRE_VIRTUALENV=true
export PIP_DOWNLOAD_CACHE=/Users/twmartin/.pip/cache
export PYTHONPATH=/usr/local/lib/python2.7/site-packages/
export WORKON_HOME=/Users/twmartin/.virtualenvs/
mkdir -p $WORKON_HOME
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
source /usr/local/bin/virtualenvwrapper.sh
##### /PYTHON CONFIGURATION ####

