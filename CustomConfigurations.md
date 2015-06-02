

# Introduction #

This page contains instructions for semi-common custom configurations that aren't yet included in the auto-config script


# Static WAN IP #

view the existing config:
```
$ uci show network.wan
```

change the config:
```
uci set network.wan.proto=static
uci set network.wan.ifname=eth1
uci set network.wan.ipaddr=(your desired ip address)
uci Set network.wan.netmask=(ask.whoever.gave.you.above.address)
uci set network.wan.gateway=(ask.whoever.gave.you.above.address)
uci set network.wan.dns=8.8.8.8
uci commit network
```

# USB Modem WAN #

If you're using a USB Modem as an internet connection, follow [these instructions](USBModem.md) to run the USB Modem directly with the linksys.
