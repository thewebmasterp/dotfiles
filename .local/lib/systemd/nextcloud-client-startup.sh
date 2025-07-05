#!/bin/bash
# nextcloud-client-startup.sh

LOCAL_KEYS=~/Predicates/LocalKeys.kdbx
SHARED_KEYS=~/Predicates/shared/Main.kdbx

# /usr/bin/keepassxc --minimized "$LOCAL_KEYS" &

while ! $(secret-tool lookup Title Nextcloud &> /dev/null); do
	# /usr/bin/keepassxc --minimized "$LOCAL_KEYS"
	echo "Waiting for Nextcloud secret service..."
	sleep 3s
done

# (sleep 2 && /usr/bin/keepassxc "$SHARED_KEYS") &

/usr/bin/nextcloud --background
