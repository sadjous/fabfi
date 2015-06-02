

# Introduction #

in the fabfi mesh, netwrowk debugging for any given node goes like this:

  1. [Can I see my neighbors?](#Find_your_Neighbors.md)
  1. [Do I have a gateway to the internet?](#Test_your_Gateway.md)
  1. [Can I resolve DNS?](#DNS.md)
  1. [Can I download web pages?](#Download_a_Webpage.md)

The following sections will outline how to answer each of these questions...

# Troubleshooting Procedures #

Go through the following subsections in order...

## Check that OLSR is running ##

Before doing anything, make sure the routing daemon is running by running:
```
$ ps
```
and searching for a line that includes this:
```
olsrd -f /var/etc/olsrd.conf -nofork 
```
You should see one or more of these lines.  If you don't, try restarting olsrd by running
```
$ /etc/init.d/olsrd restart
```
then checking the process list again.  Once olsrd is running, continue to the next step.


## Find your Neighbors ##

With the exception of nodes that have direct connections to the internet, every node needs to have at least one neighbor to reach the internet.  If you're dealing with a node that has a direct uplink to the internet, you may skip to the next section.

[OLSRD](http://www.olsr.org/), our mesh routing daemon, keeps a list of all its [link-local](http://en.wikipedia.org/wiki/Link-local_address) neighbors.  Check to determine if you have any link-local neighbors by logging into the router you're interested in and running:
```
$ echo '/links' | nc localhost 2006
```
You will be returned a list that looks something like this:
```
HTTP/1.0 200 OK
Content-type: text/plain

Table: Links
Local IP	Remote IP	Hyst.	LQ	NLQ	Cost
10.100.0.200	10.100.0.218	0.00	1.000	1.000	1.000	
10.100.0.200	10.100.0.211	0.00	1.000	1.000	1.000	
10.100.0.200	10.100.0.205	0.00	1.000	1.000	1.000	
```
where the local IP is from the device you're loged into and the Remote IP is a neighbor.  You should have an enry in this list for every link-local device you expect to be connecting to.

If you don't see the device you expect, check the physical connection as described [on this page](PhysicalLinkTroubleshooting.md).  Once your physical link is working, check the links list again. If you're still not seeing your link, try restarting olsrd as described in the previous section.

When everything is working, you should be able to ping any Remote IP in the links list like this:
```
$ ping 10.100.0.218
```
and receive replies.

## Test your Gateway ##

Every node will have at least two important gateways. in the simple case of two gateways, one is the link-local or "first hop" gateway and the other is the mesh's global internet gateway.  If a node is only one hop from the internet, these two will be the same.  In networking terms, a gateway is usually denoted by a route to
```
0.0.0.0
```

### Link-Local Gateway ###

You can find your link-local easily by running
```
route
```
the entry that starts with "default" like this:
```
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         10.100.0.7      0.0.0.0         UG    2      0        0 eth0
```
The gateway IP will be your link-local gateway.  When this node wants to send data to a place it does not have another explicit route to, it will send it to this IP.

Test this gateway by pinging it:
```
$ ping <ip of default route in routing table>

example: 10.100.0.7
```
If this fails, it is likely that the node you are trying to ping is locked up.  Reboot the other node and try again. Once `ping` succeeds, continue on to the global gateway.

### Global Gateway ###

In the Fabfi network, the global gateway is advertised by uplink nodes using Host and Network Association (HNA) Messages. List the HNA table by running
```
$ echo '/hna' | nc localhost 2006
```
the network listed as 0.0.0.0 is your uplink. If there is no such entry, try pinging the IP you expect the gateway to be at.  For fabfis numbered less than 254 this is usually:
```
10.100.0.<fabfinumber of gateway>
```
so
```
$ ping <IP of gateway>
```
If you get replies, then your gateway is active and olsr is not communicating the message about the gateway, otherwise go check that your gateway node is alive.  If you're sure your gateway is up but you son't have 0.0.0.0 HNA, try restarting olsr on your node with the command:
```
$ /etc/init.d/olsrd restart
```
then check your HNA list again after 30 seconds.  If you _still_ don't have hna, log into the gateway node and restart olsrd in the same manner.

If you STILL don't have HNA, check the uplink log on the gateway node:
```
$ cat /etc/fabfi-scripts/check-uplink.log
```
to make sure it includes this:
```
Fri Mar  4 20:00:01 UTC 2011 w-got master.mesh <--- this matters
Fri Mar  4 20:00:01 UTC 2011 getting name
Fri Mar  4 20:00:01 UTC 2011 dns is [10.100.0.8] (blank if not set in nameservice) <--- This matters
Fri Mar  4 20:00:01 UTC 2011 getting meshIP
Fri Mar  4 20:00:01 UTC 2011 getting meshIP
Fri Mar  4 20:00:01 UTC 2011 server already set  <--- This matters
```
If you see this jump to [ping test validation](#Validate_ping.md). If it ends in
```
server already cleared
```
then your uplink is not able to make web requests to the RADIUS server, which means either your internet is down or the RADIUS machine's webserver is down.  Try downloading another web page of your choice from the uplink node to test the web connection.  It should look like this (if it works):
```
root@fabfi8:~# wget -s http://google.com
Connecting to google.com (74.125.226.115:80)
Connecting to www.google.com (74.125.226.112:80)
root@fabfi8:~#
```
if it fails, you don't have a functional uplink. This is why everything is broken.  If it succeeds, log into your RADIUS server with ssh and check that apache is runnning.  Run:
```
$ ps -A
```
and look for one or more lines containing:
```
apache2
```
If you see it, the server might be hung.  If you don't, it's not running.  In either case try to restart it:
```
$ sudo /etc/init.d/apache2 restart
```
If this fixes your problem, you're done (it will take up to three minutes for the network to settle after realising that a gateway is available). Otherwise continue below

#### Ping Validation ####

OLSRD needs to be able to ping an external web site to ensure that it has a gateway to the internet.  Check this manually by testing if you can ping at least one address in the `olsrd_dyn_gw` plugin section of:
```
/etc/config/olsrd
```
If you cannot ping one of these addresses, but you CAN browse to a webpage, then manually add an entry where the IP is the local mesh address of the gateway node (so it's pinging itself).  THIS BREAKS AUTO-DISCOVERY OF GATEWAYS, but will fix your issue on a crappy internet connection. When you're done making modifications restart olsrd on the gateway node as described earlier.

Hopefully, this will get your gateway advertising...

## DNS ##

Finally, the network needs a local DNS server.  While any node can have an uplink, only "headnodes" can serve local DNS.  You can find out if your node has a DNS server by running
```
$ cat /var/resolv.conf.auto
```
If this file contains no IP addresses, you don't have DNS!

To solve this, find out what fabfi number the headnode is, and perform all the tests above on it.  Once they all succeed, restart olsrd on the local node and check the resolv file again.  Once you have a DNS server listed there, try to perform a local DNS lookup:
```
$ nslookup master.mesh
```
This should return the IP address of your cloud server.  If it does not, check that you have entries in
```
/etc/config/dhcp
```
on the headnode that look like this:
```
config 'domain'
	option 'name' 'time.mesh'
	option 'ip' '1.2.3.4'

config 'domain'
	option 'name' 'master.mesh'
	option 'ip' '1.2.3.4'

config 'domain'
	option 'name' 'radius.mesh'
	option 'ip' '1.2.3.4'
config 'domain'
	option 'name' 'map.mesh'
	option 'ip' '1.2.3.4'
```
where `1.2.3.4` is the IP of your cloud server.  If these entries exist check that dnsmasq is running on the headnode by running:
```
$ ps
```
and checking for a process with `dnsmasq` in the name.

dnsmasq can be restarted if it is absent or not working by running
```
$ /etc/init.d/dnsmasq restart
```


Once you have local DNS, try something on the web:
```
$ nslookup www.google.com
```
This should return an IP address.  If not, your headnode is not forwarding DNS requests to a functioning DNS server.  Check that your network settings on the headnode's uplink interface are correct.

## Download a Webpage ##

Finally, test that you can download a webpage on the node running chilli just like above:
```
root@fabfi8:~# wget -s http://google.com
Connecting to google.com (74.125.226.115:80)
Connecting to www.google.com (74.125.226.112:80)
root@fabfi8:~#
```
If this does not return happily and your gateway is running squid, it is likely that your squid server is not running.  Go to [SquidTroubleshooting](SquidTroubleshooting.md) to fix.

Otherwise, you should be back online.

_Be Careful: this test will pass on the gateway node even if squid is not running_