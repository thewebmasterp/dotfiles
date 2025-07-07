#!/bin/bash
# nextcloud-client-startup.sh

while ! $(secret-tool lookup Title Nextcloud &> /dev/null); do
	echo "Waiting for Nextcloud secret service..."
	sleep 3s
done

/usr/bin/nextcloud --background
