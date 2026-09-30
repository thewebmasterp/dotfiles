#!/usr/bin/env bash
# darkman -> rofi: dark mode = Catppuccin Mocha.
# Only writes to the untracked state dir; ~/.config/rofi/config.rasi
# never changes (it just permanently imports this file). rofi reads
# config fresh on every launch, so no reload/signal is needed.

printf '@import "~/.config/rofi/colors-mocha.rasi"\n' \
	> "$HOME/.local/state/theme/rofi.rasi"
exit 0
