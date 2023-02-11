#!/bin/sh

fsystemctl --user import-environment PATH DBUS_SESSION_BUS_ADDRESS DISPLAY
systemctl --user --no-block start xsession.target

exec i3
