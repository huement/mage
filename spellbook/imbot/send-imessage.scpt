on run argv
	set message to item 1 of argv
	set chatNumber to item 2 of argv as integer
	tell application "Messages" to send message to item chatNumber of text chats
end run

tell application "Messages"
    set serviceID to get id of first service
    set theRecipient to buddy "${RECIPIENT}" of service id serviceID
    send "${MESSAGE}" to theRecipient
end tell