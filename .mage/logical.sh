
# File Checks
# ------------------------------------------------------
# A series of functions which make checks against the filesystem. For
# use in if/then statements.
#
# Usage:
#    if is_file "file"; then
#       ...
#    fi
# ------------------------------------------------------
mageSimple=1;

function is_exists {
  if [[ -e "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_exists {
  if [[ ! -e "$1" ]]; then
    return 0
  fi
  return 1
}

function is_file {
  if [[ -f "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_file {
  if [[ ! -f "$1" ]]; then
    return 0
  fi
  return 1
}

function is_dir {
  if [[ -d "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_dir {
  if [[ ! -d "$1" ]]; then
    return 0
  fi
  return 1
}

function is_symlink {
  if [[ -L "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_symlink {
  if [[ ! -L "$1" ]]; then
    return 0
  fi
  return 1
}

function is_empty {
  if [[ -z "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_empty {
  if [[ -n "$1" ]]; then
    return 0
  fi
  return 1
}


# Build Path
# -----------------------------------
# DESC: Combines two path variables and removes any duplicates
# ARGS: $1 (required): Path(s) to join with the second argument
#       $2 (optional): Path(s) to join with the first argument
# OUTS: $build_path: The constructed path
# NOTE: Heavily inspired by: https://unix.stackexchange.com/a/40973
# -----------------------------------
function build_path {
    if [[ -z ${1-} || $# -gt 2 ]]; then
        script_exit "Invalid arguments passed to build_path()!" 2
    fi

    local new_path path_entry temp_path

    temp_path="$1:"
    if [[ -n ${2-} ]]; then
        temp_path="$temp_path$2:"
    fi

    new_path=
    while [[ -n $temp_path ]]; do
        path_entry="${temp_path%%:*}"
        case "$new_path:" in
            *:"$path_entry":*) ;;
                            *) new_path="$new_path:$path_entry"
                               ;;
        esac
        temp_path="${temp_path#*:}"
    done

    # shellcheck disable=SC2034
    build_path="${new_path#:}"
}


# Check Binary
# -----------------------------------
# DESC: Check a binary exists in the search path
# ARGS: $1 (required): Name of the binary to test for existence
#       $2 (optional): Set to any value to treat failure as a fatal error
# -----------------------------------
function check_binary {
    if [[ $# -ne 1 && $# -ne 2 ]]; then
        script_exit "Invalid arguments passed to check_binary()!" 2
    fi

    if ! command -v "$1" > /dev/null 2>&1; then
        if [[ -n ${2-} ]]; then
            script_exit "Missing dependency: Couldn't locate $1." 1
        else
            verbose_print "Missing dependency: $1" "${fg_red-}"
            return 1
        fi
    fi

    verbose_print "Found dependency: $1"
    return 0
}


# Check Super User
# -----------------------------------
# DESC: Validate we have superuser access as root (via sudo if requested)
# ARGS: $1 (optional): Set to any value to not attempt root access via sudo
# -----------------------------------
function check_superuser {
    if [[ $# -gt 1 ]]; then
        script_exit "Invalid arguments passed to check_superuser()!" 2
    fi

    local superuser test_euid
    if [[ $EUID -eq 0 ]]; then
        superuser="true"
    elif [[ -z ${1-} ]]; then
        if check_binary sudo; then
            pretty_print "Sudo: Updating cached credentials for future use..."
            if ! sudo -v; then
                verbose_print "Sudo: Couldn't acquire credentials..." \
                              "${fg_red-}"
            else
                test_euid="$(sudo -H -- "$BASH" -c 'printf "%s" "$EUID"')"
                if [[ $test_euid -eq 0 ]]; then
                    superuser="true"
                fi
            fi
        fi
    fi

    if [[ -z $superuser ]]; then
        verbose_print "Unable to acquire superuser credentials." "${fg_red-}"
        return 1
    fi

    verbose_print "Successfully acquired superuser credentials."
    return 0
}


# Run Script as Root
# -----------------------------------
# DESC: Run the requested command as root (via sudo if requested)
# ARGS: $1 (optional): Set to zero to not attempt execution via sudo
#       $@ (required): Passed through for execution as root user
# -----------------------------------
function run_as_root {
    local try_sudo
    if [[ ${1-} =~ ^0$ ]]; then
        try_sudo="true"
        shift
    fi

    if [[ $# -eq 0 ]]; then
        script_exit "Invalid arguments passed to run_as_root()!" 2
    fi

    if [[ $EUID -eq 0 ]]; then
        "$@"
    elif [[ -z ${try_sudo-} ]]; then
        sudo -H -- "$@"
    else
        script_exit "Unable to run requested command as root: $*" 1
    fi
}
