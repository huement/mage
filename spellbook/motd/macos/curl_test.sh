#!/bin/bash 
# Retrieve serial number in OS X, then append serial number to URL 
# Can someone tell me why this works here, but not in the larger script. 

### Retrieve serial number ### 

function serial_number(){
        local serialnum=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}') 
        # Use system_profiler to poll info, then print 4th column of Serial from SPHardwareDataType  
        
        # write_header "Serial Number" 
        echo "${serialnum}"
        echo ""
} 

<<<<<<< HEAD
function apple_link(){
	local appleurl="https://support.apple.com/specs/$(serial_number)"
=======
### Append serial number to URL ### 

function apple_link(){
	local appleurl="https://support.apple.com/specs/$(serial_number)"

>>>>>>> ef4cfb174902a1a25e3367cbbb366c7b37d09d71
	echo "${appleurl}"
	echo ""
} 

### Testing ### 
apple_link
