#/usr/bin/env bash
# toggle-btrfs-assistant.sh

LOCKFILE=/tmp/toggle-btrfs-assistant.lock # Set the lock file location to whatever path you need

if [ -f $LOCKFILE ]; then
	swaymsg '[class="Btrfs Assistant"] kill'
	exit 1
fi

touch $LOCKFILE

wsudo btrfs-assistant

rm $LOCKFILE


