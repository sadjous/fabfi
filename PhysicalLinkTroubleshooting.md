

# Introduction #

A [physical link](http://en.wikipedia.org/wiki/Physical_Layer) is just that: a physical connection between two devices.  Fabfi nodes have both wired and wireless physical links.  Choose the Section that applies to your link:

## Wired links ##

Wired links are made with ethernet cables.  Every device has a "link light" that lights up when the ethernet port has successfully negotiated a link over the cable.  See the links in the wireless section for images of LEDs.

If the light is not on, you don't have a connection.  Check your cabling.

Assuming that you don't have a cable with a loose connection, wired links are usually binary: connected at full speed or not connected at all.

## Wireless Links ##

Wireless links are a little more complex than wired ones. Every link has:
  * A frequency band
  * A channel within the frequency band
  * A distance setting
  * An ESSID or BSSID
  * A mode: AP / STA / ADHOC
  * An encryption mode(psk2, none)
  * An encryption key (if encrypted)

In order for a link to function properly, all of these must be set correctly.  This should all be configured by default, but here are a few general rules to remember:

  * Devices must be in the same band
  * AP and STA devices must share an ESSID (called ssid in the config file)
  * ADHOC devices share a BSSID
  * Any two devices must share the same encryption key and mode
  * Any device where a channel is explicitly specified must share that channel with the other device it talks to

Unlike wired links, wireless connections are not just on or off.  Any given link has a signal strength, which determines [data rate encoding](http://en.wikipedia.org/wiki/IEEE_802.11n-2009), and a link quality metric measures how much data must be retransmitted over the link due to packet loss.

Signal strength is measured in [dBm](http://en.wikipedia.org/wiki/DBm), with 0 equal to 1mW of received power.  Receive values will almost always be negative, meaning a received power of less than 1mW.  Thus, a value closer to 0 is better.  A higher signal strength means more complex encoding can be used and data transfer speeds can be higher.

When diagnosing a wireless connection you want to test, in order:

  1. [Connection](#Connection.md)
  1. [Signal Strength and Quality](#Signal_Strength_and_Quality.md)
  1. [Link speed](#Link_Speed.md)

### Connection ###

As with wired links, fabfi nodes have LED indicators for connection, but the LEDs can also be used to measure signal strength.  Each device indicates the receive signal strength of its best wireless neighbor on one or more LEDs.

For Ubiquiti devices, 4 LEDS are used as shown below:

![http://fabfi.googlecode.com/svn/wiki/images/Devices/UbiquitiLED.jpg](http://fabfi.googlecode.com/svn/wiki/images/Devices/UbiquitiLED.jpg)

These four LEDs can be either solid or blinking, indicating 8 states (solid indicates a stronger signal than blinking).  Each LED indicates a range of 10dBm, with a solid/blink cutoff at the midpoint, as follows:

Red: -75 and below (blink below 79)
Orange: -65 to -74
Green1: -55 to -64
Green2: -54 and above (blink below 49)

For Linksys Devices, two LEDs are used (one has three colors):

![http://fabfi.googlecode.com/svn/wiki/images/Devices/wrt160nl_LED.jpg](http://fabfi.googlecode.com/svn/wiki/images/Devices/wrt160nl_LED.jpg)

WLAN Blue: -75 and below (blink below 79)
WPS Orange: -65 to -74
WPS Blue: -55 to -64
WPS Purple: -54 and above (blink below 49)

if any of these LEDs are lit on a device, you know that it is connected to at least one neighbor.

In general, connections that consistently run at -70dBm or greater will be very reliable in low-noise environments.  Connections above -75dBm are usually stable.  Below that, only ADHOC mode connections are recommended.

A connection can also be tested in software with the command:
```
$ iw dev <physical interface name, usually wlan0, but sometimes wlan1> station dump

example: iw dev wlan0 station dump
```
For devices with multiple wireless networks, the wlans will be numbered in order of their appearance in
```
/etc/config/wireless
```
The iw command will show all the neighbors and their signal strengths. like this:
```
root@fabfi218:~# iw dev wlan0 station dump
Station 00:15:6d:60:1d:e8 (on wlan0)
	inactive time:	210 ms
	rx bytes:	2982414
	rx packets:	18425
	tx bytes:	8527669
	tx packets:	14144
	signal:  	-83 dBm
	tx bitrate:	45.0 MBit/s MCS 2 40Mhz short GI
```

if you don't see the neighbor you want try restarting the wireless device by running:
```
wifi
```
try on the remote device if running it on the local device.

### Signal Strength and Quality ###

The most common reason for wireless failures is weak signal strength. As mentioned in the previous section you can visually measure signal strength using the LEDs on the devices. You can improve signal strength by
  * Improving the pointing of directional devices
  * Adding RF reflectors with larger gain
  * Raising devices higher above obstacles (get a bigger pole)

The first thing we want to do is to get the most out of our wireless hardware by pointing the two ends of the link properly.  To do this, first run:
```
$ iw dev wlan0 station dump
```
to get the MAC address of the station you're interested in.

Then write the following program:
```
$ while true; do iw dev wlan0 station get "<MAC Address from above>" | grep "signal"; sleep 1; clear; done;
```
This program will test the signal every second and print the output.

Now, slowly turn your node's antenna to the left, right, up and down in a search pattern until you find the best signal.  I personally like to find the best horizontal position first (move left and right until you get the best signal), then find the best vertical position (move up and down).

When you've got the best signal, stop the program above by hitting the `ctrl` and `c` keys at the same time.

Perform the above procedure on both ends of the link.  If you still aren't getting adequate signal, consider a different link or [adding some gain](RFReflectors.md)

Once you have the best possible signal, run
```
$ echo '/links' | nc localhost 2006
```
and view the ETX value. A perfect connection will have a value of 1.  A passable connection will have a value of 2 or less.  A connection losing a lot of packets will have a greater value (bad).  Links that drop a lot of packets will be slower and less reliable _Note: these values only apply to link-local connections.  Multi-hop connections will have higher values._

### Link Speed ###

While any connection will probably support some data transfer, performance is an important concern.  You can explicitly test the link speed using the `iperf` program.

`iperf` has a client (-c) and a server (-s) mode.  One runs on one end of the link you're trying to test and one runs on the other.  Data travels from the client to the server,

run the server on one end of the link like this:
```
$ iperf -s
```
run the client on the other end like this:
```
$ iperf -c <ip of server>
```
The program will connect, and a few seconds later output the link speed in terms of real throughput (actual data rate after overhead).

You should run the test in both directions in case the link is asymmetric.


NOTE: [Everything you ever wanted to know about 802.11](http://books.google.com/books?id=9rHnRzzMHLIC&printsec=frontcover&source=gbs_ge_summary_r&cad=0#v=onepage&q&f=false)