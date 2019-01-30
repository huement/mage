#!/usr/bin/env bash
#
##     ______         __               ______           __ __              
##    |      |.-----.|  |.-----.----. |      |.-----.--|  |__|.-----.-----.
##    |   ---||  _  ||  ||  _  |   _| |   ---||  _  |  _  |  ||     |  _  |
##    |______||_____||__||_____|__|   |______||_____|_____|__||__|__|___  |
##                                                                  |_____|
##
#
## 		@brief Helpful bash.sh functions related to colors of the command prompt output
##					 or debugging said colors. Even just cool terminal output may end up here.
#

# Globals
DEBUG="false";
scriptPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
scriptName=$(basename $0);
scriptBasename="$(basename ${scriptName} .sh)";

## @brief   Logic Functions that make it slightly easier to code in Bash.
## @example if is_not_exists $NORMAL; then 
##               --<code>-- 
##             fi;
function is_empty {
  if [[ -z "$1" ]]; then
    return 0
  fi
  return 1
}
function is_not_empty {
  if [[ -n "$1" ]]; then
    return 0
  fi
  return 1
}
function is_exists {
  if [[ -e "$1" ]]; then
    return 0
  fi
  return 1
}
function is_not_exists {
  if [[ ! -e "$1" ]]; then
    return 0
  fi
  return 1
}

## @brief   Cutesy display functions for sexy output logs.
## @example GOOD_WOLF "Things finsihed"
function GOOD_WOLF {
  echo "${GOODSTRING} ${*}";
  echo "";
  return 1;
}
function BAD_WOLF {
  echo "${BADSTRING} ${*}";
  echo "";
	return 0;
}
function WOLFSPEAK {
  echo "${INFOSTRING} ${*}";
}

# If $1 is set and equals 1 assume its in debug mode and print function.
if is_not_empty $1 && [[ "$1" -eq "1" ]]; then
	DEBUG="true";
fi

## Change if Mage variables have been loaded. Simple check very fragile.
## @TODO : improve the Mage system check function.
if is_not_exists $NORMAL; then
	if tput setaf 1 &> /dev/null; then
		GOODSTRING="$(tput bold)$(tput setaf 15)$(tput setab 10)[ OK ]$(tput sgr0)"
		BADSTRING="$(tput bold)$(tput setaf 15)$(tput setab 9)[FAIL]$(tput sgr0)"
		INFOSTRING="$(tput bold)$(tput setaf 15)$(tput setab 12)[INFO]$(tput sgr0)"
		BRED="$(tput setaf 9)"        # Red
		BGRN="$(tput setaf 10)"       # Green
		BBLU="$(tput setaf 12)"       # Blue
		NORMAL="$(tput sgr0)" 
	else
		GOODSTRING="\e[1m\e[1;47m\e[1;42m[ OK ]\e[0m"
		BADSTRING="\e[1m\e[1;41m\e[47m[FAIL]\e[0m "
		INFOSTRING="\e[1m\e[1;44m\e[47m[INFO]\e[0m"
		BRED="\e[1;31m";               # Red
		BGRN="\e[1;32m";               # Green
		BBLU="\e[1;34m";               # Blue
		NORMAL="\e[0m";
	fi
fi



LINEBREAKER="...............................................................................";

function TermColorDebug {
	for code in {30..37}; do \
		echo -en "\t\e[${code}m"'\\e['"$code"'m'"\e[0m"; \
		echo -en "\t  \e[$code;1m"'\\e['"$code"';1m'"\e[0m"; \
		echo -en "\t  \e[$code;3m"'\\e['"$code"';3m'"\e[0m"; \
		echo -en "\t  \e[1;4"$code"'\\e[1;40\e[1;4"$code"m"; \
		echo -e "\e[$((code+60))m"'\\e['"$((code+60))"'m'"\e[0m"; \
	done
}

if [[ "$DEBUG" -eq "true" ]]; then
	echo "";
  echo "${BRED}   ______              __   __           ______         __                     ";
  echo "${BYLW}  |   __ \.----.-----.|  |_|  |_.--.--. |      |.-----.|  |.-----.----.-----.  ";
  echo "${BGRN}  |    __/|   _|  -__||   _|   _|  |  | |   ---||  _  ||  ||  _  |   _|__ --|  ";
  echo "${BBLU}  |___|   |__| |_____||____|____|___  | |______||_____||__||_____|__| |_____|  ";
  echo "${BPUR}                                |_____|                                        ";
	echo -n "${NORMAL}";
	echo $LINEBREAKER;
	echo "";
	TermColorDebug ;
	echo ""
	echo $LINEBREAKER;
	echo "";
fi