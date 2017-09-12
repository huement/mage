#!/bin/bash

get_os() {
  # $kernel_name is set in a function called cache_uname and is
  # just the output of "uname -s".
  case "$kernel_name" in
    "Linux" | "GNU"*) os="Linux" ;;
    "Darwin") os="$(sw_vers -productName)" ;;
    *"BSD" | "DragonFly" | "Bitrig") os="BSD" ;;
    "CYGWIN"* | "MSYS"* | "MINGW"*) os="Windows" ;;
    "SunOS") os="Solaris" ;;
    "Haiku") os="Haiku" ;;
    "MINIX") os="MINIX" ;;
    "AIX") os="AIX" ;;
    "IRIX64") os="IRIX" ;;
    *)
      printf "%s\n" "Unknown OS detected: '$kernel_name', aborting..." >&2
      printf "%s\n" "Open an issue on GitHub to add support for your OS." >&2
      exit 1
    ;;
  esac
}

get_distro() {
  [[ "$distro" ]] && return

  case "$os" in
    "Linux" | "BSD" | "MINIX")
      if [[ "$(< /proc/version)" == *"Microsoft"* ||
        "$kernel_version" == *"Microsoft"* ]]; then
        case "$distro_shorthand" in
          "on")   distro="$(lsb_release -sir) [Windows 10]" ;;
          "tiny") distro="Windows 10" ;;
          *)      distro="$(lsb_release -sd) on Windows 10" ;;
        esac

      elif [[ "$(< /proc/version)" == *"chrome-bot"* || -f "/dev/cros_ec" ]]; then
        case "$distro_shorthand" in
          "on")   distro="$(lsb_release -sir) [Chrome OS]" ;;
          "tiny") distro="Chrome OS" ;;
          *)      distro="$(lsb_release -sd) on Chrome OS" ;;
        esac

      elif [[ -f "/etc/redstar-release" ]]; then
        case "$distro_shorthand" in
          "on" | "tiny") distro="Red Star OS" ;;
          *) distro="Red Star OS $(awk -F'[^0-9*]' '$0=$2' /etc/redstar-release)"
        esac

      elif [[ -f "/etc/siduction-version" ]]; then
        case "$distro_shorthand" in
          "on" | "tiny") distro="Siduction" ;;
          *) distro="Siduction ($(lsb_release -sic))"
        esac

      elif type -p lsb_release >/dev/null; then
        case "$distro_shorthand" in
          "on")   lsb_flags="-sir" ;;
          "tiny") lsb_flags="-si" ;;
          *)      lsb_flags="-sd" ;;
        esac
        distro="$(lsb_release $lsb_flags)"

      elif [[ -f "/etc/GoboLinuxVersion" ]]; then
        case "$distro_shorthand" in
          "on" | "tiny") distro="GoboLinux" ;;
          *) distro="GoboLinux $(< /etc/GoboLinuxVersion)"
        esac

      elif type -p guix >/dev/null; then
        case "$distro_shorthand" in
          "on" | "tiny") distro="GuixSD" ;;
          *) distro="GuixSD $(guix system -V | awk 'NR==1{printf $5}')"
        esac

      elif type -p crux >/dev/null; then
        distro="$(crux)"
        case "$distro_shorthand" in
          "on")   distro="${distro//version}" ;;
          "tiny") distro="${distro//version*}" ;;
        esac

      elif type -p tazpkg >/dev/null; then
        distro="SliTaz $(< /etc/slitaz-release)"

      elif type -p kpm > /dev/null; then
        distro="KSLinux"

      elif [[ -d "/system/app/" && -d "/system/priv-app" ]]; then
        distro="Android $(getprop ro.build.version.release)"

      elif [[ -f "/etc/os-release" || -f "/usr/lib/os-release" ]]; then
        files=("/etc/os-release" "/usr/lib/os-release")

        # Source the os-release file
        for file in "${files[@]}"; do
          source "$file" && break
        done

        # Format the distro name.
        case "$distro_shorthand" in
          "on") distro="${NAME:-${DISTRIB_ID}} ${VERSION_ID:-${DISTRIB_RELEASE}}" ;;
          "tiny") distro="${NAME:-${DISTRIB_ID:-${TAILS_PRODUCT_NAME}}}" ;;
          "off") distro="${PRETTY_NAME:-${DISTRIB_DESCRIPTION}} ${UBUNTU_CODENAME}" ;;
        esac

        # Workarounds for distros that go against the os-release standard.
        [[ -z "${distro// }" ]] && distro="$(awk '/BLAG/ {print $1; exit}')" "${files[@]}"
        [[ -z "${distro// }" ]] && distro="$(awk -F'=' '{print $2; exit}')"  "${files[@]}"

      else
        for release_file in /etc/*-release; do
          distro+="$(< "$release_file")"
        done

        if [[ -z "$distro" ]]; then
          case "$distro_shorthand" in
            "on" | "tiny") distro="$kernel_name" ;;
            *) distro="$kernel_name $kernel_version" ;;
          esac
          distro="${distro/DragonFly/DragonFlyBSD}"

          # Workarounds for FreeBSD based distros.
          [[ -f "/etc/pcbsd-lang" ]] && distro="PCBSD"
          [[ -f "/etc/rc.conf.trueos" ]] && distro="TrueOS"

          # /etc/pacbsd-release is an empty file
          [[ -f "/etc/pacbsd-release" ]] && distro="PacBSD"
        fi
      fi
      distro="$(trim_quotes "$distro")"
    ;;

    "Mac OS X")
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

      case "$distro_shorthand" in
        "on") distro="${distro/ ${osx_build}}" ;;
        "tiny")
          case "$osx_version" in
            "10."[4-7]*) distro="${distro/${codename}/Mac OS X}" ;;
            "10."[8-9]* | "10.1"[0-1]*) distro="${distro/${codename}/OS X}" ;;
            "10.12"*) distro="${distro/${codename}/macOS}" ;;
          esac
          distro="${distro/ ${osx_build}}"
        ;;
      esac
    ;;

    "iPhone OS")
      distro="iOS $(sw_vers -productVersion)"

      # "uname -m" doesn't print architecture on iOS so we force it off.
      os_arch="off"
    ;;

    "Windows")
      distro="$(wmic os get Caption)"

      # Strip crap from the output of wmic.
      distro="${distro/Caption}"
      distro="${distro/Microsoft }"
    ;;

    "Solaris")
      case "$distro_shorthand" in
        "on" | "tiny") distro="$(awk 'NR==1{print $1 " " $3;}' /etc/release)" ;;
        *) distro="$(awk 'NR==1{print $1 " " $2 " " $3;}' /etc/release)" ;;
      esac
      distro="${distro/\(*}"
    ;;

    "Haiku")
      distro="$(uname -sv | awk '{print $1 " " $2}')"
    ;;

    "AIX")
      distro="AIX $(oslevel)"
    ;;

    "IRIX")
      distro="IRIX ${kernel_version}"
    ;;
  esac

  distro="${distro//Enterprise Server}"

  [[ -z "$distro" ]] && distro="$os (Unknown)"

  # Get OS architecture.
  case "$os" in
    "Solaris" | "AIX" | "Haiku" | "IRIX") machine_arch="$(uname -p)" ;;
    *) machine_arch="$(uname -m)" ;;

  esac
  if [[ "$os_arch" == "on" ]]; then
    distro+=" ${machine_arch}"
  fi

  [[ "${ascii_distro:-auto}" == "auto" ]] && \
  ascii_distro="$(trim "$distro")"
}

get_model() {
  case "$os" in
    "Linux")
      if [[ -d "/system/app/" && -d "/system/priv-app" ]]; then
        model="$(getprop ro.product.brand) $(getprop ro.product.model)"

      elif [[ -f /sys/devices/virtual/dmi/id/product_name ||
        -f /sys/devices/virtual/dmi/id/product_version ]]; then
        model="$(< /sys/devices/virtual/dmi/id/product_name)"
        model+=" $(< /sys/devices/virtual/dmi/id/product_version)"

      elif [[ -f /sys/firmware/devicetree/base/model ]]; then
        model="$(< /sys/firmware/devicetree/base/model)"

      elif [[ -f /tmp/sysinfo/model ]]; then
        model="$(< /tmp/sysinfo/model)"
      fi
    ;;

    "Mac OS X")
      if [[ "$(kextstat | grep "FakeSMC")" != "" ]]; then
        model="Hackintosh (SMBIOS: $(sysctl -n hw.model))"
      else
        model="$(sysctl -n hw.model)"
      fi
    ;;

    "iPhone OS")
      case "$machine_arch" in
        "iPad1,1") model="iPad" ;;
        "iPad2,"[1-4]) model="iPad2" ;;
        "iPad3,"[1-3]) model="iPad3" ;;
        "iPad3,"[4-6]) model="iPad4" ;;
        "iPad4,"[1-3]) model="iPad Air" ;;
        "iPad5,"[3-4]) model="iPad Air 2" ;;
        "iPad6,"[7-8]) model="iPad Pro (12.9 Inch)" ;;
        "iPad6,"[3-4]) model="iPad Pro (9.7 Inch)" ;;
        "iPad2,"[5-7]) model="iPad mini" ;;
        "iPad4,"[4-6]) model="iPad mini 2" ;;
        "iPad4,"[7-9]) model="iPad mini 3" ;;
        "iPad5,"[1-2]) model="iPad mini 4" ;;

        "iPhone1,1") model="iPhone" ;;
        "iPhone1,2") model="iPhone 3G" ;;
        "iPhone2,1") model="iPhone 3GS" ;;
        "iPhone3,"[1-3]) model="iPhone 4" ;;
        "iPhone4,1") model="iPhone 4S" ;;
        "iPhone5,"[1-2]) model="iPhone 5" ;;
        "iPhone5,"[3-4]) model="iPhone 5c" ;;
        "iPhone6,"[1-2]) model="iPhone 5s" ;;
        "iPhone7,2") model="iPhone 6" ;;
        "iPhone7,1") model="iPhone 6 Plus" ;;
        "iPhone8,1") model="iPhone 6s" ;;
        "iPhone8,2") model="iPhone 6s Plus" ;;
        "iPhone8,4") model="iPhone SE" ;;
        "iPhone9,1" | "iPhone9,3") model="iPhone 7" ;;
        "iPhone9,2" | "iPhone9,4") model="iPhone 7 Plus" ;;

        "iPod1,1") model="iPod touch" ;;
        "ipod2,1") model="iPod touch 2G" ;;
        "ipod3,1") model="iPod touch 3G" ;;
        "ipod4,1") model="iPod touch 4G" ;;
        "ipod5,1") model="iPod touch 5G" ;;
        "ipod7,1") model="iPod touch 6G" ;;
      esac
    ;;

    "BSD" | "MINIX")
      model="$(sysctl -n hw.vendor hw.product)"
    ;;

    "Windows")
      model="$(wmic computersystem get manufacturer,model)"
      model="${model/Manufacturer}"
      model="${model/Model}"
    ;;

    "Solaris")
      model="$(prtconf -b | awk -F':' '/banner-name/ {printf $2}')"
    ;;

    "AIX")
      model="$(/usr/bin/uname -M)"
    ;;
  esac

  # Remove dummy OEM info.
  model="${model//To be filled by O.E.M.}"
  model="${model//To Be Filled*}"
  model="${model//OEM*}"
  model="${model//Not Applicable}"
  model="${model//System Product Name}"
  model="${model//System Version}"
  model="${model//Undefined}"
  model="${model//Default string}"
  model="${model//Not Specified}"
  model="${model//Type1ProductConfigId}"

  case "$model" in
    "Standard PC"*) model="KVM/QEMU (${model})" ;;
  esac
}


if [[ "$(kextstat | grep "FakeSMC")" != "" ]]; then
  model="Hackintosh (SMBIOS: $(sysctl -n hw.model))"
else
  model="$(sysctl -n hw.model)"
fi

echo "${model}"
