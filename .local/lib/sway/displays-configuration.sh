#!/usr/bin/env bash
# displays-configuration

if [ $# -gt 0 ]; then
	kanshictl switch "$@"
	exit 0
fi

if swaymsg -t get_outputs | grep -q '75K6L04' && swaymsg -t get_outputs | grep -q 'F4K6L04'; then
	echo "horizontal side by side"
	echo "left horizontal right vertical"
	echo "left vertical right horizontal"
else
	echo "single screen"
	echo "single screen 90deg"
	echo "single screen 270deg"
fi

