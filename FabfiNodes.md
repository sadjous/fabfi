

# Introduction #

This page explains how to build fabfi nodes.  While fabfi can run on many different types of hardware, there are essentially only two types of nodes: Common Nodes and Headnodes, as explained below

## Headnode ##

Headnodes are the control nodes for the network.  They do useful stuff like resolving local DNS names and communicating with the dashboard server.  Generally, they are also uplinks to the internet.

## Common Nodes ##

Common nodes are all the other nodes in the network.  They may or may not have uplinks and may or may not directly service clients.

# Process overview #

Turning an off-the-shelf wireless router into a fabfi has three major steps:
  1. Flash the router with custom [Fabfi firmware](http://code.google.com/p/fabfi/downloads/list)
  1. Log into the newly flashed device and run a configuration script.
  1. (optional) Manually edit the router files to create custom configurations not included in the configuration script.

The specifics of the process are different for each device.  Follow the links in the next section for device-specific instructions.


# Device Support and Installation Instructions #

It's likely that the current version of Fabfi will run on any ar71xx platform device, but the devices we've used and tested are:
  * [Linksys WRT160NL](LinksysWRT160NL.md)
  * [Ubiquiti NanoM5-loco](UbiquitiAR71xx.md)
  * [Ubiquiti NanoM2-loco](UbiquitiAR71xx.md)
  * [Ubiquiti PicoM2-HP](UbiquitiAR71xx.md)

We have not tested any other platforms or devices at this time.  **Click on the device above for detailed instructions**

# Reconfiguring and Upgrading Fabfi Devices #

### Fabfi Factory Reset ###

It is always possible to bring fabfi devices back to their "virgin", pre-setup-script state by running
```
firstboot
```
and rebooting the device.

we don't support bringing youre device back to the manufacturer's factory firmware.  Fabfi is a one-way street :)

### Firmware Upgrade ###

The fabfi firmware has a built-in utility to automatically download and install the newest firmware revision while retaining device settings.  It's not guaranteed foolproof, so test it on a device you can touch before trying it on a network halfway across the globe, but here's how you do it:

  1. log in to the router you want to upgrade
  1. run
```
$ sh /etc/fabfi-scripts/upgrade
```
  1. cross your fingers

_NOTE: If your router does not have the "upgrade" script, but instead has "upgrade-pre" copy the upgrade script to the router and run that instead of upgrade-pre_

the upgrade script is a wrapper for OpenWRT's `sysupgrade` functionality.  it will copy over all the files from:
```
PASS=/etc/passwd
CFG=/etc/config
GRP=/etc/group 
DRP=/etc/dropbear
FW=/etc/firewall.user 
RCL=/etc/rc.local
```

After rebooting the
```
/etc/fabfi-scripts/upgrade-post
```
script will run, making any required changes to the files listed above.

look at the [script source](http://code.google.com/p/fabfi/source/browse/trunk/files/router_configs/common/etc/fabfi-scripts/upgrade-post) for the version up are upgrading to for details on what will be changed in the config files.