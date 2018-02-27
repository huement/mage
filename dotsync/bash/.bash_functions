#!/usr/bin/env bash

#   ___________                   __  .__                      
#   \_   _______ __  ____   _____|  |_|__| ____   ____   ______
#    |    __)|  |  \/    \_/ ___\   __|  |/    \ /    \ /  ___/
#    |     | |  |  |   |  \  \___|  | |  (  [ ] |   |  \\___ \ 
#    \___  | |____/|___|  /\___  |__| |__|\____/|___|  /____  >
#        \/             \/     \/                    \/     \/ 
#   
	
# ALIASES [ Shortcuts for the whole fam ]
# ----------------------------------------   -----   ----    ---    --    -
alias rebash="clear;source ~/.bash_profile"
alias sudo='sudo '                          # enables aliases to be sudo'd
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias less='less -r'
alias cdir="cd ~/Code"


# EXA [ https://github.com/ogham/exa ] 
# ----------------------------------------   -----   ----    ---    --    -
# ls [List] gets a modern day overhaul from github.com/ogham/exa
# ----------------------------------------   -----   ----    ---    --    -
alias ls='exa -lhb --group-directories-first --all'
# original ls ( system installed ls ) allows you to circumvent the old ls command
alias ols='/bin/ls'
alias lspath='ls -d $PWD/*'
#alias ls='ls -G'
#alias la='exa -l --all'


# fzf [ fuzzy ]
# ----------------------------------------   -----   ----    ---    --    -
# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function fe {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-nano} "${files[@]}"
}
# fda - including hidden directories
function fd {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}
#function ff { grep --line-buffered --color=never -r "" $1 | fzf }


# MAC UI Tweaks
# ----------------------------------------   -----   ----    ---    --    -
# hide/show hidden files
alias ui_iconhide="defaults write com.apple.finder AppleShowAllFiles YES;killall Finder"
alias ui_iconshow="defaults write com.apple.finder AppleShowAllFiles NO;killall Finder"
# Hide/show all desktop icons (useful when presenting)
alias ui_icondesk=desktopIcons
# Customize Launchpad Icon column and row count
alias ui_iconlaunch=launchPadTweak
alias ui_iconlaunchreset=launchPadReset
# Create an empty spot in the dock
alias ui_dockblank="defaults write com.apple.dock persistent-apps -array-add '{\"tile-type\"=\"spacer-tile\";}'; killall Dock"
# Ring the terminal bell, and put a badge on Terminal.app’s Dock icon
# (useful when executing time-consuming commands)
alias ui_badge="tput bel"

# CHUNK WINDOW MANAGER
alias chunkrestart="brew services restart chunkwm"
alias chunkstart="brew services start chunkwm"
alias chunkstop="brew services stop chunkwm"
function upgrade-chunkwm {
    brew reinstall --HEAD chunkwm
    codesign -fs "chunkwm-cert" $(brew --prefix chunkwm)/bin/chunkwm
    brew services restart chunkwm
}

# Icon maker
alias svgicns='~/Mage/command/svg_icns.sh'


# Helpful Functions
# ----------------------------------------   -----   ----    ---    --    -
function zipf { zip -r "$1".zip "$1" ; } # Create a ZIP archive of a folder   

# Create a new directory and enter it
function mkcd { mkdir -p "$@" && cd "$_"; }

# Change working directory to the top-most Finder window location
function cdf { 
	# short for `cdfinder`
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

# Management services like a RHEL\Centos
if [[ `uname` == 'Darwin' ]]; then
  alias systemctl='brew services'
fi


# NOTIFICATION CENTER SHORTCUT
# ----------------------------------------   -----   ----    ---    --    -
# Requirement | sudo gem install terminal-notifier

function bashNote {
	if [ -z "$2" ]; 
	then
		terminal-notifier -message "$1"
	else
		terminal-notifier -message "$1" -title "$2"
	fi
}


#   MacOS Spotlight
#   -----------------------------------------------------------------------------------
alias spotlight_stop='sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist'
alias spotlight_start='sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist'
alias spotlight_rebuild='sudo mdutil -E /'
# spotlight: Search for a file using MacOS Spotlight's metadata
spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; } 


#   App Sepcific
#   ------------------------------------------------------------
# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-descript$
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"


#   MacOS Server
#   ------------------------------------------------------------
alias server_httpd="sudo mate /Library/Server/web/config/apache2/httpd_server_app.conf"
alias server_status="sudo serveradmin fullstatus web"
alias server_start="sudo serveradmin start web"
alias server_stop="sudo serveradmin stop web"
alias server_address="/usr/local/bin/bash /Users/derekscott/Mage/dotsync/ui/.ubersicht/NetworkInfo.widget/NetworkInfo.sh"