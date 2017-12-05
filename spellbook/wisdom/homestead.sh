#!/usr/bin/env bash

DisplayInfo() {
	echo "${B_YLW}${BLK}  HOMESTEAD - Vagrant + Laravel  ${NORMAL}";
	echo "${BGRN}vagg   ${BBLU}vagrant global-status ${WHT}- Display all Vagrant box statuses.";
	echo "${BGRN}vags   ${BBLU}homestead status      ${WHT}- Only homestead box status";
	echo "${BGRN}vagu   ${BBLU}homestead up          ${WHT}- Spin up the homestead box";
	echo "${BGRN}vagssh ${BBLU}homestead ssh         ${WHT}- Connect to active homestead box";
	echo "${BGRN}vagre  ${BBLU}homestead reload      ${WHT}- Reset and reprovision homestead";
	echo "${NORMAL}";
}
