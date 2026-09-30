#!/usr/bin/env bash
# water.sh — daily water glass counter
# usage: water.sh [inc|dec]

state="$HOME/.local/state/waybar-water"
today=$(date +%F)

[[ -f "$state" ]] && read -r day count < "$state"
[[ "$day" == "$today" ]] || count=0

case "$1" in
	inc) ((count++)) ;;
	dec) ((count > 0)) && ((count--)) ;;
esac

[[ -n "$1" ]] && echo "$today $count" > "$state"

class="low"
((count >= 7)) && class="hydrated"

echo "{\"text\":\"$count\", \"class\":\"$class\"}"
