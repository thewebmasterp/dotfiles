#/usr/bin/env bash
# toggle-nmtui.sh

LOCKFILE=/tmp/toggle-nmtui.lock # Set the lock file location to whatever path you need

if [ -f $LOCKFILE ]; then
	swaymsg '[app_id="toggle-nmtui"] kill'
	exit 1
fi

touch $LOCKFILE

swaymsg '[app_id="toggle-bluetui"] kill'
swaymsg '[app_id="toggle-netscanner"] kill'
foot --app-id "toggle-nmtui" sh -c 'sleep 0.1; nmtui'

rm $LOCKFILE
