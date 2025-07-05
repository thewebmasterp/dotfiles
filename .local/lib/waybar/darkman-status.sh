#/usr/bin/env bash
# darkman-status.sh

class="light"
tooltip="Light Mode to scare the bugs"
percentage="0"

mode=$(darkman get)

if [[ "$mode" == "dark" ]]; then
	class="dark"
	tooltip="Dark Mode"
	percentage=100
fi

echo "{\"class\":\"$class\", \"percentage\":$percentage, \"tooltip\":\"$tooltip\"}"
