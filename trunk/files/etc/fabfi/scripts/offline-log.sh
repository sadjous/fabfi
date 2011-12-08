#!/bin/ash

/usr/bin/lua /etc/fabfi/scripts/wlan_status.lua

/bin/ash /etc/fabfi/scripts/iface_graphs.sh
