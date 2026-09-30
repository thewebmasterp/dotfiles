#!/usr/bin/env bash
# darkman -> mako: dark mode = Catppuccin Mocha.
# Only writes to the untracked state dir; ~/.config/mako/config never
# changes (it just permanently includes this file).

printf 'include=~/.config/mako/colors-mocha\n' > "$HOME/.local/state/theme/mako"

makoctl reload 2>/dev/null
exit 0
