#!/usr/bin/env bash
# darkman -> foot: light mode = Catppuccin Frappe ([colors-light]).
# Only writes to the untracked state dir; ~/.config/foot/foot.ini never
# changes (it just permanently includes this file).

printf 'initial-color-theme=light\n' > "$HOME/.local/state/theme/foot.ini"

# Live-update any already-running foot instances
pkill -SIGUSR2 -x foot 2>/dev/null
exit 0
