#!/usr/bin/env bash

##########################################
#	888b     d888                          #
#	8888b   d8888                          #
#	88888b.d88888                          #
#	888Y88888P888 8888b.  .d88b.  .d88b.   #
#	888 Y888P 888    "88bd88P"88bd8P  Y8b  #
#	888  Y8P  888.d888888888  88888888888  #
#	888   "   888888  888Y88b 888Y8b.      #
#	888       888"Y888888 "Y88888 "Y8888   #
#	                          888          #
#	                     Y8b d88P          #
#	                      "Y88P" 					 #
##########################################

vMage="0.1.0";

# Optparse - a BASH wrapper for getopts
# https://github.com/nk412/optparse

# Copyright (c) 2015 Nagarjuna Kumarappan
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Author: Nagarjuna Kumarappan <nagarjuna.412@gmail.com>

optparse_usage=""
optparse_contractions=""
optparse_defaults=""
optparse_process=""
optparse_arguments_string=""

# -----------------------------------------------------------------------------------------------------------------------------
function optparse.throw_error(){
  local message="$1"
        echo "OPTPARSE: ERROR: $message"
        exit 1
}

# -----------------------------------------------------------------------------------------------------------------------------
function optparse.define(){
        if [ $# -lt 3 ]; then
                optparse.throw_error "optparse.define <short> <long> <variable> [<desc>] [<default>] [<value>]"
        fi
        for option_id in $( seq 1 $# ) ; do
                local option="$( eval "echo \$$option_id")"
                local key="$( echo $option | awk -F "=" '{print $1}' )";
                local value="$( echo $option | awk -F "=" '{print $2}' )";

                #essentials: shortname, longname, description
                if [ "$key" = "short" ]; then
                        local shortname="$value"
                        if [ ${#shortname} -ne 1 ]; then
                                optparse.throw_error "short name expected to be one character long"
                        fi
                        local short="-${shortname}"
                elif [ "$key" = "long" ]; then
                        local longname="$value"
                        if [ ${#longname} -lt 2 ]; then
                                optparse.throw_error "long name expected to be atleast one character long"
                        fi
                        local long="--${longname}"
                elif [ "$key" = "desc" ]; then
                        local desc="$value"
                elif [ "$key" = "default" ]; then
                        local default="$value"
                elif [ "$key" = "variable" ]; then
                        local variable="$value"
                elif [ "$key" = "value" ]; then
                        local val="$value"
                fi
        done

        if [ "$variable" = "" ]; then
                optparse.throw_error "You must give a variable for option: ($short/$long)"
        fi

        if [ "$val" = "" ]; then
                val="\$OPTARG"
        fi

        # build OPTIONS and help
		optparse_usage="${optparse_usage}#NL#TB${short} $(printf "%-25s %s" "${long}:" "${desc}")"
        if [ "$default" != "" ]; then
                optparse_usage="${optparse_usage} [default:$default]"
        fi
        optparse_contractions="${optparse_contractions}#NL#TB#TB${long})#NL#TB#TB#TBparams=\"\$params ${short}\";;"
        if [ "$default" != "" ]; then
                optparse_defaults="${optparse_defaults}#NL${variable}=${default}"
        fi
        optparse_arguments_string="${optparse_arguments_string}${shortname}"
        if [ "$val" = "\$OPTARG" ]; then
                optparse_arguments_string="${optparse_arguments_string}:"
        fi
        optparse_process="${optparse_process}#NL#TB#TB${shortname})#NL#TB#TB#TB${variable}=\"$val\";;"
}

# -----------------------------------------------------------------------------------------------------------------------------
function optparse.build(){
        local build_file="/tmp/optparse-${RANDOM}.tmp"

        # Building getopts header here

        # Function usage
        cat << EOF > $build_file
function usage(){
cat << XXX
usage: \$0 [OPTIONS]

OPTIONS:
        $optparse_usage

        -? --help  :  usage

XXX
}

# Contract long options into short options
params=""
while [ \$# -ne 0 ]; do
        param="\$1"
        shift

        case "\$param" in
                $optparse_contractions
                "-?"|--help)
                        usage
                        exit 0;;
                *)
                        if [[ "\$param" == --* ]]; then
                                echo -e "Unrecognized long option: \$param"
                                usage
                                exit 1
                        fi
                        params="\$params \"\$param\"";;
        esac
done

eval set -- "\$params"

# Set default variable values
$optparse_defaults

# Process using getopts
while getopts "$optparse_arguments_string" option; do
        case \$option in
                # Substitute actions for different variables
                $optparse_process
                :)
                        echo "Option - \$OPTARG requires an argument"
                        exit 1;;
                *)
                        usage
                        exit 1;;
        esac
done

# Clean up after self
rm $build_file

EOF

        local -A o=( ['#NL']='\n' ['#TB']='\t' )

        for i in "${!o[@]}"; do
                sed -i "s/${i}/${o[$i]}/g" $build_file
        done

        # Unset global variables
        unset optparse_usage
        unset optparse_process
        unset optparse_arguments_string
        unset optparse_defaults
        unset optparse_contractions

        # Return file name to parent
        echo "$build_file"
}
# -----------------------------------------------------------------------------------------------------------------------------
#!/usr/bin/env bash

# Mage : Bash Wizardary
# -----------------------------------
# Attempt to tie together numerous Shell use cases
# Part remember what you forgot. Part automate the boring.
# -----------------------------------

mageHome=$HOME;

# Script Configuration
# -----------------------------------
# Flags which can be overridden by user input.
# Default values are below
# -----------------------------------
if [ -n "${optparse_usage+1}" ]; then
  OPTIONPARSER=true;
else
  source optparse.bash
fi


quiet=false
printLog=false
verbose=false
force=false
strict=false
#debug=true
args=()

optparse_usage=""
optparse_contractions=""
optparse_defaults=""
optparse_process=""
optparse_arguments_string=""


# UI Feedback Alerts
# -----------------------------------
function GOOD_WOLF {
  if tput setaf 1 &> /dev/null; then
    echo "$(tput bold)$(tput setaf 15)$(tput setab 10)[ OK ]$(tput sgr0)  $1";
  else
    echo "\e[1m\e[1;47m\e[1;42m[ OK ]\e[0m  $1";
  fi

  echo "";
  return 1;
}

function BAD_WOLF {
  echo "";
  if tput setaf 1 &> /dev/null; then
    echo "$(tput bold)$(tput setaf 15)$(tput setab 9)[FAIL]$(tput sgr0)  ${*}";
  else
    echo "\e[1m\e[1;41m\e[47m[FAIL]\e[0m  ${*}";
  fi

  echo "";
  return 0;
}

function WOLFSPEAK {
  if tput setaf 1 &> /dev/null; then
    wmsg="$(tput bold)$(tput setaf 15)$(tput setab 12)[LOAD]$(tput sgr0)  $1";
  else
    wmsg="\e[1m\e[1;44m\e[47m[LOAD]\e[0m  $1";
  fi

  echo $wmsg;
}

# Script Variables
# -----------------------------------
# Mumford finds his place in the world
# Custom data is stored in ~/.mumford by default
# -----------------------------------
scriptPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
scriptName=$(basename $0)                      # Set Script Name variable
scriptBasename="$(basename ${scriptName} .sh)" # Strips '.sh' from scriptName


# Config.json
# -----------------------------------
# Pull directory layout from config file, among other things
# -----------------------------------
CFILE="${mageHome}/Mage/config.json";

if [[ ! -f "$CFILE" ]]; then
  CSFILE="${mageHome}/Mage/trunk/install/config.sample.json";
  if [[ -f "$CSFILE" ]]; then
    GOOD_WOLF "Loading Config Template | $CSFILE";
    cp $CSFILE "${mageHome}/Mage/config.json";
  else
    BAD_WOLF "Config File $CFILE missing."
    BAD_WOLF "Config Template $CSFILE missing."
    BAD_WOLF "Exiting . . . :("
    exit 1
  fi;
fi

dotsDir=$(jq -r ".folders.dotsDir" <<< cat "${mageHome}/Mage/config.json");
infoDir=$(jq -r ".folders.infoDir" <<< cat "${mageHome}/Mage/config.json");
codeDir=$(jq -r ".folders.codeDir" <<< cat "${mageHome}/Mage/config.json");
baseDir=$(jq -r ".folders.baseDir" <<< cat "${mageHome}/Mage/config.json");

mageDir="/Users/${USER}/${baseDir}"
dataLocation="${mageDir}/${infoDir}"

bashLib="${mageDir}/.mage/logical.sh";
themeLocation="${mageDir}/.mage/coat.sh";
utilsLocation="${mageDir}/.mage/spellcast.sh";
mageCore="${mageDir}/.mage/maintence.sh";


# Library File Loading
# -----------------------------------
# Check for existence of and load all required library files.
# -----------------------------------
function LoadUserInfo {
  if is_dir $dataLocation; then
    # create an array with all info files
    shopt -s nullglob
    infoPages=("${dataLocation}"/*.sh)
    if [[ -n "${debug}" ]]; then GOOD_WOLF "User directory ${dataLocation} Successfully loaded."; fi;
  else
    BAD_WOLF "Folder ${dataLocation} missing. Exiting..."
    echo -e "This folder contains any \'.sh\' informational files. \nTypically Snippets, Reminders, Short-cuts, Alias searching etc.";
    echo -e "\nBy default this is ${mageDir}/spells/divine and should have been installed. \n\n Run Command: mkdir ${mageDir}/spells/divine \n\nOr update ${mageDir}/config.json to a valid directory.";
    echo ""
    exit 1
  fi
}

function liberMage {
  if [[ -f "$1" ]]; then
    source $1
    if [[ -n "${debug}" ]]; then GOOD_WOLF "Library File $1 Successfully loaded."; fi;
  else
    BAD_WOLF "Library File $1 missing. Exiting..."
    exit 1
  fi
}

# LOAD WOLF LIBRARY scripts
# -----------------------------------
# These are required for Wolf and need to be loaded in correct order.
# However, they are only loaded if we are in developer mode. As a binary we dont load these.
# -----------------------------------
# Loads bashLib, themeLocation, utilsLocation, mageCore
function mageLibLoader {
	if [[ -z "$mageSimple" ]]; then
	  if [[ -n "${debug}" ]]; then WOLFSPEAK $bashLib; fi;
	  liberMage $bashLib;
	fi

	if [[ -z "$BRED" ]]; then
	  if [[ -n "${debug}" ]]; then WOLFSPEAK $themeLocation; fi;
	  liberMage $themeLocation;
	fi

	if [[ -z "$mageCMD" ]]; then
	  if [[ -n "${debug}" ]]; then WOLFSPEAK $utilsLocation; fi;
	  liberMage $utilsLocation;
	fi

	if [[ -z "$mageMaintence" ]]; then
	  if [[ -n "${debug}" ]]; then WOLFSPEAK $mageCore; fi;
	  liberMage $mageCore;
	fi

	# USER dataLocation
	# -----------------------------------
	# This is loaded no matter what and always from the users home directory
	# -----------------------------------
	if [[ -n "${debug}" ]]; then WOLFSPEAK $dataLocation; fi;
	LoadUserInfo $dataLocation;
}


############## Begin Options and Usage ###################

mageLibLoader


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

# Read the options and set stuff
while [[ $1 = -?* ]]; do
  case $1 in
    -h|--help) usage >&2; safeExit ;;
    --version) echo "$(basename $0) ${version}"; safeExit ;;
    -v|--verbose) verbose=1 ;;
    -l|--log) printLog=1 ;;
    -q|--quiet) quiet=1 ;;
    -d|--debug) debug=1;;
    --force) force=1 ;;
    --endopts) shift; break ;;
  esac
  shift
done

# Store the remaining part as arguments.
args+=("$@")

############## End Options and Usage ###################




# ############# ############# #############
# ##       TIME TO RUN THE SCRIPT        ##
# ##                                     ##
# ## You shouldn't need to edit anything ##
# ## beneath this line                   ##
# ##                                     ##
# ############# ############# #############

# Trap bad exits with your cleanup function
trap trapCleanup EXIT INT TERM

# Bash will remember & return the highest exitcode in a chain of pipes.
# This way you can catch the error in case mysqldump fails in `mysqldump |gzip`, for example.
set -o pipefail

# Invoke the checkDependenices function to test for Bash packages
#checkDependencies

# Run your script
if is_not_dir "${mageDir}"; then
  checkInstall
else
  mainScript
fi

safeExit # Exit cleanly
#!/usr/bin/env bash

########################[ PROMPT COLOR CODES ]#######################

if tput setaf 1 &> /dev/null; then

	# REGULAR TEXT COLORS
	BLK="$(tput setaf 0)"         # Black
	RED="$(tput setaf 124)"       # Red
	GRN="$(tput setaf 64)"        # Green
	YLW="$(tput setaf 136)"       # Yellow
	BLU="$(tput setaf 33)"        # Blue
	PUR="$(tput setaf 125)"       # Purple
	CYN="$(tput setaf 37)"        # Cyan
	WHT="$(tput setaf 15)"        # White

	# BOLD TEXT COLORS
	BBLK="$(tput setaf 8)"        # Black
	BRED="$(tput setaf 9)"        # Red
	BGRN="$(tput setaf 10)"       # Green
	BYLW="$(tput setaf 11)"       # Yellow
	BBLU="$(tput setaf 12)"       # Blue
	BPUR="$(tput setaf 13)"       # Purple
	BCYN="$(tput setaf 14)"       # Cyan
	BWHT="$(tput setaf 15)"       # White

	# REGULAR BACKGROUND COLORS
	B_BLK="$(tput setab 8)"       # Black
	B_RED="$(tput setab 9)"       # Red
	B_GRN="$(tput setab 10)"      # Green
	B_YLW="$(tput setab 11)"      # Yellow
	B_BLU="$(tput setab 12)"      # Blue
	B_PUR="$(tput setab 13)"      # Purple
	B_CYN="$(tput setab 14)"      # Cyan
	B_WHT="$(tput setab 15)"      # White

	# BOLD BACKGROUND COLORS
	BB_BLK="$(tput setab 8)"      # Black
	BB_RED="$(tput setab 124)"    # Red
	BB_GRN="$(tput setab 10)"     # Green
	BB_YLW="$(tput setab 11)"     # Yellow
	BB_BLU="$(tput setab 12)"     # Blue
	BB_PUR="$(tput setab 13)"     # Purple
	BB_CYN="$(tput setab 14)"     # Cyan

	# COLOR OPTIONS
	NORMAL="$(tput sgr0)"         # Text Reset
	BOLD="$(tput bold)"           # Make Bold
	UNDERLINE="$(tput smul)"      # Underline
	NOUNDER="$(tput rmul)"        # Remove Underline
	BLINK="$(tput blink)"         # Make Blink
	REVERSE="$(tput rev)"         # Reverse

else

	# REGULAR TEXT COLORS
	BLK="\e[1;30m";               # Black
	RED="\e[1;31m";               # Red
	GRN="\e[1;32m";               # Green
	YLW="\e[1;33m";               # Yellow
	BLU="\e[1;34m";               # Blue
	PUR="\e[1;35m";               # Purple
	CYN="\e[1;36m";               # Cyan
	WHT="\e[1;37m";               # White

	# BOLD TEXT COLORS
	BBLK="\e[1;30m";              # Black
	BRED="\e[1;31m";              # Red
	BGRN="\e[1;32m";              # Green
	BYLW="\e[1;33m";              # Yellow
	BBLU="\e[1;34m";              # Blue
	BPUR="\e[1;35m";              # Purple
	BCYN="\e[1;36m";              # Cyan
	BWHT="\e[1;37m";              # White

	# BACKGROUND COLORS
	B_BLK="\e[40m"                # Black
	B_RED="\e[41m"                # Red
	B_GRN="\e[42m"                # Green
	B_YLW="\e[43m"                # Yellow
	B_BLU="\e[44m"                # Blue
	B_PUR="\e[45m"                # Purple
	B_CYN="\e[46m"                # Cyan
	B_WHT="\e[47m"                # White

	# BOLD BACKGROUND
	BB_BLK="\e[1;40m"             # Black
	BB_RED="\e[1;41m"             # Red
	BB_GRN="\e[1;42m"             # Green
	BB_YLW="\e[1;43m"             # Yellow
	BB_BLU="\e[1;44m"             # Blue
	BB_PUR="\e[1;45m"             # Purple
	BB_CYN="\e[1;46m"             # Cyan
	BB_WHT="\e[1;47m"             # White

	# COLOR OPTIONS
	NORMAL="\e[0m"                # Text Reset
	BOLD="\e[1m"                  # Make Bold
	UNDERLINE="\e[4m"             # Underline
	NOUNDER="\e[24m"              # Remove Underline
	BLINK="\e[5m"                 # Make Blink
	NOBLINK="\e[25m"              # NO Blink
	REVERSE="\e[50m"              # Reverse
fi;

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
mageSimple=1;

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
#!/usr/bin/env bash

# INSTALL / UPDATE SCRIPT
# -----------------------------------
# 1. Shell deps
# 2. Homebrew deps
# 3. ${USER} folder
# 4. Wolf
# -----------------------------------
mageMaintence=1

# Install or Upgrade?

# IF NEEDS INSTALL
function checkInstall {
  echo ""
  echo "Required 'Mage' directory not found."
  echo "Installing . . . "
  echo ""

  if is_not_dir "${mageDir}/${infoDir}"; then
    echo "Creating Info directory"
    mkdir -p "${mageDir}/${infoDir}";
  fi

  if is_not_dir "${mageDir}/${codeDir}"; then
    echo "Creating Code directory"
    mkdir -p "${mageDir}/${codeDir}";
  fi

  if is_not_dir "${mageDir}/${dotsDir}"; then
    echo "Creating Dotfiles directory"
    mkdir -p "${mageDir}/${dotsDir}";
  fi

  if is_not_file "${mageDir}/config.json"; then
    generateConfig
  fi

  if is_not_file "${mageDir}/spellbook/list/sample.sh"; then
    generateInfo
  fi

  echo "Setup complete. Please rerun command!"
  echo ""

  safeExit
}

function generateConfig {
  CFILE="${mageDir}/config.json"

/bin/cat <<EOM >$CFILE
{
	"version": "${vMage}",
	"folders": {
		"baseDir":"Mage",
		"dotsDir":"spellbook/sync",
		"infoDir":"spellbook/list",
		"codeDir":""
	},
	"display": {
		"configFile":".chunkwmrc",
		"baseDir": "spellbook/adapt",
		"options": {
			"single": ".chunkwmrc_one",
			"double": ".chunkwmrc_two",
			"triple": ".chunkwmrc_three"
		}
	},
	"script": {
		"core": "mage.sh",
		"custom": "trunk/rebuild.sh"
	}
}
EOM
}

function generateInfo {
  CFILE="${mageDir}/spellbook/list/sample.sh"

/bin/cat <<EOM >$CFILE
#!/bin/bash
echo ""
echo "--------------------------"
echo "SAMPLE FILE"
echo "You could put any helpful commands you need shortcuts for,"
echo "Or any documentation you want sumarized. Such as your unique keyboard shortcuts."
echo "Simply add files into the '~/Mage/Info' directory and they will be automatically loaded"
echo "the next time you run the 'wolf info' command."
echo "--------------------------"
echo ""
EOM
}
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

# Display Manager
# -----------------------------------
# Function that runs when you connect or disconnect a Display input.
# Helpful to swap out config files for your window manager among other things.
# -----------------------------------
function logicDisplay {
  if is_not_empty ${args[1]}; then
    baseDir=$(jq -r '.display.baseDir' <<< cat './config.json');
    configFile=$(jq -r '.display.configFile' <<< cat './config.json');
    mapfile -t displays <<< $(jq -c -r '.display.options[]' ./config.json)
    for i in "${displays[@]}"
    do
       if [ "${args[1]}" == $i ]; then
         echo -n "${WHT}${B_BLU}[MOVE]${NORMAL} ";
         echo "${BBLU}${baseDir}/${i}${NORMAL}";

         $(/bin/cp -rf "${baseDir}/${i}" "${mageHome}/${configFile}");

         if is_file "${mageHome}/${configFile}"; then
          echo "${WHT}${B_GRN}[ OK ]${NORMAL}${BGRN} Display config updated";
        else
          echo "${WHT}${B_RED}[FAIL]${NORMAL}${BRED} File could not be moved";
        fi
        echo "";
       fi
    done
  else
    error "No dotfile option given. Try: mage display <.chunkwmrc_one|.chunkwmrc_two>";
    safeExit;
  fi
}


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
  die "Error! Unknown Request" "Mumford did understand that command.";
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
  echo -n "
${BBLU}COMMANDS       ${BYLW} ${scriptName} <command> <param1,param2,...>
${BRED}--------------------------------------------------------------------------
${BBLU}list${WHT}            Info dump. If no param dump categories. Be specific!
${BBLU}sync${WHT}            Dotfile functions. (requires param)
${BGRN} + backup${WHT}       Backup ${USER}/dotfiles
${BGRN} + restore${WHT}      Restore saved dotfiles
${BGRN} + swap${WHT}         Quickly toggle dotfiles in and out.
${BBLU}run${WHT}             Execute a given user script. (requires param)
${BBLU}update${WHT}          Update packages and scripts


${BBLU}MODIFIERS
${BRED}--------------------------------------------------------------------------
${BBLU}--force${WHT}         Skip all user interaction.  Implied 'Yes' to all actions.
${BBLU}-q, --quiet${WHT}     Quiet (no output)
${BBLU}-l, --log${WHT}       Print log to file
${BBLU}-v, --verbose${WHT}   Output more information. (Items echoed to 'verbose')
${BBLU}-d, --debug${WHT}     Runs script in BASH debug mode (set -x)
${BBLU}-h, --help${WHT}      Display this help and exit
${BBLU}--version${WHT}       Output version information and exit
    "
  echo ""
  echo ""
}


#
# Mage Menu
#   Functions used to generate the "UI" for the Mage Script
#

function header {
    printf "${BRED}";
    cat "${mageDir}/trunk/ascii/art/mage.txt";
    printf "\n\n${BLK}${B_WHT} V. ${vMage}                                        github.com/johnny13/Mage ${NORMAL}\n\n";
    echo "";
}

function header_sm {
    printf "${BRED}";
    cat "${mageDir}/trunk/ascii/art/mage_sm.txt";
    echo "";
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
  printf -v _hr "%*s" "$(tput cols)" && echo -n "${PUR}" && echo -en ${_hr// /${2--}} && echo -en "\r\033[2C"
  tput rc;

  echo -en "\r\033[10C" && echo -n "${BRED} [ ${BBLU}$1${BRED} ]" # 10 space in

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
    *) logicUnknown ;;
  esac

  ####################################################
  ############### End Script Here ####################
}
