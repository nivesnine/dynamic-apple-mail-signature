#!/bin/bash

USERNAME=`/usr/bin/whoami`
STAMP=`date +"%s"`
LOCATION="/Users/$USERNAME/temp-$STAMP"

mkdir $LOCATION

/usr/bin/osascript -e 'tell app "finder" to activate' -e 'tell app "finder" to display dialog "Please enter the URL to your image" & return default answer "" with icon 1 with title "Mail Setup"' >> $LOCATION/tmp.txt

echo "tell application \"mail\"" >> $LOCATION/setup.applescript
echo "activate" >> $LOCATION/setup.applescript
echo "end tell" >> $LOCATION/setup.applescript
echo "tell application \"System Events\"" >> $LOCATION/setup.applescript
echo "set frontmost of application process \"Mail\" to true" >> $LOCATION/setup.applescript
echo "delay 1"	 >> $LOCATION/setup.applescript
echo "tell application process \"Mail\"" >> $LOCATION/setup.applescript
echo "keystroke \",\" using command down" >> $LOCATION/setup.applescript
echo "delay 1"	 >> $LOCATION/setup.applescript
echo "tell application \"mail\"" >> $LOCATION/setup.applescript
echo "display dialog \"Please add a new signature with 'mark' as a placeholder, you may name it anything you would like to.\""  >> $LOCATION/setup.applescript
echo "end tell" >> $LOCATION/setup.applescript
echo "end tell" >> $LOCATION/setup.applescript
echo "end tell" >> $LOCATION/setup.applescript

/usr/bin/osascript $LOCATION/setup.applescript

T=true

while $T; do
        TEST=`grep -R "mark" ~/Library/Mail/V4/MailData/Signatures/*.mailsignature`
        if [[ $TEST != "" ]] ; then
                T=false;
                FILENAME=`echo $TEST | awk -F ":" '{print $1}'`
		echo $FILENAME
		/usr/bin/osascript -e 'tell app "mail" to quit'
		IMG=`cat $LOCATION/tmp.txt | awk -F ":" '{print $3 ":" $4}'`
		sed -i -e "s{mark{<img src='$IMG'>{" $FILENAME
		chflags uchg $FILENAME
		rm -rf $LOCATION
		/usr/bin/osascript -e 'tell app "mail" to activate'
	fi
done
