#!/usr/bin/env bash
clear;
cat ./conjure.txt
tput sc;
tput  cuu 37;
tput cuf 40;
echo "Lorem ipsum dolor sit amet, consectetur adipisicing elit";
tput cuf 40;
echo "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.";
tput cuf 40;
echo "Duis aute irure dolor in reprehenderit in voluptate";
tput cuf 40;
echo "Excepteur sint occaecat cupidatat non proident, sunt in"
tput rc;
tput sgr0
