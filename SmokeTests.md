# Introduction #

This page is an archive of all the key functionality tests we've done for fabfi 5.0, mainly so we don't forget and do them twice.



# Wireless #

All things pertaining to wireless configurations and performance

## AP + ADHOC ##

**WARNING:  as of the 11/1/2011 compat-wireless AP+ADHOC may seem to work in bench tests, but in a real environment the connection of stations to the AP interface causes some ADHOC nodes to experience >95% packet loss.  It is not entirely clear why this occurs.**


Tested a single device with AP+ADHOC wireless configuration as follows:

```
config 'wifi-device' 'radio0'
       option 'type' 'mac80211'
       option 'channel' '11'
       option 'macaddr' '68:7f:74:91:37:21'
       option 'hwmode' '11ng'
       option 'htmode' 'HT20'
       list 'ht_capab' 'SHORT-GI-40'
       list 'ht_capab' 'DSSS_CCK-40'
       option 'disabled' '0'

config 'wifi-iface'
       option 'device' 'radio0'
       option 'ssid' 'hideadhoc'
       option 'encryption' 'none'
       option 'network' 'wlan'
       option 'mode' 'adhoc'
       option hidden 1

config 'wifi-iface'
       option 'device' 'radio0'
       option 'ssid' 'AP-Openwrt'
       option 'encryption' 'none'
       option 'network' 'wlan2'
       option 'mode' 'ap'
```
This was built on a linksys wrt160nl (atheros 9xxx, compat-wireless 2011-06-22,   2.6.39.2 kernel, openwrt 27724)

Test setup:
`STA<-->AP/ADHOC<-->ADHOC`

Interfaces loaded properly and iperf results were as follows:
  * `AP/ADHOC<-->ADHOC`: 24-25Mbps (whether or not STA was connected had no effect)
  * `STA<-- * -->ADHOC`: 11Mbps
  * `STA<-->AP/ADHOC`: 28.6Mbps (whether or not other ADHOC was available had no effect)
  * FAILED: hiding the ADHOC SSID had no effect (SSID still advertised)
  * **FAILED: adhoc communication between some AP+ADHOC devices when stations are connected!**



## SPEED TESTS ##

### NanoStationM5-loco ###

#### Maximum Throughput, OpenWRT ####
Ran speed test with iperf (tcp) from two routers on either side of a pair of AP/STA as described below.  Devices were transmitting through a wire and plaster wall in a roo with unknown levels of interference (kinda like the real world)

Summary:
  * Goodput at 20Mhz = 48.8Mbps
  * Goodput at 40Mhz = 61.4Mbps
  * proc was at least 19% idle
  * Encryption had no material effect on throughput
  * Throughput was moderately better (~4Mbps) in decribed setup than with iperf running on tested devices

Conclusions:
  * In a real environment, channel bonding may be of little benefit if maximum single link speed is not a priority. This agrees with the research that suggests 40Mhz channels are much more susceptible to interference.

  * **Question: Does the AirOS wifi driver provide better performance?**

Test Details (All tests performed with openwrt [r26751](https://code.google.com/p/fabfi/source/detail?r=26751)):

```
20Mhz: 

Station 00:15:6d:3a:25:fe (on wlan0)
        inactive time:  0 ms
        rx bytes:       429946787
        rx packets:     281079
        tx bytes:       10356994
        tx packets:     139888
        tx retries:     10342
        tx failed:      1
        signal:         -60 dBm
        signal avg:     -57 dBm
        tx bitrate:     270.0 MBit/s MCS 15 40Mhz
        rx bitrate:     300.0 MBit/s MCS 15 40Mhz short GI

root@fabfi4:~# iperf -c 10.100.0.7 -t60
------------------------------------------------------------
Client connecting to 10.100.0.7, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 10.100.0.4 port 51631 connected with 10.100.0.7 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-60.0 sec   439 MBytes  61.4 Mbits/sec


config 'wifi-device' 'radio0'
        option 'type' 'mac80211'
        option 'hwmode' '11na'
        option 'htmode' 'HT40+'
        option 'distance' '100'
        option 'ht_capab' 'SHORT-GI-40 TX-STBC RX-STBC1 DSSS_CCK-40'
        option 'channel' '36'
        option 'txpower' '17'
        option 'macaddr' '00:15:6d:3a:25:30'
        option 'disabled' '0'

config 'wifi-iface'
        option 'device' 'radio0'
        option 'network' 'wifimesh'
        option 'hidden' '0'
        option 'encryption' 'psk2'
        option 'key' '<key>'
        option 'ssid' 'ff149a'
        option 'mode' 'ap'

```

```
40Mhz:

Station 00:15:6d:3a:25:fe (on wlan0)
        inactive time:  0 ms
        rx bytes:       230555805
        rx packets:     150786
        tx bytes:       5565207
        tx packets:     75141
        tx retries:     4818
        tx failed:      0
        signal:         -54 dBm
        signal avg:     -55 dBm
        tx bitrate:     130.0 MBit/s MCS 15
        rx bitrate:     130.0 MBit/s MCS 15

root@fabfi4:~# iperf -c 10.100.0.7 -t60
------------------------------------------------------------
Client connecting to 10.100.0.7, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 10.100.0.4 port 58188 connected with 10.100.0.7 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-60.0 sec   350 MBytes  48.8 Mbits/sec


config 'wifi-device' 'radio0'
        option 'type' 'mac80211'
        option 'hwmode' '11na'
        option 'htmode' 'HT40+'
        option 'distance' '100'
        option 'ht_capab' 'SHORT-GI-40 TX-STBC RX-STBC1 DSSS_CCK-40'
        option 'channel' '36'
        option 'txpower' '17'
        option 'macaddr' '00:15:6d:3a:25:30'
        option 'disabled' '0'

config 'wifi-iface'
        option 'device' 'radio0'
        option 'network' 'wifimesh'
        option 'hidden' '0'
        option 'encryption' 'psk2'
        option 'key' '<key>'
        option 'ssid' 'ff149a'
        option 'mode' 'ap'
```

#### Near Field Effects & Sectoring ####

Summary: Sectored NanoStationM5-Loco devices do degrade each other's throughput.
  * Degradation is decreased if channels are not adjacent, but spacing by 2 or more channels makes it reasonably small
  * ADHOC mode increases degradation
  * HT20 with more sectors is preferable to HT40 with fewer.

Details:

  * Four NanoStationM5-locos were linked with two centrally located devices and two remote ones where the central ones were linked by an ethernet cable.
  * iperf run between the two remote nodes through the central pair.
  * Tests below are roughly compared to an isolated throughput of about 62Mbps

```
HT20 AP/STA - Adjacent Channels ( 149 & 153 )
33.3 Mbits/sec


HT20 AP/STA Channel 149 & 157
43.5 Mbits/sec


HT20 AP/STA Channel 149 & 161
46.6 Mbits/sec

HT20 AP/STA Channel 149 & 165
50.2 Mbits/sec

HT20 ADHOC - Adjacent Channels ( 149 & 153 )
25.6 Mbits/sec


HT20 ADHOC Channel 149 & 157
32.1 Mbits

```

#### HT40+ ####

```

HT40 AP/STA Channel 149 & 157
52.2 Mbits/sec

```


  * **Question2:  How does this compare to non-overlapping Omni-directional operation?**
  * This test informs whether it is reasonable to sector the NanoStations or whether more expensive antenna hardware will be desirable.


### General: Adhoc mode TX Rates ###

Summary: ath9k supports full 802.11n with multiple chains and channel bonding.
  * In general, performance is poorer than in AP/STA (no short GI?), but not by a heck of a lot.
  * Not shown, HT20 achieved a rate of 44Mbps

Details:

  * Tested between Ubiquiti Nano M5 - running openwrt Kernel 2.6.39.2

**Wireless Settings**
```
config wifi-device  radio0
        option type     mac80211
        option channel  149 
        option macaddr  00:15:6d:3a:25:3e
        option hwmode   11na
        option htmode   HT40+
        list ht_capab   SHORT-GI-40
        list ht_capab   TX-STBC
        list ht_capab   RX-STBC1
        list ht_capab   DSSS_CCK-40
        # REMOVE THIS LINE TO ENABLE WIFI:
        option disabled 0

config wifi-iface
        option device   radio0
        option network  wlan
        option mode     adhoc
        option ssid     OpenWrt
        option encryption none
```
**Bitrates**
```
        tx bitrate:     270.0 MBit/s MCS 15 40Mhz
        rx bitrate:     6.0 MBit/s
```
**iperf**

```
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.2.1 port 5001 connected with 192.168.2.2 port 59545
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-10.1 sec  63.0 MBytes  52.5 Mbits/sec
[  4] local 192.168.2.1 port 5001 connected with 192.168.2.2 port 59546
[  4]  0.0-10.0 sec  63.0 MBytes  52.6 Mbits/sec
[  4] local 192.168.2.1 port 5001 connected with 192.168.2.2 port 59547
[  4]  0.0-10.0 sec  63.0 MBytes  52.8 Mbits/sec
[  4] local 192.168.2.1 port 5001 connected with 192.168.2.2 port 59548
[  4]  0.0-10.0 sec  63.4 MBytes  52.9 Mbits/sec
[  4] local 192.168.2.1 port 5001 connected with 192.168.2.2 port 44674
[  4]  0.0-10.0 sec  63.0 MBytes  52.7 Mbits/sec
```


When changed to HT20, iperf gave


```
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.2.1 port 5001 connected with 192.168.2.2 port 40242
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-10.0 sec  52.5 MBytes  43.9 Mbits/sec
[  4] local 192.168.2.1 port 5001 connected with 192.168.2.2 port 40243
[  4]  0.0-10.1 sec  52.8 MBytes  44.0 Mbits/sec
[  4] local 192.168.2.1 port 5001 connected with 192.168.2.2 port 40244
[  4]  0.0-10.0 sec  52.8 MBytes  44.1 Mbits/sec
```

### Real-World Performance testing ###

See here for initial Preformance Test results in an urban environment:  [Davis Lab Wifi Tests](https://docs.google.com/spreadsheet/ccc?key=0AnA6LOF3_NU1dEVNR2diMi0zbWtDb0VKUEwzc2taWFE)

# Routing & Meshing #

Summary:
  * A central router running OLSR and connected via ethernet to radios in bridge mode will correctly calculate ETX over the wireless links.

Details:

A link was created between two devices running OLSR


` Device1<--cable-->(Link1)<--wireless-->(Link2)<--cable-->Device2 `

Where Device1 and Device2 are devices running OpenWrt with OLSR. Link1 and Link2 are devices running AirOS and have their interfaces bridged.

First, a proper link was created

` Link Quality=75/94  Signal level=-21 dBm  Noise level=-100 dBm `


The OLSR neighbours table looked like :

```
Table: Links
Local IP        Remote IP       Hyst.   LQ      NLQ     Cost
10.100.0.6      10.100.0.2      0.00    1.000   1.000   1.000
```


The Link devices then had their txpower lowered and were then put in metal containers. The signal levels dropped to :

` Link Quality=9/94  Signal level=-87 dBm  Noise level=-99 dBm `


and the OLSR neighbour table

```
Table: Links
Local IP        Remote IP       Hyst.   LQ      NLQ     Cost
10.100.0.6      10.100.0.2      0.00    1.000   0.553   1.808
```


It can be seen that the OLSR devices respond to changes in link quality between two non-OLSR devices.