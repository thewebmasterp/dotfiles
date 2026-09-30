#!/usr/bin/env bash
# darkman -> waybar: dark mode = Catppuccin Mocha.
# Only touches an untracked symlink; ~/.config/waybar/style.css never
# changes. Deliberately does NOT call `swaymsg reload` itself: sway.sh
# already reloads sway for every darkman switch, which re-triggers the
# exec_always in sway/config.d/waybar-config that restarts waybar (avoids a
# known crash when sending SIGUSR2 directly to the two waybar processes).
# Two independent `swaymsg reload` calls per switch raced that exec_always's
# own pkill-then-respawn guard and produced duplicate waybar processes.

ln -sfn "$HOME/.config/waybar/colors.css" \
	"$HOME/.local/state/theme/waybar-colors.css"

exit 0
