#!/usr/bin/env bash

#  Dotfiles Sync
#######################################################
#  Keep track of all your configs and OS customizations.
#  Uses the 'Stow' command and supports cloud backups
#######################################################

function StowInfo {
	echo "${B_YLW}${BLK}  GNU Stow - Dotfiles manager  ${NORMAL}";
	echo "${BBLU}stow -t ~/where/dir/syslinks_are syslinks ${WHT}- You select your target (ie /home or whatever).";
	echo "Its important to note it goes target stow first. BEFORE you give it source dir.";
	echo "";
	echo "https://spin.atomicobject.com/2014/12/26/manage-dotfiles-gnu-stow/";
	echo "${NORMAL}";
	echo "";
}

function stowHelp {
	echo "";
  if tput setaf 1 &> /dev/null; then
    echo "$(tput bold)$(tput setaf 15)$(tput setab 9)[FAIL]$(tput sgr0) Stow not installed!";
  else
    echo "\e[1m\e[1;41m\e[47m[FAIL]\e[0m Stow not installed!";
  fi
	
	echo -n "'stow' Required! Mage could not find it... ";
  if tput setaf 1 &> /dev/null; then
    echo -n " Download it! $(tput bold)$(tput setaf 12) https://www.gnu.org/software/stow/ $(tput sgr0)";
  else
    echo -n " Download it! \e[1m\e[1;34m https://www.gnu.org/software/stow/ \e[0m";
  fi
	echo "";
	echo "";
}

function isStowInstalled {
	command -v foo >/dev/null 2>&1 || { stowHelp >&2; exit 1; }
}

stowHelp