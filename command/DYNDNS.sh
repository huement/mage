#!/usr/bin/env bash

# ------------------ ---------  ------   ----    ---     --      -
#   dyndns.sh
# ------------------ ---------  ------   ----    ---     --      -
# TITLE:    dyndns.sh
# DETAILS:  LaunchD for Dynamic DNS
# AUTHOR:   derek@huement.com
# VERSION:  0.0.1
# DATE:     05.20.2018

## EXAMPLE:  dyndns -l [command_1]
## OPTIONS:  
#/    --help    : Display this help message  
#/    --version : Output program version  



# ------------------ ---------  ------   ----    ---     --      -
#   MENU MAKER
# ------------------ ---------  ------   ----    ---     --      -
source /Volumes/FloppyDisk/Code/Mage/.mage/coat.sh

export COLS="$(tput cols)"

if [ "$(tput cols)" -lt "120" ]; then
	COLUMNS=120
	COLS=120
fi

# COLOR SETUP
if tput setaf 1&>/dev/null;then BLK="$(tput setaf 8)";RED="$(tput setaf 9)";GRN="$(tput setaf 10)";YLW="$(tput setaf 11)";BLU="$(tput setaf 12)";PUR="$(tput setaf 13)";CYN="$(tput setaf 14)";WHT="$(tput setaf 15)";B_BLK="$(tput setab 8)";B_RED="$(tput setab 124)";B_GRN="$(tput setab 10)";B_YLW="$(tput setab 11)";B_BLU="$(tput setab 12)";B_PUR="$(tput setab 13)";B_CYN="$(tput setab 14)";NORMAL="$(tput sgr0)";BOLD="$(tput bold)";else BLK="\e[1;30m";RED="\e[1;31m";GRN="\e[1;32m";YLW="\e[1;33m";BLU="\e[1;34m";PUR="\e[1;35m";CYN="\e[1;36m";WHT="\e[1;37m";B_BLK="\e[40m";B_RED="\e[41m";B_GRN="\e[42m";B_YLW="\e[43m";B_BLU="\e[44m";B_PUR="\e[45m";B_CYN="\e[46m";B_WHT="\e[47m";NORMAL="\e[0m";BOLD="\e[1m";fi;


# ------------------ ---------  ------   ----    ---     --      -
#   BASE VARIABLES
# ------------------ ---------  ------   ----    ---     --      -
SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTNAME=$(basename $0)
SCRIPTBASENAME="$(basename ${SCRIPTNAME} .sh)"

VERSION="0.0.1";
TITLE="DynDNS";
RAR=false;

# ------------------ ---------  ------   ----    ---     --      -
#   OUTPUT HEADERS & LOGGING
# ------------------ ---------  ------   ----    ---     --      -
readonly LOG_FILE="/tmp/${SCRIPTNAME}.log"
info()    { echo " ${BOLD}${WHT}${B_BLU}[INFO]${NORMAL}${BLU} ➜${NORMAL}  $@" | tee -a "$LOG_FILE" >&2 ; }
success() { echo " ${BOLD}${WHT}${B_GRN}[ OK ]${NORMAL}${GRN} ✔${NORMAL}  $@" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo " ${BOLD}${WHT}${B_YLW}[WARN]${NORMAL}${YLW} ➜${NORMAL}  $@" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo " ${BOLD}${WHT}${B_RED}[FAIL]${NORMAL}${RED} ✖${NORMAL}  $@" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo " ${BOLD}${WHT}${B_RED}[DIE!]${NORMAL}${RED} ✖${NORMAL}  $@" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

function e_header() {
  printf "\n${BPUR}==========  %s  ==========${NORMAL}\n" "$@"
}
function e_arrow() {
  printf "➜ $@\n"
}
function e_success() {
  printf "${GRN}✔ %s${NORMAL}\n" "$@"
}
function e_error() {
  printf "${RED}✖ %s${NORMAL}\n" "$@"
}
function e_warning() {
  printf "${YLW}➜ %s${NORMAL}\n" "$@"
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


## READS FROM THE COMMENTS AT THE TOP OF THE FILE
usage() { grep '^# DETAILS:' "$0"; echo ""; exit 0 ; }
version() { grep '^# VERSION:' "$0"; echo ""; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage
expr "$*" : ".*--version" > /dev/null && version


# ------------------ ---------  ------   ----    ---     --      -
#   SCRIPT CORE
# ------------------ ---------  ------   ----    ---     --      -
function header {
	echo "${BGRN}                     
  _____               _____  _______ _______ 
 |     \.--.--.-----.|     \|    |  |     __|
 |  --  |  |  |     ||  --  |       |__     |
 |_____/|___  |__|__||_____/|__|____|_______|
        |_____|
				"
				
	echo "${NORMAL}${B_BLU}                                 ${BLK}VER: ${WHT}${VERSION}  ${NORMAL}"
	
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

function optList {
	echo "${BGRN}list [l] command passed${NORMAL}";
	exit 1;
}

function optX {
	echo "${BBLU}Xtreme [x] command passed${NORMAL}";
	exit 1;
}

function logicUnknown {
  printf "${B_RED}[FAIL]${NORMAL} You made an unknown request.\nGet it together!${NORMAL}\n";
	exit 1;
}

function mainScript {
  ############## Begin Script Here ###################
  ####################################################
  # If no params (argument array 0 is null)
  if [[ -z ${args[0]} ]] ; then
    header
    usage
		echo ""
    return ;
  fi

  # otherwise lets see what we have to do.
	# Read the options and set stuff
	while [[ ${args[0]} = -?* ]]; do
	  case $1 in
	    -h|--help) usage >&2; safeExit ;;
	    --version) echo "$(basename $0) ${version}"; safeExit ;;
	    -v|--verbose) verbose=1 ;;
	    -l|--log) printLog=1 ;;
	    -q|--quiet) quiet=1 ;;
	    -d|--debug) debug=1;;
	    --force) force=1 ;;
	    --endopts) shift; break ;;
			*) checkDNS; shift; break ;;
	  esac
	  shift
	done

  
  ####################################################
  ############### End Script Here ####################
}

# Define a timestamp function
function timestamp {
  date +"%Y-%m-%d_%H"
}

function checkDNS {
	echo "";
	echo "  [ IP ADDRESS DETAILS ]";
	ruleln 
	
	timest=$(dig +short myip.opendns.com @resolver1.opendns.com);
	
	info "CURRENT: ${timest}";
	
	if is_file ./saved_ip.txt; then
		
		value=$(<./saved_ip.txt);
		
		info "  SAVED: ${value}";
		
		echo " ";
		
		if [ $value == $timest ]; then
			success "SAME IP. NO NEED TO UPDATE!";
			echo "";
		else
			warning "IP ADDRESS MISMATCH. NEED TO UPDATE!";
			
			UPDATEAFRAID
		fi
		
		#echo "$timest" > ./saved_ip.txt;
		
	else
		echo "CREATE PUBLIC IP FILE.... " && echo "";
		echo "$timest" > ./saved_ip.txt;
	fi
	
}

function UPDATEAFRAID {
	apikeyfile="/Users/eve/.afraid-dyndns.dynkey"

	echo "";
	info "Updating Afraid.org DNS";

	while read line; do
		URL="https://freedns.afraid.org/dynamic/update.php?${line}"
		# store the whole response with the status at the and
		HTTP_RESPONSE=$(curl --silent --write-out "HTTPSTATUS:%{http_code}" -X POST $URL)
		# extract the body
		HTTP_BODY=$(echo $HTTP_RESPONSE | sed -e 's/HTTPSTATUS\:.*//g')
		# extract the status
		HTTP_STATUS=$(echo $HTTP_RESPONSE | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
	
		# print the body
		#echo "$HTTP_BODY"
		#echo "$HTTP_STATUS"
	

		# example using the status
		if [ ! $HTTP_STATUS -eq 200  ]; then
		  error "Error [HTTP status: $HTTP_STATUS]"
		  exit 1
		fi
	done <"$apikeyfile"

	echo ""
	success "FINISHED IP UPDATE!";
	echo "";
	echo "";
}


# ------------------ ---------  ------   ----    ---     --      -
#   LOGIC FUNCTIONS
# ------------------ ---------  ------   ----    ---     --      -

# File Checks
# ------------------------------------------------------
# A series of functions which make checks against the filesystem. For
# use in if/then statements.
#
# Usage:
#    if is_file "file"; then
#       ...
#    fi
# ------------------------------------------------------

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

function is_file {
  if [[ -f "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_file {
  if [[ ! -f "$1" ]]; then
    return 0
  fi
  return 1
}

function is_dir {
  if [[ -d "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_dir {
  if [[ ! -d "$1" ]]; then
    return 0
  fi
  return 1
}

function is_symlink {
  if [[ -L "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_symlink {
  if [[ ! -L "$1" ]]; then
    return 0
  fi
  return 1
}

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


# Build Path
# -----------------------------------
# DESC: Combines two path variables and removes any duplicates
# ARGS: $1 (required): Path(s) to join with the second argument
#       $2 (optional): Path(s) to join with the first argument
# OUTS: $build_path: The constructed path
# NOTE: Heavily inspired by: https://unix.stackexchange.com/a/40973
# -----------------------------------
function build_path {
    if [[ -z ${1-} || $# -gt 2 ]]; then
        script_exit "Invalid arguments passed to build_path()!" 2
    fi

    local new_path path_entry temp_path

    temp_path="$1:"
    if [[ -n ${2-} ]]; then
        temp_path="$temp_path$2:"
    fi

    new_path=
    while [[ -n $temp_path ]]; do
        path_entry="${temp_path%%:*}"
        case "$new_path:" in
            *:"$path_entry":*) ;;
                            *) new_path="$new_path:$path_entry"
                               ;;
        esac
        temp_path="${temp_path#*:}"
    done

    # shellcheck disable=SC2034
    build_path="${new_path#:}"
}


# Check Binary
# -----------------------------------
# DESC: Check a binary exists in the search path
# ARGS: $1 (required): Name of the binary to test for existence
#       $2 (optional): Set to any value to treat failure as a fatal error
# -----------------------------------
function check_binary {
    if [[ $# -ne 1 && $# -ne 2 ]]; then
        script_exit "Invalid arguments passed to check_binary()!" 2
    fi

    if ! command -v "$1" > /dev/null 2>&1; then
        if [[ -n ${2-} ]]; then
            script_exit "Missing dependency: Couldn't locate $1." 1
        else
            verbose_print "Missing dependency: $1" "${fg_red-}"
            return 1
        fi
    fi

    verbose_print "Found dependency: $1"
    return 0
}


# Check Super User
# -----------------------------------
# DESC: Validate we have superuser access as root (via sudo if requested)
# ARGS: $1 (optional): Set to any value to not attempt root access via sudo
# -----------------------------------
function check_superuser {
    if [[ $# -gt 1 ]]; then
        script_exit "Invalid arguments passed to check_superuser()!" 2
    fi

    local superuser test_euid
    if [[ $EUID -eq 0 ]]; then
        superuser="true"
    elif [[ -z ${1-} ]]; then
        if check_binary sudo; then
            pretty_print "Sudo: Updating cached credentials for future use..."
            if ! sudo -v; then
                verbose_print "Sudo: Couldn't acquire credentials..." \
                              "${fg_red-}"
            else
                test_euid="$(sudo -H -- "$BASH" -c 'printf "%s" "$EUID"')"
                if [[ $test_euid -eq 0 ]]; then
                    superuser="true"
                fi
            fi
        fi
    fi

    if [[ -z $superuser ]]; then
        verbose_print "Unable to acquire superuser credentials." "${fg_red-}"
        return 1
    fi

    verbose_print "Successfully acquired superuser credentials."
    return 0
}


# Run Script as Root
# -----------------------------------
# DESC: Run the requested command as root (via sudo if requested)
# ARGS: $1 (optional): Set to zero to not attempt execution via sudo
#       $@ (required): Passed through for execution as root user
# -----------------------------------
function run_as_root {
    local try_sudo
    if [[ ${1-} =~ ^0$ ]]; then
        try_sudo="true"
				mainScript
        shift
    fi

    if [[ $# -eq 0 ]]; then
        script_exit "Invalid arguments passed to run_as_root()!" 2
    fi

    if [[ $EUID -eq 0 ]]; then
        "$@"
    elif [[ -z ${try_sudo-} ]]; then
        sudo -H -- "$@"
    else
        script_exit "Unable to run requested command as root: $*" 1
    fi
}


# Iterate over options breaking -ab into -a -b when needed and --foo=bar into
# --foo bar

optstring=h
unset options
while (($#)); do
  case $1 in
    # If option is of type -ab
    -[!-]?*)
      # Loop over each character starting with the second
      for ((i=1; i < ${#1}; i++)); do
        c=${1:i:1}

        # Add current char to options
        options+=("-$c")

        # If option takes a required argument, and it's not the last char make
        # the rest of the string its argument
        if [[ $optstring = *"$c:"* && ${1:i+1} ]]; then
          options+=("${1:i+1}")
          break
        fi
      done
    ;;

    # If option is of type --foo=bar
    --?*=*) options+=("${1%%=*}" "${1#*=}") ;;
    # add --endopts for --
    --) options+=(--endopts) ;;
    # Otherwise, nothing special
    *) options+=("$1") ;;
  esac
  shift
done
set -- "${options[@]}"
unset options

# Print help if no arguments were passed.
# Uncomment to force arguments when invoking the script
# [[ $# -eq 0 ]] && set -- "--help"



# Store the remaining part as arguments.
args+=("$@")


if [ $RAR == true ]; then 
	run_as_root
else
	mainScript
fi

