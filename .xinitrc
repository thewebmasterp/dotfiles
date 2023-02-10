#exec ~/.bin/startdwm
#exec dwm

systemctl --user import-environment PATH DBUS_SESSION_BUS_ADDRESS DISPLAY
systemctl --user --no-block start xsession.target

exec i3

#/usr/bin/xmodmap -e "keycode 108 = Super_L" # reassign Alt_R to Super_L
#/usr/bin/xmodmap -e "remove mod1 = Super_L" # make sure X keeps it out of the mod1 group

#exec ~/.bin/startdwm

#picom -b --dbus &
#sleep 1s && dunst &
