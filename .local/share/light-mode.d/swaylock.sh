#!/usr/bin/env bash
# darkman -> swaylock: light mode = Catppuccin Frappe.
# Only touches an untracked symlink; ~/.config/swaylock/config and
# sway-lock-utils.sh never change. swaylock is invoked fresh each time
# it locks the screen, so no reload/signal is needed.

ln -sfn "$HOME/.config/swaylock/colors-frappe.sh" \
	"$HOME/.local/state/theme/swaylock-colors.sh"
exit 0
