

# Introduction #

This is how the system works.  The first section describes the most important things the need to happen for the system to function properly. The rest describes the gory details.

## Required Signaling ##

There are three major components that need to talk to each other for the system to allow user connections:

  1. The radius server
  1. The headnode
  1. The the awesome-[chilli](http://coova.org/CoovaChilli) program on client access nodes. (Note: awesome-chilli is a config wrapper for coova-chilli)

In the system setup, The headnode must be configured with the correct [IP address](http://en.wikipedia.org/wiki/Ip_address) of the [RADIUS](http://en.wikipedia.org/wiki/RADIUS) Server (the RADIUS server is a server on the public internet that has been configured with the user database.  You will either set this server up yourself or be given the connection info for one that has been set up for you already) The headnode then advertises this RADIUS server address at the [urls](http://en.wikipedia.org/wiki/Url):
```
master.mesh
radius.mesh
map.mesh
time.mesh
```
_Note: it is currently only coincidence that map.mesh, master.mesh, and time.mesh are the same IP as the RADIUS server.  This is not required._

because all the nodes forward [DNS](http://en.wikipedia.org/wiki/Domain_Name_System) requests to their gateway, every node will automatically resolve the above urls to the correct IP without any special configuration.  (Notably, the urls above need to be listed in the 'uamallowed' option in the chilli config for each router. This should be the case by default)

  * When a client access node starts up, chilli will check its connection to the RADIUS server.  Chilli WILL NOT START if it cannot connect to the RADIUS server.

**Because Chilli provides [DHCP](http://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol) to clients, clients will not be able to connect to the wifi if chilli is not running**

**If chilli is started and it loses a connection to the RADIUS server it will continue to run, but will not be able to authenticate clients or show the remotely hosted portion of the splash page**

  * The headnode checks every two minutes on its [WAN](http://en.wikipedia.org/wiki/Wide_area_network) interface to see if it can download a page from the radius server (it also pings various sites as a backup). When this check succeeds, it advertises itself as a DNS server and an uplink (0.0.0.0) to the rest of the network. (This is done through olsrd-mod-dyn-gw (uplink) and the /etc/fabfi-scripts/check-uplink script (DNS)).  For the system to work, every node must add the address of the headnode to
```
/var/resolv.conf.auto.  
```
without this, nodes will not be able to resolve the urls listed above and chilli will not start.  The longest expected settle time for the network after the headnode gets an internet connection is about three minutes.

> _If the headnode is conncted to the internet but the leaf nodes are not updating their DNS, restarting olsr will usually resolve the problem._

This is done by running:
```
$ /etc/init.d/olsrd restart
```

_NOTE: As of 3/2011, olsrd-mod-dyn-gateway depends on [ping](http://en.wikipedia.org/wiki/Ping) to determine if it should advertise itself as a DNS server.  If ping is not reliable, this can be solved by setting the servers in the dyn-gw section of /etc/config/olsrd to the mesh ip of the headnode.  There is currently no fix for multiple uplink installations._

## Network Architecture and Addressing Conventions ##

Each Fabfi device has the ability to provide up to 6 subnets.  These Subnets are divided into three groups:

  * Infrastructure access
  * Client access
  * Administrative access

The **Infrstructure Access** group consists of subnets used to connect Fabfi devices with each other.  There are three infrastructure networks:

  * MESH: 10.100.0.0/22 (for wired connections)
  * WIFIMESH: 10.104.0.0/22 (for infrastructure mode wireless connections)
  * ADHOCMESH: 10.120.0.0/22 (for adhoc mode wireless connections)

All three networks transparently forward traffic to one another so as to be have as a single network (they are not bridged together into one because olsr does not support bridging).

Each fabfi device is given a unique number during setup.  The hex equivalent of this number makes up the class C and D octets of the unique address of each fabfi on every infrastructure subnet. For devices 1-254, the fabfi number will simply be the class D octet (example.  Fabfi 145 would have a MESH address of 10.100.0.145).  In general, most fabfis can always be reached on their MESH address.

> _Note: the nature of the the setup script does addressing requires fabfi numbers that would result in "special" class D octets (0, 255) not be used._

> _Note2: Pending the implementation of N-speeds for adhoc wireless, the ADHOCMESH network will be deleted and all wireless connections will be adhoc, running on the WIFIMESH network_

The **Client Access** group consists of networks used by clients to access the internet.  There are two such networks:

  * LAN: 10.112-115.0.0/24
  * TUNNEL: 10.116-119.0.0/24

Clients directly connect to the LAN network, however chilli captures the traffic and provides DHCP from the TUNNEL subnet.  The LAN subnet is isolated such that even if you manually configure yourself to connect to it, it won't pass traffic out of the subnet.

The **Administrative Access** networks are designed to give system administrators easy access to the system.  There are two "networks"

  * ALAN: 10.108-111.0.0/24
  * ALIAS: 192.168.1.10/24 (overlays MESH, devices are always 192.168.1.10)

The ALAN network is usually only seen on headnodes, while every device provides ALIAS on a MESH port.  This latter feature is both useful and dangerous.  For an isolated device, the administrator can be assured of connecting to the device at 192.168.1.10, but if multiple fabfi devices are on the same layer2 net, which device will respond is undefined.

> _NOTE: the ports and/or wireless interfaces used for each network are defined dynamically by the setup script._

## Wireless Network Partitioning ##

In the current iteration (changing soon) wireless devices can be in AP, STA or ADHOC mode.  The former two are only used now because N-speeds have yet to be fully achieved in ADHOC mode with the ath9k driver.

In AP/STA mode the wireless network is segmented by SSID/channel.  This is selected at configuration time where the user selects a channel and this will dictate a SSID in 1:1 correspondence with the channel.

In ADHOC mode, channel selection during setup selects both the channel and the BSSID.  BSSID is <channel in hex>:fa:bf:1f:ab:f1.

By selecting channels, it is possible to control topology and traffic flow of the network.

## System Block Diagram ##

The Image below describes how the different software components in the system are connected to each other

![http://fabfi.googlecode.com/svn/wiki/images/SystemArchitecture/block-diagram.png](http://fabfi.googlecode.com/svn/wiki/images/SystemArchitecture/block-diagram.png)

This is a simplified network layout

![http://fabfi.googlecode.com/svn/wiki/images/SystemArchitecture/overviewmap.jpg](http://fabfi.googlecode.com/svn/wiki/images/SystemArchitecture/overviewmap.jpg)

And a simplified diagram of how networks interact with the cloud server:

![http://fabfi.googlecode.com/svn/wiki/images/SystemArchitecture/cloudmap.jpg](http://fabfi.googlecode.com/svn/wiki/images/SystemArchitecture/cloudmap.jpg)