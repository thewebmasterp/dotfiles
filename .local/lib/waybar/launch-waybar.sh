#!/usr/bin/env bash
# launch-waybar.sh — machine-agnostic waybar launcher
#
# Global default: a single bar using ~/.config/waybar/config.jsonc, works on
# any machine. If ~/.config/waybar/local-bars.conf exists (untracked,
# machine-local override), each non-empty non-# line in it names a waybar
# config to launch instead — one bar per line. All bars share style.css.

pkill -x waybar
sleep 0.3

conf="$HOME/.config/waybar/local-bars.conf"
style="$HOME/.config/waybar/style.css"

launched=0
if [[ -f "$conf" ]]; then
	while IFS= read -r line; do
		[[ -z "$line" || "$line" == \#* ]] && continue
		line="${line/#\~/$HOME}"
		waybar -c "$line" -s "$style" &
		launched=1
	done < "$conf"
fi

if ((launched == 0)); then
	waybar -c "$HOME/.config/waybar/config.jsonc" -s "$style" &
fi
