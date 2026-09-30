#!/bin/sh
# darkman -> Qt (qt5ct / qt6ct): light mode = Catppuccin Frappe.
#
# qt5ct/qt6ct keep a QFileSystemWatcher on their *config directory*, not on the
# config file. A directory watch only fires on create/rename/delete, so an
# in-place rewrite is invisible to it and an atomic rename is what triggers a
# live palette reload in every running Qt app.
#
# qt{5,6}ct.conf therefore permanently points color_scheme_path at the untracked
# state file below; this hook rewrites that state file and then rewrites
# qt{5,6}ct.conf with BYTE-IDENTICAL content purely to fire the watcher. The
# tracked config never changes content, so git stays clean.
#
# Requires style=Fusion: the Kvantum style supplies its own palette from its own
# config and never rebuilds it, which blocks live reloading entirely.

FLAVOUR=frappe

for v in 5 6; do
	src="/usr/share/qt${v}ct/colors/catppuccin-${FLAVOUR}-blue.conf"
	dst="$HOME/.local/state/theme/qt${v}-colors.conf"
	conf="$HOME/.config/qt${v}ct/qt${v}ct.conf"

	[ -r "$src" ] || continue
	cp -f "$src" "$dst" || continue

	# fire the directory watcher without altering tracked content
	[ -r "$conf" ] || continue
	tmp="$conf.reload"
	cp -p "$conf" "$tmp" && mv -f "$tmp" "$conf"
done

exit 0
