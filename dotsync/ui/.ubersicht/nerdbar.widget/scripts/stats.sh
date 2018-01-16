#!/usr/bin/env bash

DIRDIR="/Users/derekscott/Mage/dotsync/ui/.ubersicht/nerdbar.widget/scripts"
BSH="/usr/local/bin/bash"

echo "$(${BSH} ${DIRDIR}/cpu_script)@$(${BSH} ${DIRDIR}/mem_script)@$(${BSH} ${DIRDIR}/networktraffic)@$(${BSH} ${DIRDIR}/hd_script)"
