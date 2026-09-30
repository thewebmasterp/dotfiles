#!/usr/bin/env bash
# darkman -> sway: light mode = Catppuccin Frappe.
# Only writes to the untracked state dir; ~/.config/sway/config never
# changes (it just permanently includes this file).

printf 'include ~/.config/sway/config.d/theme-frappe\n' \
	> "$HOME/.local/state/theme/sway"

swaymsg reload 2>/dev/null
exit 0
