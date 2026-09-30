#!/usr/bin/env bash
# darkman -> tmux: light mode = Catppuccin Frappe.
# Only writes to the untracked state dir; ~/.config/tmux/tmux.conf never
# changes (it just permanently source-files this file).

printf 'source-file ~/.config/tmux/theme-frappe.conf\n' \
	> "$HOME/.local/state/theme/tmux"

# Live-update the running server, if any (options are server-wide)
if tmux list-sessions >/dev/null 2>&1; then
	tmux source-file "$HOME/.local/state/theme/tmux" >/dev/null 2>&1
fi
exit 0
