#!/bin/sh
# darkman -> Neovim (Catppuccin): light mode = Frappe.
#
# Neovim's own config never watches any file. Instead, every running
# instance starts an RPC socket under ~/.local/state/theme/nvim-sockets/
# (see ~/.config/nvim/lua/theme.lua). This hook writes the untracked state
# file that instances read on startup, then calls back into every live
# socket it finds so already-open instances repaint immediately too.

STATE_DIR="$HOME/.local/state/theme"
SOCKET_DIR="$STATE_DIR/nvim-sockets"

mkdir -p "$STATE_DIR"
echo light > "$STATE_DIR/nvim-background"

[ -d "$SOCKET_DIR" ] || exit 0
for sock in "$SOCKET_DIR"/*.sock; do
	[ -S "$sock" ] || continue
	if ! timeout 2 nvim --server "$sock" --remote-expr 'v:lua.CatppuccinSync()' >/dev/null 2>&1; then
		# stale socket from a crashed instance - clean it up
		rm -f "$sock"
	fi
done

exit 0
