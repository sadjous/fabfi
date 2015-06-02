# Overview #

The FabFi 5.0 Test Bed ... will come online in late August 2011.  (Tentatively in a working session held in Cape Town, South Africa).

The purpose of the testbed is to implement and test in microcosm all the functional and architectural components of FF5.

Its permanent location is TBD.

# Node Configuration #


**T-Node:**
  * 1 - PowerAP-N (OpenWRT), serving clients @2.4G
  * 1+ - NanostationM5-Loco (AirOS), connecting to other T-Nodes
  * 1+ - NanostationM5-Loco (AirOS), connecting to C-Node Mesh
  * Note: there is no easy all-PassivePOE solution for T-Nodes as RouterStation Pros are 48V and RouterStations Need more Switchports

T-Node Design Consideration: If Servers include wifi, PowerAP can talk to server wirelessly.

**C-Node:**
  * 1 - PowerAP-N (OpenWRT), serving clients AND adhoc mesh @2.4G NB: Assumes: AP+adhoc functional in OpenWRT **ANTOINE: TEST**
  * 1 - NanostationM5-Loco (AirOS), connecting to T-Node
  * (option) 1 - PicostationM2-HP (AirOS), connects to other C-Nodes in an adhoc mesh instead of radio reuse on PowerAP-N

**Power**



# Proposed Architecture #

  * Core
    * 4 T-nodes
      * Primary uplink with content server and RADIUS master
      * Secondary uplink
      * Non-uplinked content server
      * Plain T-node
  * Local Mesh
    * 5 C-nodes

![http://fabfi.googlecode.com/svn/wiki/images/SystemArchitecture/SysDiagram.png](http://fabfi.googlecode.com/svn/wiki/images/SystemArchitecture/SysDiagram.png)

[Draw file for diagram](http://fabfi.googlecode.com/svn/wiki/files/SysDiagram.odg)

# Lima, 1st Deploy #

`<insert diagram>`

## Outstanding issues ##

  * Configuration
    * need auto-config for devices with 3 radios (5Gmesh, adhoc, client access)
    * Unsure about adhoc radio config.  What about BSSID?  (Isn't IBSS defined by BSSID and SSID irrelevant?)
    * dev mode with limited power
  * Mesh Navigation
    * Current behavior allows navigation between OLSR **most** nodes via IPv6 addresses, however hops across batman nodes do not always route.  Example:  ff92 will not ping 94, but 82 will ping 94.  (topology: 92-82 - - - 84-94).
    * BATMAN nodes are visible via ipv4 as long as you don't have to cross an adhoc 2.4G network.  (ex: from 90, you can ping 10.100.0.80-81, but not 82)
    * preferred behavior:
      * Minimum:  reliable IPv6 nav to all olsr nodes regardless of path, with clear method of determining the other devices in the path as needed (to find failures)
      * Preferred: IPv6 OR IPv4 (as able) nav working on all devices (every device can reach every other one).
  * Client Access
    * Network currently doesn't automate DNS advertisement (nameservice not working?)
    * RS with integrated radio seems to have problems on boot (or radio restart) with client access: After reassembling testbed (had to move it)  ff93 no longer gives users web access (can't ping 8.8.8.8), although the device itself can see the net.  (this is the device with integrated 5G radio instead of nano). ssh to 93 also give "connection refused" from headnode but not from immediate olsr neighbor (92)
  * Routing
    * Traffic appears routed, not forwarded in the network.  This causes problems with identifying origins.  (ex:  all traffic to the squid appears as if its origin is the headnode.  Prefer to see client-level origin addresses).
    * want to be able to see requests by IP at squid.
    * Potential circular routing issue?
```
From ff90
traceroute to 2001:470:4:7c5::100:93 (2001:470:4:7c5::100:93), 30 hops max, 16 byte packets
 1  2001:470:4:7c5::100:91 (2001:470:4:7c5::100:91)  1.562 ms  1.479 ms  1.494 ms
 2  2001:470:4:7c5::108:94 (2001:470:4:7c5::108:94)  54.375 ms  2.470 ms  8.216 ms
 3  2001:470:4:7c5::108:94 (2001:470:4:7c5::108:94)  50.742 ms  19.977 ms  27.640 ms
```
    * Something about the routing is very unstable.  Does this have to do with devices shifting routes across multiple /80 networks?
  * Diagnostics:
    * nano/pico signal meters do not currently work.  Should show infrastructure connections (as opposed to clients)
    * Map updates are not occurring (maybe not implemented?)
    * can't netcat from txtinfo plugin :(.
  * Performance testing:
    * be able to iperf between any two devices
  * Performance Concerns
    * there are some speed issues I haven't been able to diagnose yet.

unable to easily navigate between different types of devices (transparent/otherwise).  OLSR nodes use IPv6