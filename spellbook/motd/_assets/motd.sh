#!/usr/bin/env bash

# MOTD MacOS
#############################

source ~/.bash_rainbow

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

echo ""
echo "${BB_BLU}${WHT} `date +"%A %e %B %Y, %r"` ${NORMAL}";
echo "${BGRN}
0010100010101101000100001110000010100111     $(title_name)
0010100010101101000100001110000010100111     $(macNames)
0010100010101101000100001110000010100111     $(kernel_details)
0010100010101101000100001110000010100111     $(sm_bios)
0010100010101101000100001110000010100111     $(shell_env)${NORMAL}

0010100010101101000100001110000010100111     $(wifi_status)
0010100010101101000100001110000010100111     $(xcode_ver)

0010100010101101000100001110000010100111     $(cpu_details)
0010100010101101000100001110000010100111     $(get_cpu_usage)

0010100010101101000100001110000010100111     $(hardware_ram)
0010100010101101000100001110000010100111     $(hardware_memory)

${NORMAL}"
echo "${get_cpu_usage}"
