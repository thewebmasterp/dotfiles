#!/usr/bin/env bash
# darkman -> mako: light mode = Catppuccin Frappe.
# Only writes to the untracked state dir; ~/.config/mako/config never
# changes (it just permanently includes this file).

printf 'include=~/.config/mako/colors-frappe\n' > "$HOME/.local/state/theme/mako"

makoctl reload 2>/dev/null
exit 0
