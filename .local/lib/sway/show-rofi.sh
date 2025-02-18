#!/usr/bin/env bash
# show-rofi

SCRIPT_DIR=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))  # https://stackoverflow.com/a/34208365/
displaysConfiguration=$SCRIPT_DIR/displays-configuration.sh

if [ "$1" == "primary" ]; then
 rofi -config "~/.config/rofi/config.rasi" \
  -show "combi" \
  -combi-modi "drun,run" \
  -modi "combi,ssh,displays:${displaysConfiguration}" \
  -show-icons \
  -kb-cancel "Super_L" \
  -monitor -1

elif [ "$1" == "secondary" ]; then
 rofi -config "~/.config/rofi/config.rasi" \
  -theme-str "#element { children: [element-text]; }" \
  -show "notes" \
  -modi "notes:$HOME/node_modules/.bin/rofi-notes-org" \
  -kb-cancel "Super_L" \
  -monitor -1

else
  echo "Please specify which rofi configuration you want to show: primary, secondary"
fi
