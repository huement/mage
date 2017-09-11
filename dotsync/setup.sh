#!/usr/bin/env bash

#  Dotfiles Sync
#######################################################
#  Keep track of all your configs and OS customizations.
#  Uses the 'Stow' command and supports cloud backups
#######################################################

DisplayInfo() {
	echo "${B_YLW}${BLK}  GNU Stow - Dotfiles manager  ${NORMAL}";
	echo "${BBLU}stow -t ~/where/dir/syslinks_are syslinks ${WHT}- You select your target (ie /home or whatever).";
	echo "Its important to note it goes target stow first. BEFORE you give it source dir."
	echo ""
	echo "https://spin.atomicobject.com/2014/12/26/manage-dotfiles-gnu-stow/"
	echo "${NORMAL}";
	echo ""
}
