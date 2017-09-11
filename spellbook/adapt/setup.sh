#!/usr/bin/env bash

#  Adapt
#######################################################
#  Allow your environemnt to subtly adapt to certain
#  environmental factors, such as temp or time of day.  
#######################################################

# DIRCOLORS
echo ""
echo ""
echo "Getting a .dircolors builder. . ."
echo ""
git clone "https://github.com/karlding/dirchromatic.git" && cd dirchromatic/
git submodule update --init --recursive
bin/dirchromatic

# THIS SHOULD ALREADY BE IN YOUR .BASHRC
# --------------------------------------
# if [ -r "$HOME/.dircolors" ]; then
#     eval `dircolors $HOME/.dircolors`
# fi
echo ""
echo " if [ -r \"\$HOME/.dircolors\" ]; then"
echo "	  eval \`dircolors \$HOME/.dircolors\`"
echo " fi"
echo ""

# If its not. Add it to the end of .bashrc or .bash_profile
echo ""
echo "If its not. Add it to the end of .bashrc or .bash_profile"
echo ""
