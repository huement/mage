#!/usr/bin/env bash

# Main function
# -----------------------------------
# This handles the start up logic and processes any params.
# Basically this is where shit goes down.
# -----------------------------------
mageCMD=1;

#
# Logic functions
#   What the script ends up doing after passing setup checks
#   Heavily dependent on what parameters have been passed
#
source $scriptPath/.mage/coat.sh;


# Infobot
# -----------------------------------
# Load and run user configured info files. Quickly Display
# documentation, snippets, or any other frequently forgotten data.
# -----------------------------------
function logicInfo {
  if [ -z ${args[1]} ] ; then
    header_sm
    logicInfoCat
    return ;
  else
    if is_file "${dataLocation}/${args[1]}.sh" ; then
      source "${dataLocation}/${args[1]}.sh";
    	DisplayInfo
      echo ""
      safeExit;
    else
      die "Error! Topic not found" "Requested file not found.";
    fi
  fi
}

function logicInfoCat {
  # create an array with all the filer/dir inside ~/myDir
  arrF=("${dataLocation}"/*)
  # iterate through array using a counter
  printf "${B_WHT}${BBLK} INFO TOPICS ${NORMAL}            ${BCYN}cmd| ${BOLD}${scriptName} info ${NORMAL}${BCYN}<option>${NORMAL}"
  echo -e "\n"
  iREAL=0;
  for ((i=0; i<${#arrF[@]}; i++)); do
      #do something to each element of array
      lname=$(basename "${arrF[$i]}" .sh);
      if [ "$lname" != "_list.md" ] && [ "$lname" != "sample" ]; then
        nNum=$(( i + 1 ));
        iREAL=$(( iREAL + 1 ));
        echo "  $iREAL|  ${BGRN}${lname}${NORMAL}";
      fi
  done
  unset lname;

  echo -e "\n\n${NORMAL}"
}


# LOGIC ERROR HANDLER
function logicUnknown {
  echo -e "${B_RED}[FAIL]${NORMAL} You made an unknown request.\nGet it together, and try ${BBLU}mage --help${NORMAL} and choose an available command.\n";
	usage
	die "exiting..."
}

# LOGIC ERROR HANDLER
function nothingError {
  die "${BRED}No task given." "${scriptName} ${scriptName} <command> <param1,param2,...>";
}

# HELP MENU
# -----------------------------------
# This displays the script functions currently available as well as
# any options for debugging or other runtime mods
# -----------------------------------
function usage {
echo "${GRN}COMMANDS        ${scriptName} <command> <param1,param2,...>
${YLW}--------------------------------------------------------------------------
${BLU}list${WHT}            Info dump. If no param dump categories. Be specific!
${BLU}sync${WHT}            Dotfile functions. (requires param)
${YLW} + backup${WHT}       Backup ${USER}/dotfiles
${YLW} + restore${WHT}      Restore saved dotfiles
${YLW} + swap${WHT}         Quickly toggle dotfiles in and out.
${BLU}run${WHT}             Execute a given user script. (requires param)
${BLU}update${WHT}          Update packages and scripts"
echo -e "\n\n"
}

function usagemods {
echo "${CYN}MODIFIERS
${BYLW}--------------------------------------------------------------------------
${BCYN}--force${BWHT}         Skip all user interaction.  Implied 'Yes' to all actions.
${BCYN}-q, --quiet${BWHT}     Quiet (no output)
${BCYN}-l, --log${BWHT}       Print log to file
${BCYN}-v, --verbose${BWHT}   Output more information. (Items echoed to 'verbose')
${BCYN}-d, --debug${BWHT}     Runs script in BASH debug mode (set -x)
${BPUR}-h, --help${BWHT}      Display this help and exit
${BPUR}--version${BWHT}       Output version information and exit"
echo "${NORMAL}"
}


#
# Mage Menu
#   Functions used to generate the "UI" for the Mage Script
#

function header {
		echo ""
    echo "                                                                 ${RED}${B_WHT}[${BLK}${vMage}${RED}]${NORMAL}${BBLU}"
    cat "${mageDir}/trunk/ascii/art/mage.txt"
		echo "${NORMAL}";
}

function header_sm {
    printf "${BRED}";
    cat "${mageDir}/trunk/ascii/art/mage_sm.txt";
    echo "${NORMAL}";
}

## Print a horizontal rule
## @param $1 default line break char. ie: -
function ruleln {
  printf -v _hr "%*s" "$(tput cols)" && echo "${_hr// /${1--}}"
}

## Print horizontal ruler with message
## @param $1 message we are going to display
## @param $2 default line break char. ie: -
function rulemsg {
  if [ "$#" -eq 0 ]; then
    echo "Usage: rulemsg MESSAGE [RULE_CHARACTER]"
    return 1
  fi

  # Store Cursor.
  # Fill line with ruler character ($2, default "-")
  # Reset cursor
  # move 10 cols right, print message

  tput sc # save cursor
  printf -v _hr "%*s" "$(tput cols)" && echo -e "${PUR}" && echo -en ${_hr// /${2--}} && echo -en "\r\033[2C"
  tput rc;

  echo -en "\r\033[10C" && echo -e "${BRED} [ ${BBLU}$1${BRED} ]" # 10 space in

  echo "${NORMAL}"; # now we break
  echo " ";
}

## Print single line comment
## @param $1 title or topic of comment
## @param $2 message we are going to display
function simpleprint {
  printf "%-30s %s  %60s\n" "${YLW}$1" "   " "${CYN}$2${NORMAL}";
}

## Clear some space
function linebreak {
  echo -e "\n\n\n";
}

## Stauts Messages
function _alert {
  if [ "${1}" = "emergency" ]; then
    local color="${BOLD}${BRED}"
  fi
  if [ "${1}" = "error" ]; then local color="${BOLD}${RED}"; fi
  if [ "${1}" = "warning" ]; then local color="${RED}"; fi
  if [ "${1}" = "success" ]; then local color="${GRN}"; fi
  if [ "${1}" = "debug" ]; then local color="${PUR}"; fi
  if [ "${1}" = "header" ]; then local color="${BOLD}""${BLU}"; fi
  if [ "${1}" = "input" ]; then local color="${BOLD}"; printLog="false"; fi
  if [ "${1}" = "info" ] || [ "${1}" = "notice" ]; then local color=""; fi
  # Don't use colors on pipes or non-recognized terminals
  if [[ "${TERM}" != "xterm"* ]] || [ -t 1 ]; then color=""; reset=""; fi

  # Print to $logFile
  if [[ ${printLog} = "true" ]] || [ "${printLog}" == "1" ]; then
    echo -e "$(date +"%m-%d-%Y %r") $(printf "[%9s]" "${1}") ${_message}" >> "${logFile}";
  fi

  # Print to console when script is not 'quiet'
  if [[ "${quiet}" = "true" ]] || [ "${quiet}" == "1" ]; then
    return
  else
    echo -e "$(date +"%r") ${color}$(printf "[%9s]" "${1}") ${_message}";
    echo -e "${BBRED}${2}${NORMAL}";
  fi

}
function die { BAD_WOLF "${*} FATAL ERROR. EXITING"; safeExit; }
function error { BAD_WOLF $*; safeExit; }
function info { WOLFSPEAK "INFO ${*}"; }
function success { GOOD_WOLF "${*} SUCCESS"; }

# Log messages when verbose is set to "true"
function verbose {
  if [[ "${verbose}" = "true" ]] || [ "${verbose}" == "1" ]; then
    debug "$@"
  fi
}

# Exit Script
# -----------------------------------
# Non destructive exit for when script exits naturally.
# Usage: Add this function at the end of every script
# -----------------------------------
function safeExit {
  # Delete temp files, if any
  if is_dir "${tmpDir}"; then
    rm -r "${tmpDir}"
  fi
  trap - INT TERM EXIT
  exit
}

# trapCleanup Function
# -----------------------------------
# Any actions that should be taken if the script is prematurely
# exited.  Always call this function at the top of your script.
# -----------------------------------
function trapCleanup {
  echo ""
  if is_dir "${tmpDir}"; then
    rm -r "${tmpDir}"
  fi
  die "Exit trapped."  # Edit this if you like.
}

#
# Traps
#   Functions used with different trap scenarios
#

# Pretty Print
# -----------------------------------
# ARGS: $1 (required): Message to print (defaults to a green foreground)
#       $2 (optional): Colour to print the message with. This can be an ANSI
#                      escape code or one of the prepopulated colour variables.
# -----------------------------------
function pretty_print {
  if [[ $# -eq 0 || $# -gt 2 ]]; then
    script_exit "Invalid arguments passed to pretty_print()!" 2
  fi

  if [[ -z ${NORMAL-} ]]; then
    if [[ $# -eq 2 ]]; then
      printf '%b' "$2"
    else
      printf '%b' "$GRN"
    fi
  fi

  # Print message & reset text attributes
  printf '%s%b\n' "$1" "$NORMAL"
}


# Debug Print
# -----------------------------------
# DESC: Only pretty_print() the provided string if verbose mode is enabled
# ARGS: $@ (required): Passed through to pretty_pretty() function
# -----------------------------------
function verbose_print {
  if [[ -n ${verbose-} ]]; then
    pretty_print "$@"
  fi
}

function array_print {
  echo "ARRAY: $1";
  echo "VALUE: $2";
}

function mainScript {
  ############## Begin Script Here ###################
  ####################################################

  # If no params (argument array 0 is null)
  if [ -z ${args[0]} ] ; then
    header
    usage
    return ;
  fi

  # otherwise lets see what we have to do.
  echo ""
  case ${args[0]} in
    l|list) logicInfo ;;
    m|motd) logicDisplay ;;
    a|adapt) logicRun ;;
    j|jump) logicJump ;;
    n|new) logicNew ;;
    u|update) logicUpdate ;;
		x|xmenu) usagemods ;;
    *) logicUnknown ;;
  esac

  ####################################################
  ############### End Script Here ####################
}
