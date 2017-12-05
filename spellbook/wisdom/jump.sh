#!/usr/bin/env bash

DisplayInfo() {
	echo "${B_YLW}${BLK}  BASHMARKS - Shell bookmark manager  ${NORMAL}";
	echo "${BGRN}s ${BBLU}<bookmark_name> ${WHT}- Saves the current directory as \"bookmark_name\"";
	echo "${BGRN}g ${BBLU}<bookmark_name> ${WHT}- Goes (cd) to the directory associated with \"bookmark_name\"";
	echo "${BGRN}p ${BBLU}<bookmark_name> ${WHT}- Prints the directory associated with \"bookmark_name\"";
	echo "${BGRN}d ${BBLU}<bookmark_name> ${WHT}- Deletes the bookmark";
	echo "${BGRN}l                 ${WHT}- Lists all available bookmarks";
	echo "${NORMAL}";
}
