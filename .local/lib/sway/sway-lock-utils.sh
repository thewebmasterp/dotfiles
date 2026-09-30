#!/usr/bin/env bash
# sway-lock-utils

lock() {
    # Colors come from an untracked symlink managed by darkman
    # ({dark,light}-mode.d/swaylock.sh), which points at the static,
    # tracked colors-mocha.sh or colors-frappe.sh. This keeps
    # ~/.config/swaylock/config itself fully static (structural options
    # only) - only CLI color flags change between themes.
    local colorScript=~/.local/state/theme/swaylock-colors.sh
    local -a colorFlags=()
    # shellcheck disable=SC1090
    [ -r "$colorScript" ] && source "$colorScript" && colorFlags=("${SWAYLOCK_COLOR_FLAGS[@]}")

    pidof swaylock || swaylock -f -s fill -c 000000 "${colorFlags[@]}" "$@" &
}

swayDpms() {
	DPMS="${1:-on}"
	DISP="${2:-*}"
	currentDPMS="$(swaymsg -t get_outputs | jq -r '.[0]'.dpms)"
	[ "$dpms" != "$currentDPMS" ] && swaymsg "output $DISP DPMS $DPMS"
}

case "$1" in
    lock)
        shift
        lock "$@"
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
