#!/usr/bin/env bash
# rofi script-mode modi backed by cliphist.
#
# Used as `-modi "clipboard:/path/to/this"` in show-rofi.sh so clipboard
# history shows up as a normal rofi tab. On initial call it lists history
# (id hidden, preview shown); on selection it decodes the chosen entry and
# copies it back onto the clipboard.

case "$ROFI_RETV" in
  1)
    # An entry was selected. ROFI_INFO holds the full "id<TAB>preview" line,
    # which cliphist decode consumes robustly (newline-tolerant).
    [ -n "$ROFI_INFO" ] && printf '%s' "$ROFI_INFO" | cliphist decode | wl-copy
    exit 0
    ;;
esac

# Initial render: set the tab prompt and disallow free-text custom entries.
printf '\0prompt\x1fclipboard\n'
printf '\0no-custom\x1ftrue\n'

# One row per history entry: show the preview, stash the full line in `info`.
cliphist list | while IFS= read -r line; do
    preview=${line#*$'\t'}
    printf '%s\0info\x1f%s\n' "$preview" "$line"
done
