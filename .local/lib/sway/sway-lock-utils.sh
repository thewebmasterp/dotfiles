#!/usr/bin/env bash
# sway-lock-utils

lock() {
    pidof swaylock || swaylock -f -s fill -c 000000 &
}

swayDpms() {
	DPMS="${1:-on}"
	DISP="${2:-*}"
	currentDPMS="$(swaymsg -t get_outputs | jq -r '.[0]'.dpms)"
	[ "$dpms" != "$currentDPMS" ] && swaymsg "output $DISP DPMS $DPMS"
}

case "$1" in
    lock)
        lock
        ;;
    logout)
        swaymsg exit
        ;;
    suspend)
        systemctl suspend && lock
        ;;
    hibernate)
        systemctl hibernate && lock
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
    blank)
        swayDpms off
        ;;
    unblank)
        swayDpms on
        ;;
    *)
        lock
        ;;
esac

exit 0
