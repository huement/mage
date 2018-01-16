#!/usr/bin/env bash

#     __________              .__   ___________________        #
#     \______  |_____    _____|  |__\______   \_   ___ \       #
#      |    |  _\__  \  /  ___|  |  \|       _/    \  \/       #
#      |    |   \/ __ \_\___ \|   Y  |    |   \     \____      #
#      |______  (____  /____  |___|  |____|_  /\______  /      #
#             \/     \/     \/     \/       \/        \/       #
#                                                              #
#	       Sourced by non-interactive non-login shells           #
#                                                              #

export THIRTEEN="0.3.5"

function debugLogger {
  echo "${BGRN}[DONE]${NORMAL} $1";
}

if [ -z "$PS1" ]; then
  # PREVENT DEBUG MODE, GIT GLOBALS ETC IF REMOTE SHELL
  DEBUGMODE=1
else
  # GIT Config
  # -----   ----    ---    --    -
  # Config GIT. Store sensative info in .bash_naked!
  # -----   ----    ---    --    -	 
  if [ -z "$GIT_AUTHOR_NAME" ]; then
  	if [ $DEBUGMODE == "0" ]; then echo "\n[FAIL] GIT_AUTHOR_NAME and/or GIT_AUTHOR_EMAIL not configured.\n"; fi
  else
  	GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
  	GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
  	git config --global user.name $GIT_AUTHOR_NAME
  	git config --global user.email $GIT_AUTHOR_EMAIL
  	git config --global user.mail $GIT_AUTHOR_EMAIL
    
    git config --global color.ui true
    git config --global color.diff auto
    git config --global color.status auto
    git config --global color.branch auto
    git config --global credential.helper osxkeychain
    
    if [ $DEBUGMODE == "0" ]; then debugLogger "Loaded Git"; fi
  fi

  # Shell variables
  # -----   ----    ---    --    -
  shopt -s nocaseglob;
  shopt -s cdspell;
  #shopt -s globstar;
  shopt -s checkwinsize;
  shopt -s histappend;
  for option in autocd globstar; do
  	shopt -s "$option" 2> /dev/null;
  done;
  set skip-completed-text on
  set completion-query-items 500
  shopt -s histverify
  
  # Shell customizations
  # -----   ----    ---    --    -
  export EDITOR=/usr/local/bin/nano
  export CLICOLOR=1
  export DIR_COLORS="/Users/${GUSER}/.bash_dircolors"   # Maybe do this also: eval "`gdircolors -b $DIR_COLORS`"
  export HISTSIZE='32768';
  export HISTFILESIZE="${HISTSIZE}";
  HISTCONTROL=ignoreboth                                # Don't put duplicate lines in the history
  export HISTTIMEFORMAT="%F %T "                        # Add timestamp to history file
  export LANG='en_US.UTF-8';                            # Prefer US English and use UTF-8.
  export LC_ALL='en_US.UTF-8';
  export LESS_TERMCAP_md='${YLW}';
  export BYOBU_PREFIX=/usr/local
  
  export BASE16_SHELL=$HOME/.config/base16-shell/
  [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$(${BASE16_SHELL}/profile_helper.sh)"
  
fi

# Homebrew Package Manager [ brew ]
# ------------------   -----   ----    ---    --    -
export BREWPATH="/usr/local/sbin:/usr/local/bin"
export BREWPREFIX='/usr/local'
export HOMEBREW_NO_EMOJI='1'                                          # Opt out of Homebrew's analytics
export HOMEBREW_NO_ANALYTICS=1                                        # Path to make coreutils man pages accessible
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}"   # Improve Man pages

if [ $DEBUGMODE = "0" ]; then debugLogger "Loaded Homebrew"; fi
	

# BASH BLING
# ------------------   -----   ----    ---    --    -
if [ -x /usr/libexec/path_helper ]; then
	eval `/usr/libexec/path_helper -s`
fi

## BASH Completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then source $(brew --prefix)/etc/bash_completion; fi
if [ -f /etc/bash_completion ]; then source /etc/bash_completion; fi;

## GRC Autocomplete
if [ -f $(brew --prefix)/etc/grc.bashrc ]; then source $(brew --prefix)/etc/grc.bashrc; fi

## Setup fzf [Fuzzy Finder]
## To install run 'brew install fzf'
## Then run /usr/local/opt/fzf/install (if $(brew --prefix) is /usr/local)
[ -f /Users/$GUSER/.fzf.bash ] && source /Users/$GUSER/.fzf.bash
## Key bindings
source "/usr/local/opt/fzf/shell/key-bindings.bash"

## BASH Bookmarks
source /Users/$GUSER/.local/bin/bashmarks.sh
source /Users/$GUSER/Myriad/Wordpress/wp-completion.bash

## Homebrew Nano
alias nano='/usr/local/bin/nano --smooth --tabstospaces --linenumbers'

if [ $DEBUGMODE = "0" ]; then debugLogger "Loaded Bash Addons"; fi



# NodeJS [ Node Version Manager | NVM ]
# ------------------   -----   ----    ---    --    -
export NVM_DIR="/Users/${GUSER}/.nvm"
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"  # This loads nvm
[ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"  # This loads nvm bash_completion

## Grunt Autocomplete
eval "$(grunt --completion=bash)"

#NOWAPATH="/Applications/Developer/NowaGUI.app/Contents/Resources/app/nodes:/Users/$USER/.nowa-gui/installation/node_modules/.bin:/Applications/Developer/NowaGUI.app/Contents/Resources/app/node_modules/.bin"

if [ $DEBUGMODE = "0" ]; then debugLogger "Loaded NodeJS [NVM]"; fi
if [ $DEBUGMODE = "0" ]; then echo -e "\nNVM"; nvm --version; echo -e "\n"; fi



# PERLBREW https://perlbrew.pl/
# ------------------   -----   ----    ---    --    -
source /Users/${GUSER}/perl5/perlbrew/etc/bashrc

if [ $DEBUGMODE = "0" ]; then debugLogger "Loaded Perlbrew"; fi


# GO (via Homebrew)
# ------------------   -----   ----    ---    --    -
export GOPATH=/Users/$GUSER/Go
export GOBIN=$GOPATH/bin
GOMODPATH="$GOPATH/bin:/usr/local/opt/go/libexec/bin"

if [ $DEBUGMODE = "0" ]; then debugLogger "Loaded Google GO"; fi



# PYTHON
# ------------------   -----   ----    ---    --    -
export PY3PATH=/Users/$GUSER/Library/Python/3.6/bin
export PY2PATH=/Users/$GUSER/Library/Python/2.7/bin
PYTHONPATH="${PY3PATH}:${PY2PATH}"

if [ $DEBUGMODE = "0" ]; then debugLogger "Loaded Python 2+3"; fi



# Ruby [ Ruby Version Manager | RVM ](rvm.io)
# ------------------   -----   ----    ---    --    -
export RUBYPATH="/Users/$GUSER/.rvm/bin:/Users/$GUSER/.cargo/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

if [ $DEBUGMODE = "0" ]; then
 debugLogger "Loaded Ruby [ RVM ]";
 echo " " && $RUBYPATH/rvm -v && echo -e "\n"
fi



# PHP [ PHP7 + Laravel Homestead + WordPress ]
# ------------------   -----   ----    ---    --    -
PHPPATH="/Users/$GUSER/.composer/vendor/bin:/Users/${GUSER}/.composer/vendor/bin:vendor/bin:$(brew --prefix homebrew/php/php71)/bin"
HOMESTEADDIR="/Users/$GUSER/Homestead";

# Vagrant + Homestead Aliases
function homestead { (cd /Users/$GUSER/Homestead && vagrant $*) }
function vagrantreload {
	echo -e "\n  -------------\n    VAGRANT RELOADING\n  -------------\n - - - DONE! - - -\n";
	cd /Users/$GUSER/Homestead;
	echo "> vagrant reload --provision";
	vagrant "reload --provision";
	echo -e "\n\n - - - DONE! - - -\n";
}
alias vagg='vagrant global-status'
alias vag="cd ${HOMESTEADDIR}"
alias hdir="cd ${HOMESTEADDIR}"
alias vags='$(homestead status)'
alias vagu='$(homestead up)'
alias vagssh='$(homestead ssh)'
alias vagre='$(vagrantreload)'

WPCLIPATH="/Users/$GUSER/.wp-cli"

if [ $DEBUGMODE = "0" ]; then 
  debugLogger "Loaded PHP + VAGRANT + HOMESTEAD";
  echo " " && $(which php) -v && echo -e "\n";
fi



# FINAL PATH
# ------------------   -----   ----    ---    --    -
export PATH=$RUBYPATH:/usr/local/opt/openssl/bin:$PYTHONPATH:$PHPPATH:$GOMODPATH:$BREWPATH:$PATH
