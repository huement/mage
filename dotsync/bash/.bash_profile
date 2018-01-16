if ! shopt -q login_shell; then
	return 0;
fi

# ----------------------------------------   -----   ----    ---    --    -
#       	________          __ ___________.__.__                 	 
#       	\______ \   _____/  |\_   _____/|__|  |   ____   ______	 
#       	 |    |  \ /  _ \   __\    __)  |  |  | _/ __ \ /  ___/	 
#       	 |    `   (  <_> )  | |     \   |  |  |_\  ___/ \___ \ 	 
#       	/_______  /\____/|__| \___  /   |__|____/\___  >____  >	 
#       	        \/                \/                 \/     \/ 	 
# ----------------------------------------   -----   ----    ---    --    -

export DEBUGMODE=1; # 0 = on. 1 = off


# Shell libraries
# ----------------------------------------   -----   ----    ---    --    -
if [ "$PS1" ]; then
  
	for file in ~/.{bash_rainbow,bash_naked,bash_prompt,bash_functions}; do
		[ -r "$file" ] && [ -f "$file" ] && source "$file";
		if [ $DEBUGMODE == "0" ]; then 
			echo "${GRN}[DONE]${NORMAL} Sourced $file" 
		fi
	done;
	unset file;

	if [ -z "$THIRTEEN" ]; then
		BASHRC="/Users/$USER/.bashrc"
		source $BASHRC;
		if [ $DEBUGMODE == "0" ]; then 
			echo "${GRN}[DONE]${NORMAL} Sourced $BASHRC";
		fi
	fi

	# START UP
	# ----------------------------------------   -----   ----    ---    --    -
	if [ $DEBUGMODE = "0" ]; then 
		echo -e "\n\n"
		echo "------------- [ DEBUG MODE ] -------------";
		echo "             FINISHED LOADING";
		echo ""
	else
		echo "" && neofetch && echo "";
	fi
  
fi


######## NOWAGUI BUG
## export PATH=$PATH:/Applications/Developer/NowaGUI.app/Contents/Resources/app/nodes:/Users/derekscott/.nowa-gui/installation/node_modules/.bin:/Applications/Developer/NowaGUI.app/Contents/Resources/app/node_modules/.bin

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH="$HOME/.cargo/bin:$PATH"
