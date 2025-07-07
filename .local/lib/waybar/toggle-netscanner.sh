#/usr/bin/env bash
# toggle-netscanner.sh

LOCKFILE=/tmp/toggle-netscanner.lock # Set the lock file location to whatever path you need

if [ -f $LOCKFILE ]; then
	swaymsg '[app_id="toggle-netscanner"] kill'
	exit 1
fi

touch $LOCKFILE

swaymsg '[app_id="toggle-bluetui"] kill'
swaymsg '[app_id="toggle-nmtui"] kill'
foot --app-id "toggle-netscanner" sh -c 'sudo netscanner'

rm $LOCKFILE
