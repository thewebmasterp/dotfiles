#/usr/bin/env bash
# toggle-bluetui.sh

LOCKFILE=/tmp/toggle-bluetui.lock # Set the lock file location to whatever path you need

if [ -f $LOCKFILE ]; then
	swaymsg '[app_id="toggle-bluetui"] kill'
	exit 1
fi

touch $LOCKFILE

swaymsg '[app_id="toggle-netscanner"] kill'
swaymsg '[app_id="toggle-nmtui"] kill'
foot --app-id "toggle-bluetui" sh -c 'bluetui'

rm $LOCKFILE


