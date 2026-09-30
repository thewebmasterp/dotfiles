#!/usr/bin/env bash
# darkman -> foot: dark mode = Catppuccin Mocha ([colors-dark]).
# Only writes to the untracked state dir; ~/.config/foot/foot.ini never
# changes (it just permanently includes this file).

printf 'initial-color-theme=dark\n' > "$HOME/.local/state/theme/foot.ini"

# Live-update any already-running foot instances
pkill -SIGUSR1 -x foot 2>/dev/null
exit 0
