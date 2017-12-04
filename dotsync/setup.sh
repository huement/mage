#!/usr/bin/env bash

#  Dotfiles Sync
#######################################################
#  Keep track of all your configs and OS customizations.
#  Uses the 'Stow' command and supports cloud backups
#######################################################
if [ -f ~/.bash_rainbow ]; then
    source ~/.bash_rainbow
fi

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
	command -v stow >/dev/null 2>&1 || { stowHelp >&2; exit 1; }
}

function DisplayInfo {
  echo "${RED}";
  echo -e "\n\nNo --build option not set. Displaying info.\nRun again with --build for template setup.\n";
  echo "${BYLW}-------------------------------------------------------";
  echo "";
	echo "${BWHT}GNU Stow - Dotfiles manager${NORMAL}";
  echo -e "\nStow command run from ~/mage/dotsync/";
	echo "${B_GRN}${BBLK} stow --ignore=\"(^\.DS_Store)\" -t ~/ bash${NORMAL}";
  echo "";
  echo "Entire start to finish flow...${BLU}";
  echo -e "cd ~/mage/dotsync/\nmkdir ./bash\nmv ~/.bashrc ./bash\n[move other relevant files]\nstow --ignore=\"(^\.DS_Store)\" -t ~/ bash\n";
	echo -e "${BGRN}";
	echo "${NORMAL}";
  echo "${BYLW}-------------------------------------------------------";
	echo "";
}

function TemplateBuild {
  echo "";
  echo "STARTING BUILD.  .   ."
  mkdir ./bash
  mv ~/.bashrc ./bash
  mv ~/.bash_profile ./bash
  mv ~/.profile ./bash
  echo ""
  echo "BUILD FINISHED!"
  echo ""
}

if [[ $# -eq 0 ]] ; then
  isStowInstalled
  DisplayInfo
  exit 1
else
  TemplateBuild
fi
