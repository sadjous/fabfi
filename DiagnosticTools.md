# Introduction #

If you were stuck on a Fabfi Island, the following tools would come to your rescue:

First, some very basic ( but extremely important ) ones

**ps** - Ubiquitous in the Unix world - used to check for running processes. Often used in conjunction with grep to check for a specific process. e.g, to check if chilli is running, type

```
ps aux | grep -i chilli`
1398 root      2416 S    /usr/sbin/chilli --dhcpif=wlan0 --tundev=tun0 --net=1
3425 root      1388 S    grep chilli 
```
is what you'd get if chilli was running.

For more on ps, [click here](http://unixhelp.ed.ac.uk/CGI/man-cgi?ps)

**logread** - Many processes log their activities. If, for example, a process fails to start and you cant figure out why, try running it, then do a logread.
use `logread -f` to view the log continuously

**iperf** - Used to measure throughput between two nodes.

**ip** - iproute2. A very powerful tool. We'll only use its most basic functionalities. Find more documentation [here](http://policyrouting.org/iproute2-toc.html). IP can be used to: add,delete and show status of addresses, routes, tunnels, links, neighbours etc

**ifconfig** - View active interfaces, bring interfaces up or down.

**iwconfig** - this is like an ifconfig for wireless interfaces.

**iw** - for managing wireless interfaces. More powerful than iwconfig. [documentation](http://linuxwireless.org/en/users/Documentation/iw)

**tcpdump** - A packet analyzer. Very useful for advanced diagnostics.

**nc** ( netcat ) -

**nmap** -

**ss/netstat** - View current network connections. ss is part of iproute2

traceroute**-**

**nslookup/dig** - use to check if node is resolving DNS. e.g nslookup google.com

**firstboot** - When mistakes are beyond repair. `firstboot` restores a device to a "just flashed state".

### To Measure Throughput between nodes ###


Run the iperf server on one node and iperf client the other. For example if 10.100.0.2 and 10.100.0.3 are two nodes and we want to measure the throughput between them, on one of them (2), run
iperf -s
```
root@fabfi2:~# iperf -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------


```

on the other (3), run `iperf -c 10.100.0.2`

```
root@fabfi3:~# iperf -c 10.100.0.2
------------------------------------------------------------
Client connecting to 10.100.0.2, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 10.100.0.3 port 34367 connected with 10.100.0.2 port 5001
```

After some time, the throughput between the two nodes will be displayed.

```
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec   106 MBytes  88.4 Mbits/sec
```

### Show interface information ###


#### List Interfaces ####
Use

> `ifconfig`

or

`ip link list`.

The difference is that `ifconfig` lists only active interfaces; `ip link list` will show both active and down interfaces.

To show only wireless interfaces, use `iwconfig`

e.g
```
                                                                                                                                            
eth0      no wireless extensions.

eth0.1    no wireless extensions.

eth1      no wireless extensions.

wlan0     IEEE 802.11bgn  ESSID:off/any  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=27 dBm   
          RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off

```

non-wireless interfaces will have the "no wireless extensions" message next to them.

#### To Show interface IP address ####

ifconfig will also show the ip address on every interface ( `ip address show` )

e.g to view the IP address on interface eth1, use `ifconfig eth1` or `ip address show dev eth1`


#### To bring an Interface Up of Down ####

For example, if eth1 is the interface we'd like to manage:

`ifconfig eth1 down`

or

> `ip link set dev eth1 down`

would bring down the interface.

`ifconfig eth1 up`

or

> `ip link set dev eth1 up`

would bring up the interface.

For wireless interfaces, use

`wifi up` or `wifi down`


#### Show interface statistics ####

Use `ifconfig` or `ip -statistics link` (`ip -s link`)

### To show Wireless Signal Strength (& other wireless interface statistics) ###

For station devices, use either `iw` or `iwconfig`.

for example, if wlan0 is the name of your wireless interface

```
fabfi@fabfi-AO532h:~$iwconfig wlan0
wlan0     IEEE 802.11bgn  ESSID:fabfi-foo  
          Mode:Managed  Frequency:2.437 GHz  Access Point: 68:7F:74:91:36:01   
          Bit Rate=65 Mb/s   Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=63/70  Signal level=-47 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
```

or use iw dev wlan0 link

```
fabfi@fabfi-AO532h:~$ iw dev wlan0 link
Connected to 68:7f:74:91:36:01 (on wlan0)
SSID: fabfi-foo
freq: 2437
RX: 38735067 bytes (122493 packets)
TX: 9411870 bytes (24502 packets)
signal: -44 dBm
tx bitrate: 65.0 MBit/s MCS 7
```

For access points, to check signal strength for every connected station, use

iw dev wlan0 station dump

e.g
```
root@fabfi98:~# iw dev wlan0 station dump 
Station 00:1f:e2:cf:13:c4 (on wlan0)
        inactive time:  9830 ms
        rx bytes:       31665
        rx packets:     364
        tx bytes:       41650
        tx packets:     176
        tx retries:     3
        tx failed:      0
        signal:         -76 dBm
        signal avg:     -75 dBm
        tx bitrate:     48.0 MBit/s
        rx bitrate:     54.0 MBit/s
Station 00:18:de:7a:fb:0e (on wlan0)
        inactive time:  1670 ms
        rx bytes:       1066147
        rx packets:     5921
        tx bytes:       4357609
        tx packets:     5165
        tx retries:     1655
        tx failed:      6
        signal:         -81 dBm
        signal avg:     -84 dBm
        tx bitrate:     54.0 MBit/s
        rx bitrate:     54.0 MBit/s
Station 70:f1:a1:1c:78:d8 (on wlan0)
        inactive time:  10 ms
        rx bytes:       6342190
        rx packets:     46604
        tx bytes:       58299436
        tx packets:     56402
        tx retries:     30397
        tx failed:      2
        signal:         -98 dBm
        signal avg:     -100 dBm
        tx bitrate:     26.0 MBit/s MCS 3
        rx bitrate:     26.0 MBit/s MCS 3
```

Note: iw dev wlan0 station dump would also work in station and adhoc devices


### Adjust Wireless interface Transmit Power ###

use iwconfig wlan0 txpower <tx power in dbm or mw>

e.g

`iwconfig wlan0 txpower 27dbm`

or

`iwconfig wlan0 txpower 500mw`

To convert dbm to mw, use the formula dbm=10log<sub>10</sub>(P/1mw) , where P is the transmit power in mw.


### To view routing tables ###

route -n

```
root@fabfi225:~# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
10.104.0.244    10.104.0.224    255.255.255.255 UGH   2      0        0 wlan0
10.100.0.236    10.104.0.224    255.255.255.255 UGH   2      0        0 wlan0
10.100.0.237    10.104.0.224    255.255.255.255 UGH   2      0        0 wlan0
10.100.0.238    10.104.0.224    255.255.255.255 UGH   2      0        0 wlan0
10.100.0.239    10.104.0.224    255.255.255.255 UGH   2      0        0 wlan0
10.100.0.232    10.104.0.224    255.255.255.255 UGH   2      0        0 wlan0
10.100.0.233    10.104.0.224    255.255.255.255 UGH   2      0        0 wlan0
10.104.0.242    10.104.0.224    255.255.255.255 UGH   2      0        0 wlan0
10.100.0.234    10.104.0.224    255.255.255.255 UGH   2      0        0 wlan0
10.100.0.235    10.104.0.224    255.255.255.255 UGH   2      0        0 wlan0
10.100.0.228    10.104.0.224    255.255.255.255 UGH   2      0        0 wlan0
10.100.0.230    10.104.0.224    255.255.255.255 UGH   2      0        0 wlan0
10.100.0.224    10.104.0.224    255.255.255.255 UGH   2      0        0 wlan0
10.100.0.227    0.0.0.0         255.255.255.255 UH    2      0        0 eth0
10.112.227.0    10.100.0.227    255.255.255.0   UG    2      0        0 eth0
10.116.243.0    10.104.0.224    255.255.255.0   UG    2      0        0 wlan0
10.116.227.0    10.100.0.227    255.255.255.0   UG    2      0        0 eth0
10.104.0.0      0.0.0.0         255.255.252.0   U     0      0        0 wlan0
10.100.0.0      0.0.0.0         255.255.252.0   U     0      0        0 eth0
0.0.0.0         10.104.0.224    0.0.0.0         UG    2      0        0 wlan0
```

The last entry (0.0.0.0) is very important as it indicates the default gateway (10.104.0.224  in this case). The default gateway is probably a "path to the internet".

ip route show

```
root@fabfi225:~# ip route show
10.104.0.244 via 10.104.0.224 dev wlan0  metric 2 
10.100.0.236 via 10.104.0.224 dev wlan0  metric 2 
10.100.0.237 via 10.104.0.224 dev wlan0  metric 2 
10.100.0.238 via 10.104.0.224 dev wlan0  metric 2 
10.100.0.239 via 10.104.0.224 dev wlan0  metric 2 
10.100.0.232 via 10.104.0.224 dev wlan0  metric 2 
10.100.0.233 via 10.104.0.224 dev wlan0  metric 2 
10.104.0.242 via 10.104.0.224 dev wlan0  metric 2 
10.100.0.234 via 10.104.0.224 dev wlan0  metric 2 
10.100.0.235 via 10.104.0.224 dev wlan0  metric 2 
10.100.0.228 via 10.104.0.224 dev wlan0  metric 2 
10.100.0.230 via 10.104.0.224 dev wlan0  metric 2 
10.100.0.224 via 10.104.0.224 dev wlan0  metric 2 
10.100.0.227 dev eth0  metric 2 
192.168.1.0/24 dev eth0  src 192.168.1.10 
10.116.233.0/24 via 10.104.0.224 dev wlan0  metric 2 
10.116.200.0/24 via 10.104.0.224 dev wlan0  metric 2 
10.116.230.0/24 via 10.104.0.224 dev wlan0  metric 2 
10.112.230.0/24 via 10.104.0.224 dev wlan0  metric 2 
10.116.213.0/24 via 10.104.0.224 dev wlan0  metric 2 
10.112.213.0/24 via 10.104.0.224 dev wlan0  metric 2 
10.112.243.0/24 via 10.104.0.224 dev wlan0  metric 2 
10.112.227.0/24 via 10.100.0.227 dev eth0  metric 2 
10.116.243.0/24 via 10.104.0.224 dev wlan0  metric 2 
10.116.227.0/24 via 10.100.0.227 dev eth0  metric 2 
10.104.0.0/22 dev wlan0  src 10.104.0.225 
10.100.0.0/22 dev eth0  src 10.100.0.225 
default via 10.104.0.224 dev wlan0  metric 2 
```


### View Neighbouring OLSR Devices ###

All Fabfi devices run [OLSR](http://en.wikipedia.org/wiki/Optimized_Link_State_Routing_Protocol)

To view the IP addresses of devices neighbouring a device, use

`echo /links | nc localhost 2006`


```
root@fabfi225:~# echo /links | nc localhost 2006
HTTP/1.0 200 OK
Content-type: text/plain

Table: Links
Local IP        Remote IP       Hyst.   LQ      NLQ     Cost
10.100.0.225    10.100.0.227    0.00    1.000   1.000   1.000
10.104.0.225    10.104.0.224    0.00    1.000   1.000   1.000

```

This also shows you the link quality (LQ), neighbour link quality (NLQ) and Cost=1/( LQ`*`NLQ )

### FirstBoot ###

_To be used only as a last resort_

When everything breaks ( but you can still login to the device ), run `firstboot` to restore the device to **just flashed** state. You will need to reboot the device, **telnet** into it (ssh wont work - the device is in the **just flashed** state ) and run the setup script ( `sh setup` ). You may then reconfigure the device.


## More ##

http://wirelessdefence.org/Contents/LinuxWirelessCommands.htm#iwpriv%20Commands