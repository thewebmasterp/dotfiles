#!/bin/bash

while ! $(secret-tool lookup Title Nextcloud &> /dev/null); do
	echo "wait"
	sleep 3s
done

(sleep 5 && /usr/bin/keepassxc ~/Predicates/shared/Main.kdbx)&

/usr/bin/nextcloud --background
