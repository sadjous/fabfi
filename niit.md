# INTRODUCTION #

NIIT is a special linux kernel device that allows easy transmission of IPv4 unicast traffic through an IPv6 network. Niit works by first translating an IPv4 address to an IPv6 address in the IPv4-mapped-IPv6 address syntax.

Examples
```
	10.100.0.0/8    --> 0::ffff:10.100.0.0  104 --> 0::ffff:0a64:0000 104
	192.168.2.0/24  --> 0::ffff:192.168.2.0 120 --> 0::ffff:c0a8:0200 120   
	172.16.0.55/32  --> 0::ffff:172.16.0.55 128 --> 0::ffff:ac10:0037 128 
	0.0.0.0/0	--> 0::ffff:0.0.0.0	96  --> 0::ffff:0000:0000 96
```


Tip - to get the corresponding IPv6 netmask - add the IPv4 netmask to 96.

Niit then automatically tunnels IPv4 traffic and corresponding IPv6-mapped-IPv4 traffic to specially created interfaces ( niit4to6 and niit6to4 ).
These interfaces MUST be created manually and MUST be named accordingly.
The niit4to6 interface converts IPv4 addresses to IPv6 SIIT format then forwards the traffic to the IPv6 mesh.
For IPv4 traffic destined for the router's network, the niit6to4 interface converts the IPv4-mapped IPv6 addresses back to IPv4 then forwards them to the IPv4 network.

## CONFIGURATIONS ##

### NETWORK ###
Add the niit4to6 and niit6to4 interfaces - add these lines to your /etc/config/network file


config 'interface' 'niit4to6'
> option 'proto' 'none'
> option 'ifname' 'niit4to6'

config 'interface' 'niit6to4'
> option 'proto' 'none'
> option 'ifname' 'niit6to4'

### OLSR ###

By default, OLSR is configured to use Niit, but for completeness, add the UseNiit option to your olsrd configuration file

`uci set olsrd.@olsrd[0].UseNiit=yes`

Add your router's IPv4-mapped IPv6 address/addresses to your router's hna6 in your olsrd configuration file ( /etc/config/olsrd )

e.g to add 192.168.1.1 and the network 192.168.2.0/24

uci add olsrd Hna6
olsrd.@Hna6[-1].netaddr=0::ffff:c0a8:0101
olsrd.@Hna6[-1].prefix=128


uci add olsrd Hna6

olsrd.@Hna6[-1].netaddr=0::ffff:c0a8:0200

olsrd.@Hna6[-1].prefix=120



or add the lines to /var/etc/olsrd.conf

Hna6 { 0::ffff:c0a8:0101 128 }

Hna6 { 0::ffff:c0a8:0200 96 }


then restart olsrd `/etc/init.d/olsrd restart`

To broadcast an IPv4 gateway add

Hna6 { 0::ffff:0000:0000 96 } to olsrd config file or

uci add olsrd Hna6

olsrd.@Hna6[-1].netaddr=0::ffff:0:0

olsrd.@Hna6[-1].prefix=96


### FIREWALL ###

Set your firewall to allow forwarding of traffic between the niit4to6 , niit6to4 and other interfaces on your router ( as necessary )

Restart firewall

/etc/init.d/firewall restart


The IPv4 routing table in every router should look like

```
#ip r
default dev niit4to6  scope link  metric 2 
192.168.1.0/24 dev eth0  proto kernel  scope link  src 192.168.1.1 
192.168.1.3 dev niit4to6  scope link  metric 2 
192.168.1.4 dev niit4to6  scope link  metric 2 
192.168.1.5 dev niit4to6  scope link  metric 2 
192.168.1.6 dev niit4to6  scope link  metric
.
.
.
```

The IPv6 routing table in every router

```
#ip -6 r

::ffff:192.168.1.1 dev niit6to4  metric 2 
::ffff:192.168.1.3 via 2001:470:1f08:1b61::104:3 dev wlan0  metric 2 
::ffff:192.168.1.4 via 2001:470:1f08:1b61::100:7 dev eth0  metric 2 
::ffff:192.168.1.5 via 2001:470:1f08:1b61::100:7 dev eth0  metric 2 
::ffff:192.168.1.6 via 2001:470:1f08:1b61::100:7 dev eth0  metric 2 
::ffff:192.168.1.7 via 2001:470:1f08:1b61::100:7 dev eth0  metric 2 
::ffff:192.168.2.1 dev niit6to4  metric 2 
::ffff:192.168.2.3 via 2001:470:1f08:1b61::104:3 dev wlan0  metric 2 
::ffff:192.168.2.4 via 2001:470:1f08:1b61::100:7 dev eth0  metric 2
.
.
.
.
```

Ping to confirm the results

## References ##

https://dev.dd19.de/~alx/alx-niit/Niit%20presentation.pdf

http://wiki.freifunk.net/Niit

http://svn.dd-wrt.com:8000/browser/src/router/olsrd/README-Olsr-Extensions?rev=14710

http://www.qmp.cat/redmine/issues/49