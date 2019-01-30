#!/usr/bin/env bash

#RVAR=$(awk 'BEGIN {srand(); print int(6 * rand()) + 1}')
RVAR=3
RESULT=$(fortune)


realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

if [ "$RVAR" == 1 ]; then
	NOWT=$(date +"%r");
	RESULT="The time is ${NOWT}";
fi

if [ "$RVAR" == 2 ]; then
	RESULT=$(fortune);
fi

if [ "$RVAR" == 3 ]; then
	RN=$((1 + RANDOM % 10))
	opt=$(curl -s -H "User-Agent: cli:bash:v0.0.0 (by /u/codesharer)" https://www.reddit.com/r/awwnime/.json | jq ".data.children[${RN}].data.url");
	RES=$(sed -e 's/^"//' -e 's/"$//' <<<"$opt")
	#wget -O img.jpg $RES
	RESULT="Checkout this pic! ${RES}"
fi

if [ "$RVAR" == 4 ]; then
	DICE=$(awk 'BEGIN {srand(); print int(6 * rand()) + 1}');
	RESULT="You Rolled a ${DICE}";
fi

if [ "$RVAR" == 5 ]; then
	# Keep this updated when you add or take away quotes on the case list
	num_quotes=10
 
	# Generate a random quote number variable, 'rand'
	rand=$[ ( $RANDOM % $num_quotes ) + 1 ]
	case $rand in  #BEGIN CASE
	        1) quote="Some things Man was never meant to know. For everything else, there's Google.";;
	        2) quote="The Linux philosophy is 'Laugh in the face of danger. Oops. Wrong One. 'Do it yourself'. Yes, that's it.  -- Linus Torvalds";;
	        3) quote="... one of the main causes of the fall of the Roman Empire was that, lacking zero, they had no way to indicate successful termination of their C programs. -- Robert Firth";;
	        4) quote="There are 10 kinds of people in the world, those that understand trinary, those that don't, and those that confuse it with binary.";;
	        5) quote="My software never has bugs. It just develops random features.";;
	        6) quote="The only problem with troubleshooting is that sometimes trouble shoots back.";;
	        7) quote="If you give someone a program, you will frustrate them for a day; if you teach them how to program, you will frustrate them for a lifetime.";;
	        8) quote="You know you're a geek when... You try to shoo a fly away from the monitor with your cursor. That just happened to me. It was scary.";;
	        9) quote="We all know Linux is great... it does infinite loops in 5 seconds. - Linus Torvalds about the superiority of Linux on the Amterdam Linux Symposium";;
	        10) quote="By golly, I'm beginning to think Linux really *is* the best thing since sliced bread.  -- Vance Petree, Virginia Power";;
	esac  # END CASE
 
	# Display the random quote from case statement, and format it to line wrap at 80 characters
	RESULT="$quote"
fi

if [ "$RVAR" == 6 ]; then
	RESULT=$(fortune);
fi

RECIPIENT="+17017307628" # DALE
#RECIPIENT="+17012387363" # MARK

cat << EOF > /tmp/send_imessage.scpt
tell application "Messages"
	activate --steal focus
	set targetBuddy to "${RECIPIENT}"
	set targetService to id of service "SMS"
	set textMessage to "${RESULT}"
	set theBuddy to buddy targetBuddy of service id targetService
	send textMessage to theBuddy
end tell
EOF

#echo "$RESULT"
osascript /tmp/send_imessage.scpt
rm -f /tmp/send_imessage.scpt

echo ""
echo "iMessage Sent!"
echo ""

exit 0
# osascript send-imessage-pic.scpt `realpath northamerica-neb.jpg` "Homam Hosseini"