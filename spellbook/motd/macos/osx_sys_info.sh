#!/bin/bash

# Get info about Operating System  

function write_header(){
    local h="$@"
    echo "--------------------------"
    echo "  ${h}"
    echo "--------------------------"
}

function os_info(){
        write_header " System Info" 
        sw_vers 
	echo "Kernel:         $(uname -rs)"
        
}

os_info
