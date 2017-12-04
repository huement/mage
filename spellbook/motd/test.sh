exit_with_error() {
  echo "err | color=red";
  exit 1;
}

#/usr/local/bin/brew update > /dev/null || exit_with_error;

# PINNED=$(/usr/local/bin/brew list --pinned);
# OUTDATED=$(/usr/local/bin/brew outdated --quiet);
#
# UPDATES=$(comm -13 <(for X in "${PINNED[@]}"; do echo "${X}"; done) <(for X in "${OUTDATED[@]}"; do echo "${X}"; done))
#
# UPDATE_COUNT=$(echo "$UPDATES" | grep -c '[^[:space:]]');
#
# echo "↑$UPDATE_COUNT | dropdown=false"
# echo "---";
# if [ -n "$UPDATES" ]; then
#   echo "Upgrade all | bash=/usr/local/bin/brew param1=upgrade terminal=false refresh=true"
#   echo "$UPDATES" | awk '{print $0 " | terminal=false refresh=true bash=/usr/local/bin/brew param1=upgrade param2=" $1}'
# fi
#
# exit 1


INFO=$(uptime | sed 's/^ *//g')
IFS="  " read -a myarray <<< $(uptime | sed 's/^ *//g')
LOADAVGS="${myarray[7]}|${myarray[8]}|${myarray[9]}"

echo "$INFO" | awk -F'[ ,:\t\n]+' '
    {
        PLURAL = 1
        VERBOSE = 0

        SEP = ", "

        DS = " day"
        HS = " hr"
        MS = " min"
        SS = " sec"

        ################################

        D = H = M = S = 0
        if (substr($5,0,1) == "d") {
        # up for a day or more
            D = $4

            P = $6
            Q = $7
        } else {
            P = $4
            Q = $5
        }

        if (int(Q) == 0) {
        # words evaluate to zero
        # exact times format, like `P = 55`, `Q = secs`
            Q = substr(Q,0,1)

            if (Q == "h") { H = P }
            else if (Q == "m") { M = P }
            else if (Q == "s") { S = P }
        } else {
        # hh:mm format, like `P = 4`, `Q = 20`
            H = P
            M = Q
        }

        MSG = "↑ " include(D, DS, SEP, PLURAL)
        MSG = MSG  include(H, HS, SEP, PLURAL, (D > 0 && VERBOSE))
        MSG = MSG  include(M, MS, SEP, PLURAL, (D > 0 && VERBOSE))
        MSG = MSG  include(S, SS, SEP, PLURAL)

        # remove the remaining SEP
        MSG = substr(MSG, 0, length(MSG) - length(SEP))
        printf "[ $MSG"
    }

    function include(VAL, UNIT, SUFFIX, PLURAL, VERBOSE) {
        VAL = int(VAL)

        if (PLURAL && VAL != 1) {
            UNIT = UNIT"s"
        }

        if (VAL > 0 || VERBOSE) {
            return (VAL UNIT SUFFIX)
        } else {
            # return ""
        }
}'
echo -en "${LOADAVGS} ]"
echo "---"
#echo "$INFO" | tr "," " " | tail -n 2
