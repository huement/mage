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
    echo "Library File $1 missing..."
    #exit 1
  fi
}

function fn_exists {
  # appended double quote is an ugly trick to make sure we do get a string -- if $1 is not a known command, type does not output anything
  [[ `type -t $1`"" == 'function' ]]
}

liberMage "../../.mage/coat.sh";

command -v /usr/local/bin/shc >/dev/null 2>&1 || { echo "Building requires shc, but it's not installed.  Aborting." >&2; exit 1; }

function startBuilding {
	echo "\n"
	echo "${BBLU}888b     d888       d8888 .d8888b. 8888888888 "
	echo "8888b   d8888      d88888d88P  Y88b888        "
	echo "${BGRN}88888b.d88888     d88P888888    888888        "
	echo "888Y88888P888    d88P 888888       8888888    "
	echo "888 Y888P 888   d88P  888888  88888888        "
	echo "${BBLU}888  Y8P  888  d88P   888888    888888        "
	echo "888       888 d8888888888Y88b  d88P888        "
	echo "888       888d88P     888  Y8888P888888888888 "
	echo "${NORMAL}"
	echo "----------- [DEVELOPMENT BUILDER] -----------"
	echo "${NORMAL}\n"
	echo "${BGRN}[ OK ]${NORMAL} BUILD STARTING 'tmp/magebin.sh'${NORMAL}\n"
	echo "${BBLU}[INFO]${NORMAL} CONCATING header.sh ../../mage.sh ../../.mage/*.sh${NORMAL}\n"
}

mkdir tmp

startBuilding

cat ../../.mage/*.sh ../../mage.sh > ./tmp/mage.bundle.sh

echo "${BGRN}[ OK ]${NORMAL} BUILD DONE!"

cat ./tmp/mage.bundle.sh | egrep -v "^[[:blank:]]*#" > ./tmp/mage.clean.sh

awk -i inplace 'BEGINFILE{print "#!/bin/sh"}{print}' ./tmp/mage.clean.sh
awk -i inplace 'BEGINFILE{print "#!/bin/sh"}{print}' ./tmp/mage.bundle.sh

echo ""
echo "${BGRN}[ OK ]${NORMAL} CODE CLEANED"
echo ""
echo "${BGRN}[ OK ]${NORMAL} COMPRESSING TO BINARY"
echo ""

/usr/local/bin/shc -f ./tmp/mage.clean.sh -o ./tmp/mage

cp ./tmp/mage ./
cp ./tmp/mage ../../

if [[ -f "./mage" ]]; then
	echo "${BGRN}[ OK ]${NORMAL} BINARY CREATED!${NORMAL}"
	#rm -rf ./tmp
	
	echo " \n"
	echo "${BRED}[IMPT] ---------------- ---------------- [IMPT]${NORMAL}"
	echo "        ${BGRN}'mage'${NORMAL} executeable built."
	echo "         move to a \$PATH accessable dir."
	echo "${BRED}[IMPT] ---------------- ---------------- [IMPT]${NORMAL}\n\n"
	echo "${BBLU}[INFO] MacOS| ${NORMAL}sudo cp ./mage /usr/local/bin && sudo chmod +x /usr/local/bin/mage\n"
	echo "${BBLU}[INFO] Linux| ${NORMAL}sudo cp ./mage /usr/bin && sudo chmod +x /usr/bin/mage"
	echo "${NORMAL}\n"
else
	echo "${BRED}[FAIL]${NORMAL} magebin.sh could not be created.${NORMAL}"
	exit 0
fi
