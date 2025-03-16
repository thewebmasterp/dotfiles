#!/usr/bin/env bash
# sway-idle

SCRIPT_DIR=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))  # https://stackoverflow.com/a/34208365/
swayLockUtils=$SCRIPT_DIR/sway-lock-utils.sh

pidof swayidle && killall -9 swayidle
exec swayidle -w \
     timeout 1 "" \
     resume "$swayLockUtils unblank" \
     timeout 10 "pidof swaylock && $swayLockUtils blank" \
     resume "$swayLockUtils unblank" \
     timeout ${XIDLEHOOK_BLANK:-900} "$swayLockUtils blank" \
     resume "$swayLockUtils unblank" \
     timeout ${XIDLEHOOK_LOCK:-1300} "$swayLockUtils lock" \
     resume "$swayLockUtils unblank" \
     timeout ${XIDLEHOOK_SUSPEND:-7200} "$swayLockUtils suspend" \
     resume "$swayLockUtils unblank" \
     lock "$swayLockUtils lock" \
     before-sleep "$swayLockUtils lock"
