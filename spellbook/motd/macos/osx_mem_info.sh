#!/bin/bash 
# Display used and free memory info

# This needs to be re-done :( There's no free command for starters. 
# There's also no vmstat command 
# ps doesn't accept -f as an option 

#################
### FUN TIMES ### 
#################


function mem_info(){
        write_header "Free & Used Memory "
        top -l 1 -s 0 | grep PhysMem
    echo "**************************"
        echo "*** Virtual Memory Statistics ***"
    echo "**************************"
        vmstat
echo "**************************"
        echo "*** Top 5 Memory Eating Process ***"
echo "**************************"
        ps auxf | sort -nr -k 4 | head -5
        pause
}

mem_info
#hostinfo | grep memory
