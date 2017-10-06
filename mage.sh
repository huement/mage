#!/usr/bin/env bash

#																					 #
#																					 #
# 	888b     d888                          #
# 	8888b   d8888                          #
# 	88888b.d88888                          #
# 	888Y88888P888 8888b.  .d88b.  .d88b.   #
# 	888 Y888P 888    "88bd88P"88bd8P  Y8b  #
# 	888  Y8P  888.d888888888  88888888888  #
# 	888   "   888888  888Y88b 888Y8b.      #
# 	888       888"Y888888 "Y88888 "Y8888   #
# 	                          888          #
# 	                     Y8b d88P          #
# 	                      "Y88P" 	0.2.0 	 #
#																		       #
# ---------------------------------------- #
#   Empower yourself and your shell env    #
#  Info mgmt - Code shortcuts - Dotfiles   #
# ---------------------------------------- #
#																					 #

source optparse.bash
# Define options
optparse.define short=o long=output desc="The output file" variable=output_mode default=head_output.txt default=false
optparse.define short=q long=quiet desc="Display no console output" variable=quiet_mode value=true default=false
optparse.define short=V long=verbose desc="Flag to set verbose (debug mode) to on" variable=verbose_mode value=true default=false
optparse.define short=v long=version desc="Print current version and exit" variable=version_mode value=true default=false
optparse.define short=u long=update desc="Update this script" variable=update_mode value=true default=false

optparse.define short=l long=list desc="Load and run user configured info files. Display documentation, snippets, or any other frequently forgotten data." variable=OPT_logicInfo value=true default=false
optparse.define short=m long=motd desc="Message of the day. Useful for shell startup welcome messages." variable=OPT_logicDisplay value=true default=false
optparse.define short=j long=jump desc="Status / Config for the 'jump' command. Useful if bash directory bookmarking is your thing." variable=OPT_logicJump value=true default=false
optparse.define short=s long=sync desc="Dotfile and user config management. Save, restore, or swap configs in and out." variable=OPT_logicDot value=true default=false
optparse.define short=e long=exec desc="Quickly list and/or execute saved user scripts. Your command list automatically populates from folder contents." variable=OPT_logicExec value=true default=false
source $( optparse.build )

if [ "$version_mode" == "" ]; then
	echo "ERROR: you suck."
	exit 1
fi

exit 1
mageHome=$HOME;
vMage="0.1.0";
quiet=false
printLog=false
verbose=false
force=false
strict=false

args=()
#debug=true

# UI Feedback Alerts
# -----------------------------------
function GOOD_WOLF {
  if tput setaf 1 &> /dev/null; then
    echo "$(tput bold)$(tput setaf 15)$(tput setab 10)[ OK ]$(tput sgr0) $1";
  else
    echo "\e[1m\e[1;47m\e[1;42m[ OK ]\e[0m $1";
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
    wmsg="$(tput bold)$(tput setaf 15)$(tput setab 12)[INFO]$(tput sgr0)  $1";
  else
    wmsg="\e[1m\e[1;44m\e[47m[INFO]\e[0m  $1";
  fi

  echo $wmsg;
}

# Script Variables
# -----------------------------------
# Mumford finds his place in the world
# Custom data is stored in ~/.mumford by default
# -----------------------------------
scriptPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
scriptName=$(basename $0)
scriptBasename="$(basename ${scriptName} .sh)"


# Config.json
# -----------------------------------
# Pull directory layout from config file, among other things
# -----------------------------------
CFILE=$mageHome/Mage/config.json;

if [[ ! -f "$CFILE" ]]; then
	BAD_WOLF "Config File $CFILE missing."

	NEWDIR=$mageHome/Mage
	if [[ ! -d "$NEWDIR" ]]; then
		BAD_WOLF "Directory ${NEWDIR} missing."
		WOLFSPEAK "Creating ${NEWDIR}"
		mkdir $NEWDIR
	fi

  CSFILE="${scriptPath}/trunk/install/config.sample.json";
	WOLFSPEAK "Checking for ${CSFILE}"

  if [[ -f "$CSFILE" ]]; then
		WOLFSPEAK "Generating config.json from ${CSFILE}"
    echo 'cp "'$CSFILE $HOME'/Mage/config.json"';
		cp $CSFILE $HOME/Mage/config.json
  else
    BAD_WOLF "${BRED}FATAL!${NORMAL} Missing Template | '${CSFILE}'"
    BAD_WOLF "Exiting . . . :("
    exit 1
  fi
fi

if [[ ! -f "${mageHome}/Mage/config.json" ]]; then
  BAD_WOLF "${BRED}FATAL!${NORMAL} Missing required files. Exiting."
  exit 1
else
	# dotsDir=$(jq -r ".folders.dotsDir" <<< cat $mageHome/Mage/config.json);
	# infoDir=$(jq -r ".folders.infoDir" <<< cat $mageHome/Mage/config.json);
	# codeDir=$(jq -r ".folders.codeDir" <<< cat $mageHome/Mage/config.json);
	# baseDir=$(jq -r ".folders.baseDir" <<< cat $mageHome/Mage/config.json);
fi

mageDir="/Users/${USER}/Mage"
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
