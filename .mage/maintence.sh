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
