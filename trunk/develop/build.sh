#!/bin/sh

# Bundle Wolf into Binary Executeable
# -----------------------------------
# Takes all the required files and merges them into one
# -----------------------------------

function liberMage {
  if [[ -f "$1" ]]; then
    source $1
  else
		BRED=""
		BGRN=""
		BBLU=""
		NORMAL=""
    echo "Color Library File $1 missing..."
    #exit 1
  fi
}

fn_exists() {
  # appended double quote is an ugly trick to make sure we do get a string -- if $1 is not a known command, type does not output anything
  [[ `type -t $1`"" == 'function' ]]
}

liberMage "../../.mage/coat.sh";

$FN='shc';

if ! fn_exists $FN; then
    echo "$FN does not exist. You're going to wanna fix that."
    exit 2
fi

echo "";
echo "Creating wolfbin.sh from wolf.sh + ./wolf/*.sh . . ."
cat mage.sh ./.mage/*.sh > mage.bundle.sh
echo "Done!"
echo ""
echo "Generate binary from wolfbin.sh via shc command . . ."
shc -f mage.bundle.sh -o mage
echo "Done!"
echo ""
echo ""
echo "${BRED}---------------- IMPORTANT ----------------${NORMAL}"
echo ""
echo "a 'mage' executeable should have been created in this directory."
echo "for system wide access, move 'mage' to a folder accessable in your \$PATH variable."
echo ""
echo ""
echo "EXAMPLES"
echo ""
echo "${BGRN}macOS | sudo cp ./mage /usr/local/bin/mage && sudo chmod +x /usr/local/bin/mage"
echo "${BBLU}Linux | sudo cp ./mage /usr/bin && sudo chmod +x /usr/bin/mage"
echo "${NORMAL}"
