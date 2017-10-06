#!/bin/sh

# Bundle mage into Binary Executeable
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

function fn_exists {
  # appended double quote is an ugly trick to make sure we do get a string -- if $1 is not a known command, type does not output anything
  [[ `type -t $1`"" == 'function' ]]
}

liberMage "../../.mage/coat.sh";

command -v /usr/bin/scp >/dev/null 2>&1 || { echo "Building requires shc, but it's not installed.  Aborting." >&2; exit 1; }

mkdir tmp
echo "";
echo "Creating magebin.sh from mage.sh + ./mage/*.sh . . ."
cat header.sh ../../.mage/optparse.bash ../../mage.sh ../../.mage/*.sh > ./tmp/mage.bundle.sh
echo "Done!"
echo ""
echo "Generate binary from magebin.sh via shc command . . ."
/usr/bin/scp -f mage.bundle.sh -o ./tmp/mage
cp ./tmp/mage ./
rm -rf ./tmp
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
