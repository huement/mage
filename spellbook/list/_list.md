## List

### Information at your fingertips!
Think of this as your own, customizable Man pages. Store helpful tips and hard to remember items about anything and everything.

### Always ready
List works by scanning the list folder for any shell script. So simply toss one in there and it will automatically show up as an option.

### Required Format
In order to have your informational tidbit show up and display properly, you will need to follow one simple rule. You script must be initialized via a function called: DisplayInfo()

```bash
DisplayInfo() {
	echo "${B_YLW}${BLK}  HOMESTEAD - Vagrant + Laravel  ${NORMAL}";
	echo "${BGRN}vagg   ${BBLU}vagrant global-status ${WHT}- Display all Vagrant box statuses.";
	echo "${BGRN}vags   ${BBLU}homestead status      ${WHT}- Only homestead box status";
	echo "${BGRN}vagu   ${BBLU}homestead up          ${WHT}- Spin up the homestead box";
	echo "${BGRN}vagssh ${BBLU}homestead ssh         ${WHT}- Connect to active homestead box";
	echo "${BGRN}vagre  ${BBLU}homestead reload      ${WHT}- Reset and reprovision homestead";
	echo "${NORMAL}";
}
```

### Write tool
Obviously taking the time to create a colored list like the above example is fairly straightforward and simple, getting the layout just right and correct color codes would be tedious and timeconsuming. 

Thats why you can simply generate a document via our built in template system.

```bash
# command format
$ mage list [list_name] [list_keyword] [list_keyword_desc]

$ mage list homestead "Artisan Cmd_custom" "This is my custom artisan command's details."
```