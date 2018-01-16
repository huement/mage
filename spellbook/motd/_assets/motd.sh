#!/usr/bin/env bash

# MOTD MacOS
# ------------------ --------- ------ ---- --- -- -

# COLOR SETUP
if tput setaf 1&>/dev/null;then BLK="$(tput setaf 0)";RED="$(tput setaf 1)";GRN="$(tput setaf 2)";YLW="$(tput setaf 3)";BLU="$(tput setaf 4)";PUR="$(tput setaf 5)";CYN="$(tput setaf 6)";WHT="$(tput setaf 7)";BBLK="$(tput setaf 8)";BRED="$(tput setaf 9)";BGRN="$(tput setaf 10)";BYLW="$(tput setaf 11)";BBLU="$(tput setaf 12)";BPUR="$(tput setaf 13)";BCYN="$(tput setaf 14)";BWHT="$(tput setaf 15)";B_BLK="$(tput setab 0)";B_RED="$(tput setab 1)";B_GRN="$(tput setab 2)";B_YLW="$(tput setab 3)";B_BLU="$(tput setab 4)";B_PUR="$(tput setab 5)";B_CYN="$(tput setab 6)";B_WHT="$(tput setab 7)";BB_BLK="$(tput setab 8)";BB_RED="$(tput setab 9)";BB_GRN="$(tput setab 10)";BB_YLW="$(tput setab 11)";BB_BLU="$(tput setab 12)";BB_PUR="$(tput setab 13)";BB_CYN="$(tput setab 14)";BB_WHT="$(tput setab 7)";NORMAL="$(tput sgr0)";BOLD="$(tput bold)";UNDERLINE="$(tput smul)";NOUNDER="$(tput rmul)";BLINK="$(tput blink)";REVERSE="$(tput rev)";else BLK="\e[1;30m";RED="\e[1;31m";GRN="\e[1;32m";YLW="\e[1;33m";BLU="\e[1;34m";PUR="\e[1;35m";CYN="\e[1;36m";WHT="\e[1;37m";BBLK="\e[1;30m";BRED="\e[1;31m";BGRN="\e[1;32m";BYLW="\e[1;33m";BBLU="\e[1;34m";BPUR="\e[1;35m";BCYN="\e[1;36m";BWHT="\e[1;37m";B_BLK="\e[40m";B_RED="\e[41m";B_GRN="\e[42m";B_YLW="\e[43m";B_BLU="\e[44m";B_PUR="\e[45m";B_CYN="\e[46m";B_WHT="\e[47m";BB_BLK="\e[1;40m";BB_RED="\e[1;41m";BB_GRN="\e[1;42m";BB_YLW="\e[1;43m";BB_BLU="\e[1;44m";BB_PUR="\e[1;45m";BB_CYN="\e[1;46m";BB_WHT="\e[1;47m";NORMAL="\e[0m";BOLD="\e[1m";UNDERLINE="\e[4m";NOUNDER="\e[24m";BLINK="\e[5m";NOBLINK="\e[25m";REVERSE="\e[50m";fi;
  

function OS_X_V {
  # Mac OS Details
  local os=$(system_profiler SPSoftwareDataType |grep --extended-regexp 'System Version: '|sed 's/^.*: //')
  osos=${os%(*}
  printf "${osos}"
}

function hardware_ram {
  local ram=$(system_profiler SPHardwareDataType |grep --extended-regexp 'Memory: ' |sed 's/^.*: //')
  local type=$(system_profiler SPMemoryDataType |grep --extended-regexp 'Type: '\|'Speed: '|sed 's/^.*: //'|head -2)

  echo ${ram} ${type} | tr '\n' ' '
  echo ""
}

function hardware_memory {
  mem_total="$(($(sysctl -n hw.memsize) / 1024 / 1024))"
  mem_wired="$(vm_stat | awk '/wired/ { print $4 }')"
  mem_active="$(vm_stat | awk '/active / { printf $3 }')"
  mem_compressed="$(vm_stat | awk '/occupied/ { printf $5 }')"
  mem_used="$(((${mem_wired//.} + ${mem_active//.} + ${mem_compressed//.}) * 4 / 1024))"
  printf ${mem_used};
}

function hardware_gpu {
  local gpu=$(system_profiler SPDisplaysDataType |grep --extended-regexp 'Chipset Model: '\|'VRAM \(Dynamic, Max\): '|sed 's/^.*: //'|head -2)
  printf "${gpu}"
}

function cpu_details {
  local cpu=$(sysctl -n machdep.cpu.brand_string)
  printf "${cpu}"
}

function root_disk {
  local rdd="Free: ${RootFree}GB, Used: ${RootUsed}GB, Total: ${RootTotal}GB"
  printf "${rdd}"
}

function kernel_details {
  local kern=$(uname -rs)
  printf "${kern}"
}

function xcode_ver {
  local xcv=$(xcodebuild -version | head -1)
  printf "${xcv}"
}

# WORKS. BUT SLOW: $(external_ip)
function external_ip {
  # Get external IPs
  local EXTERNAL_IP4=$(curl -4 --connect-timeout 3 -s http://v4.ipv6-test.com/api/myip.php || echo None)
  # Perform whois lookup on the external IPv4 address.
  [[ "$EXTERNAL_IP4" == "None" ]] && WHOIS="" || WHOIS=$(whois "$EXTERNAL_IP4" | awk '/descr: / {$1=""; print $0 }' | head -n 1)
  printf "${EXTERNAL_IP4}"
}

function wifi_status {
  services=$(networksetup -listnetworkserviceorder | grep 'Hardware Port')
  while read line; do
      sname=$(echo $line | awk -F  "(, )|(: )|[)]" '{print $2}')
      sdev=$(echo $line | awk -F  "(, )|(: )|[)]" '{print $4}')
      #echo "Current service: $sname, $sdev, $currentservice"
      if [ -n "$sdev" ]; then
          ifout="$(ifconfig $sdev 2>/dev/null)"
          echo "$ifout" | grep 'status: active' > /dev/null 2>&1
          rc="$?"
          if [ "$rc" -eq 0 ]; then
              currentservice="$sname"
              currentdevice="$sdev"
              currentmac=$(echo "$ifout" | awk '/ether/{print $2}')
          fi
      fi
  done <<< "$(echo "$services")"

  local WIFINAME=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')

  if [ -n "$currentservice" ]; then
      printf "${currentservice} [ ${WIFINAME} ]"
  fi
}

function cpu_load {
  local load=$(uptime|sed 's/.*ages: //')
  printf "${load}"
}

function shell_env {
  local bash_version="${BASH_VERSION} "
  printf "${bash_version} "
  printf "${TERM}"
}

function get_cpu_usage {
  # Get CPU cores if unset.
  if [[ "$cpu_cores" != "logical" ]]; then
      cores="$(sysctl -n hw.logicalcpu_max)"
  fi


  cpu_usage="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
  cpu_usage="$((${cpu_usage/\.*} / ${cores:-1}))"
  cpu_usage="${cpu_usage}%"

  cpu_ut="${BCYN}◼◼◼◼${BLU}▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭${BYLW} ${cpu_usage}"
  echo ${cpu_ut}${NORMAL};
}

function sm_bios {
  if [[ "$(kextstat | grep "FakeSMC")" != "" ]]; then
    echo -en "$(sysctl -n hw.model) ${BBLU}[HACKINTOSH]${BGRN}"
  else
    echo -en "$(sysctl -n hw.model)"
  fi
}

function macNames {
    osx_version="$(sw_vers -productVersion)"
    osx_build="$(sw_vers -buildVersion)"

    case "$osx_version" in
      "10.4"*)  codename="Mac OS X Tiger" ;;
      "10.5"*)  codename="Mac OS X Leopard" ;;
      "10.6"*)  codename="Mac OS X Snow Leopard" ;;
      "10.7"*)  codename="Mac OS X Lion" ;;
      "10.8"*)  codename="OS X Mountain Lion" ;;
      "10.9"*)  codename="OS X Mavericks" ;;
      "10.10"*) codename="OS X Yosemite" ;;
      "10.11"*) codename="OS X El Capitan" ;;
      "10.12"*) codename="macOS Sierra" ;;
      "10.13"*) codename="macOS High Sierra" ;;
      *)        codename="macOS" ;;
    esac

    distro="$codename $osx_version $osx_build"
    echo "${distro}"
}

function title_name {
  user="${USER:-$(whoami || printf "%s" "${HOME/*\/}")}"
  hostname="${HOSTNAME:-$(hostname)}"
  title="${title_color}${bold}${user}${at_color}@${title_color}${bold}${hostname}"
  length="$((${#user} + ${#hostname} + 1))"
  echo "${title}"
}

tput clear      # clear the screen; tput cup 1 15
tput cup 1 36;
printf "${B_BLU}${BLK} `date +"%A %e %B %Y, %r"` ${NORMAL}";
tput cup 3 36;

 gline=3;
 
 echo "USER............. $(title_name)";
 
 gline=$((gline+1));tput cup $gline 36;
 
 echo "SYSTEM........... $(macNames) | $(kernel_details)";
 
 gline=$((gline+1));tput cup $gline 36;
 
 echo "MODEL............ $(sm_bios)";
 
  gline=$((gline+1));tput cup $gline 36;
  
 echo "SHELL............ $(shell_env)";
 
  gline=$((gline+1));tput cup $gline 36;
  
 echo "WIFI............. $(wifi_status)";
 
  gline=$((gline+1));tput cup $gline 36;
  
 echo "CPU.............. $(cpu_details)";
 
  gline=$((gline+1));tput cup $gline 36;
  
 echo "LOAD............. $(get_cpu_usage)";
 
  gline=$((gline+1));tput cup $gline 36;
  
 echo "MEMORY........... $(hardware_ram)";
 
  gline=$((gline+1));tput cup $gline 36;
  

 
  gline=$((gline+1));tput cup $gline 36;
  
 echo "$(hardware_ram)";
 
  gline=$((gline+1));tput cup $gline 36;
  
 echo "$(hardware_memory)";

echo "${get_cpu_usage}"

tput cup 0 0;
cat './crest_ansi.txt';
echo ""
echo ""
