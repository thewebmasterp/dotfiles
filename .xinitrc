#!/bin/sh

systemctl --user import-environment DBUS_SESSION_BUS_ADDRESS DISPLAY PATH XDG_CACHE_HOME XDG_CONFIG_HOME XDG_DATA_HOME
systemctl --user --no-block start xsession.target

exec i3
