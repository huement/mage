#!/usr/bin/env bash

########################[ PROMPT COLOR CODES ]#######################

if tput setaf 1 &> /dev/null; then

	# REGULAR TEXT COLORS
	BLK="$(tput setaf 0)"         # Black
	RED="$(tput setaf 1)"         # Red
	GRN="$(tput setaf 2)"         # Green
	YLW="$(tput setaf 3)"         # Yellow
	BLU="$(tput setaf 4)"         # Blue
	PUR="$(tput setaf 5)"         # Purple
	CYN="$(tput setaf 6)"         # Cyan
	WHT="$(tput setaf 7)"         # White
                               
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
	B_BLK="$(tput setab 0)"       # Black
	B_RED="$(tput setab 1)"       # Red
	B_GRN="$(tput setab 2)"       # Green
	B_YLW="$(tput setab 3)"       # Yellow
	B_BLU="$(tput setab 4)"       # Blue
	B_PUR="$(tput setab 5)"       # Purple
	B_CYN="$(tput setab 6)"       # Cyan
	B_WHT="$(tput setab 7)"       # White

	# BOLD BACKGROUND COLORS
	BB_BLK="$(tput setab 8)"      # Black
	BB_RED="$(tput setab 9)"      # Red
	BB_GRN="$(tput setab 10)"     # Green
	BB_YLW="$(tput setab 11)"     # Yellow
	BB_BLU="$(tput setab 12)"     # Blue
	BB_PUR="$(tput setab 13)"     # Purple
	BB_CYN="$(tput setab 14)"     # Cyan
	BB_WHT="$(tput setab 7)"      # White
	
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

export MageCoat=1;
