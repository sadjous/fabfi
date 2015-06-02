The current FabFi version 4.0 includes billing capability, much improved networking monitoring, and the use and testing of Ubiquity devices, was deployed in 2010 in pilot in a community in Kenya. The pilot aimed to establish a self-sustaining-with-growth business that would build and maintain a free-to-fee network. Free-to-fee means their network was designed so that basic access to the internet and educational materials are free and they collect fees only for high speed unrestricted service. They have reached a critical mass of subscribers for self-sustainability and are now tackling growth. In the ensuing months our networks in Afghanistan and Kenya received much press and we have gotten a lot of technical volunteers to develop the system further.

FabFi version 5.0 (slated for late fall 2011) is predominately focused on _scaling_ (to tens and hundreds of thousands of nodes and several hundreds of thousands of devices) and _locally hosted_ educational/informational/contextual content (so that as long as your city-scale intranet is up, persistent connection to the big internet becomes less important).

The code name for the version 5.0 project is “schoolnet” (no one likes the name but no one has a better idea – the next closest is free-edu-net). The software and system architecture allows anyone to connect for free for either low-speed, local, or educational content (that you can select and change as a community or a managed operator) while allowing people to chose to pay by-the-hour or by subscription for high speed unrestricted access. The hope is in some situations to be able to pay for the “free” with the “fee” parts.

With FabFi 5.0 we’re expecting to have a pretty great infrastructure but we haven’t forgotten that it’s only as good as the content and services available in the network. A substantial part of the development work has to do with the technologies of local caching and mirroring as well as the pedagogical aspects of the content itself.




# What are the hallmarks of "the next version"? #
  * massively larger number of nodes and devices (order 1000 to 2000)
  * possible large load of rsync/mirror traffic among content servers in the mesh

# Software: Routing & DNS #
The order of magnitude increase in the number of devices ...

A major issue of consideration is the ability of mesh protocols to scale.  OLSR claims to scale with O(log(n)) complexity in the number of addresses.  As a point of context, networks of WRT54GLs (200MHz, 8MB RAM) are running networks of 2000 addresses.  In any case we anticipate the network being large enough that it will need segmentation.

### protocol evaluation ###

| | OLSR IPv4 | B.A.T.M.A.N. IPv4 | OLSR IPv6 | B.A.T.M.A.N. advanced IPv6 |
|:|:----------|:------------------|:----------|:---------------------------|
| Previous experience | FabFi, SWUG, BB4ALL | Afrimesh, VT      | BB4ALL    | Testbed                    |
| Node deploy sizes | ~1000 (Freifunk, Berlin) | ~50 (VT, Cape Town) | ~200 (BB4ALL, .za) | elektra sez <= 50          |
| User deploy sizes | ~5000 (Freifunk, Berlin) | ~100 (VT, Cape Town) | ~1000 (BB4ALL, .za) | unknown                    |
| Node Address assignment | Static/Dynamic | Static            | RFC2462/OLSR | RFC2462                    |
| Client Address Assignment | DHCP/NAT  | DHCP/NAT          | RFC2462/OLSR, niit | RFC2462                    |
| Node Roaming | No        | No                | niit, RFC3775, ? | RFC3775                    |
| Client Mesh Roaming | maybe (Layer3-Chilli) | No                | niit, local bat0 | maybe                      |
| Network Segmentation | No        | No                | Yes       | Yes                        |
| UserSpace Plugin API | Yes       | No                | Yes       | No                         |
| Platform Availability | POSIX, WIN32 | LINUX             | POSIX, WIN32 | LINUX                      |
| Layer 2 support | Plugin    | No                | Plugin    | Yes                        |
| Programmable gateway selection | Yes       | Limited           | Yes       | Limited                    |
| Ecosystem maturity | ~10 years | ~3 years          | ~5 years  | ~1 year                    |
| Duplicate addresses | Catastrophic | Catastrophic      | Proactive detection | Unknown                    |
| Gateway Control | chilli, plugin, manual | chilli, manual    | pepperspot, plugin, manual | chilli, manual             |
| Management Messaging | plugin/transparent | kludge/limited    | plugin/transparent  | kludge/limited             |

## Proposed Architecture ##

### theory ###

  1. The the average message distance (in hops) in a multi-hop, single-radio (adhoc) mesh determines throughput
  1. (not surprisingly) you can achieve a guaranteed throughput for any size adhoc mesh by interspersing uplinks with the appropriate frequency
  1. A multi-radio, multi-channel mesh of arbitrary size should be able to achieve 100% throughput

This informs the architecture as follows:

  1. adhoc mesh should be a single channel to maximize connectivity and therefore minimize distance to a 5G gateway
  1. Access channels should alternate so as to minimize cross-cell interference.
  1. 5Ghz links to a multi-radio, multi-channel backbone should be interspersed into the adhoc mesh.

### Practice ###

Addressing will be native IPv6 with NIIT encapsulation for IPv4 Clients

Network will consist of two node types.  T-nodes and C-Nodes (so named because when we draw them, T-nodes are triangles and C-nodes are circles.)


**T-Nodes:**
  * Make up the network core
  * Statically addressed
  * Connect to other T-Nodes using an infrastructure mesh.
  * Provide a non-meshed (internal) bridge between the core and local meshes
  * Have robust permanent mounting
  * Operate 5 VLANS: WIFIMESHx2, MESH (internal), LAN (bridged to wireless), ALAN (internal, also bridged to wireless)

**C-Nodes:**
  * are deployed in a less-structured mesh surrounding the T-Nodes
  * Zero-conf addressed
  * are linked to T-Nodes via 5GHz in a hub-spoke arrangement
  * connect to each other over 2.4GHz adhoc mesh
  * Operate 5 VLANS: WIFIMESH, MESH (internal), LAN (bridged to wireless), OpenLAN (bridged to wireless), ALAN (internal to node, also bridged to wireless?)

The network will run two tiers of OLSR IPv6 mesh with statically configured links between them.  The core of the network will run a contiguous mesh of T-Nodes. Many T-Nodes will have wireless devices included to connect C-nodes.  These devices will run OLSR on their wireless interface and act as an ALAN client on the wire. Routes will be configured statically between these devices and the central device of the T-Node to provide the core network with the network-local address of the local mesh.

Local DNS will be served at each triangle node (replicated from internet gateway)

### Advantages ###

  * things don't explode?
  * devices can be auto-addressed (zero-conf)

### Limitations ###

  * Segmenting the mesh below T-Nodes creates a problem for redundant routing.  Specifically, the network-local address of every C-node mesh that routes through any T-node must be statically entered (or otherwise scripted).  In the case that multiple T-Nodes advertise a route to a C-Node, We are usure at this time of the behavior when a client's traffic is routed to a T-node that does not have a connection to the C-Node. **ANTOINE: Test**
  * Roaming of clients from one access device to another is expected to drop all TCP connections.  We are unsure at this time whether A) the node gets locked out similar to IPv4 (we're especially unsure for NIIT clients), or whether IPv6 and OLSR gracefully readdresses them, allowing them to continue browsing.  Additionally, we're not sure how badly device roaming breaks PTP connections.  **ANTOINE: TEST**  Suggest: avoiding roaming
  * zero-conf devices cannot reliably serve content because they won't have static IPs.  This causes similar issues for PTP.
  * In the event of a connectivity loss to all T-Nodes, local DNS will no longer be available.

# Hardware: RF #
First-third gen FabFi used Linksys WRT54GL.  4th and later gen use 9xxx series Atheros devices from Linksys and Ubiquiti.  These devices are relatively interchangeable from a firmware standpoint.

Harware under consideration for 5th-gen is all ubiquiti-made and 9xxx Atheros-based.  Devices are as follows:
| Model | RAM | Flash | Processor | Ethernet Ports | USB | Serial | POE | Band | MIMO | Tx PWR| MSRP |
|:------|:----|:------|:----------|:---------------|:----|:-------|:----|:-----|:-----|:------|:-----|
| NanostationM2-Loco | 32M | 8M    | 400MHz    | 1              | NO  | UART   | 12-18V | 2.4Ghz | 2x2  | 23dbm | $50  |
| NanostationM5-Loco | 32M | 8M    | 400MHz    | 1              | NO  | UART   |12-18V | 5Ghz | 2x2  | 27dbm | $70  |
| PowerAP-N | 32M | 8M    | 400MHz    | 5              | Header Only | UART   | NO, 12v jack | 2.4Ghz | 2x2  | 27dbm | $90  |
| PicostationM2-HP | 32M | 8M    | 400MHz    | 1              | NO  | UART   | 12-15v| 2.4Ghz | NO   | 27dbm | $80  |
| RouterStation Pro | 128M | 16M   | 680MHz    | 4              | YES | DB9    | 48v | Slots Only | N/A  | N/A   | $80  |
| RouterStation | 64M | 16M   | 680MHz    | 3              | NO  | UART   | 12-18v | Slots Only | N/A  | N/A   | $70  |

Note: Open-Mesh dual-band devices do not seem hackable http://robin.forumup.it/about4656-robin.html

mini-PCI Radios:
| Model | tx/rx | pwr | band | connector | Retail price |
|:------|:------|:----|:-----|:----------|:-------------|
| Mikrotok R52Hn | 2x2   | 25dBi | 2.4/5Ghz | MMCX      | $49          |
| Mikrotok R2n | 2x2   | 24dBi | 2.4Ghz | U-FL      | $34          |

Antennas:
| Model | type | gain | band | connector | Retail price |
|:------|:-----|:-----|:-----|:----------|:-------------|
| Laird| omni | 5dBi | 2.4Ghz | N-Male    | $42          |
| Laird| omni | 7dBi | 2.4Ghz | N-Male    | $52          |
| Laird| omni | 9dBi | 2.4Ghz | N-Male    | $52          |
| Ubiquiti | mimo-omni | 13dBi | 5Ghz | RP-SMA female | $169         |

`*`Antenna prices are for "easy" procurement.  Equivalents may be available direct from China for < $20.
`*``*`This antenna will supply both chains for a single radio

Pigtails:
Expect $6-12 for premade.

## Proposed Configurations ##

NB: I believe it ill be possible to use Ubiquiti devices as transparent APs and stations (provided 1:1 mapping of STA:IP)

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

**C-Node (alternate config):**
  * 1 - RouterStation (OpenWRT)
  * 1 - 802.11n MIMO PCI radio @2.4G for clients
  * 1 - 802.11g PCI radio @2.4G for mesh
  * 1 - NanostationM5-Loco, connecting to T-Node (AirOS)
  * 1 - High-gain MIMO Omni Antenna (ubiquiti) for clients. It may be possible to split this antenna among PowerAP and Pico and still get full duplex **KEITH: TEST**
  * 1 - High-gain Standard Antenna (any brand) for mesh
Note: This config is all passive POE

C-Node design Consideration:  Adding PicoStation for meshing provides an advantage that client and mesh connections can be full-duplexed.  We also envision a scheme where all client access devices run on the same channel, but mesh devices are randomized to other two channels and run a higher power.  This should provide a higher capacity mesh where we take advantage of the node's favorable placement to minimize the number of hops to the gateway.


### Assumptions and Concerns ###

  * PowerAP-N is not designed for outdoor use, meaning we will require weatherproofing.  Suggest: pigtails on PowerAP to separate antennas from body
  * PowerAP-N seems to be identical to other Ubiquiti devices, however it is as-yet untested
  * Designs above assume OLSR will run on AirOS.  There seem to be AirOS packages for this.
  * Last time we tested, AP+adhoc was broken in OpenWRT (issue was that Mesh operated at 1Mbps when no clients were associated).  This may have been fixed by now.  A fix must be verified before C-Node option B above can be used.
  * PowerAP-N is a 12V device but is not POE.  This means hacking cables and making adapters (lame), but the PowerAP-N makes for a cheaper setup than any RouterStation option

# Hardware: Server #
  * look for a network card or motherboard with hardware crypto stupport so that tunneling is less resource-intensive
  * http://www.cappuccinopc.com

# Hardware: Power #

  * If build self: Power system Monitoring via RS232
  * Build [Jaldi Charger](http://drupal.airjaldi.com/system/files/Jaldi_Charger_design_1.6.3.pdf)

| Description (link is to buy site) | Datasheet? | Notes | Price |
|:----------------------------------|:-----------|:------|:------|
| [Passive POE injector for battery hookup](http://www.beezwaxproducts.com/product_info.php?manufacturers_id=11&products_id=168&osCsid=00c9df71ebfff87c0b1a966601b96c49) |            | more options on the site. |$8     |
| [5-port Passive POE GigabitSwitch](http://www.beezwaxproducts.com/product_info.php?manufacturers_id=11&products_id=193&osCsid=00c9df71ebfff87c0b1a966601b96c49) | [yes](http://tyconpower.com/products/files/TPS_POE_Switch_Spec_Sheet.pdf) |       | $135  |
| [8-port Passive POE 10/100 Switch](http://www.beezwaxproducts.com/product_info.php?manufacturers_id=11&products_id=194&osCsid=00c9df71ebfff87c0b1a966601b96c49) | [yes](http://www.tyconpower.com/products/files/TP-SW8_POE_Switch_Spec_Sheet.pdf) |       | $170  |
| [5-port Passive POE 10/100 Switch](http://www.beezwaxproducts.com/product_info.php?manufacturers_id=11&products_id=209&osCsid=00c9df71ebfff87c0b1a966601b96c49) | [yes](http://tyconpower.com/products/files/TPS_POE_Switch_Spec_Sheet.pdf) |       | $125  |
| [65W 12V solar panel](http://www.solarpanelsonline.org/Solartech_Power_65W_12V_Poly_Solar_Panel_p/spm065p-n.htm) | [yes](http://www.solartechpower.com/solarpanelmanual/SPM065P.pdf) | more options on site | $250  |
| [AGM Gel Batteries](http://www.solar-electric.com/unba.html) |            | Many sizes and options | $55 for 35Ah |
| [http://www.batteryweb.com/universal-batteries.cfm All UB Batteries |            | Call for prices |       |
| [12/24V 8A Solar Charge Controller](http://www.beezwaxproducts.com/product_info.php?manufacturers_id=11&products_id=137&osCsid=00c9df71ebfff87c0b1a966601b96c49) | [yes](http://www.tyconpower.com/products/files/TP-SC_Charge_Controller_Spec_Sheet.pdf) |       | $35   |
| [12V 8A Solar Charge Controller w/POE ](http://www.beezwaxproducts.com/product_info.php?manufacturers_id=11&products_id=76&osCsid=00c9df71ebfff87c0b1a966601b96c49) | [yes](http://www.tyconpower.com/products/files/TP-SCPOE_Charge_Controller_Spec_Sheet.pdf) | other input/output options avail | $60   |
  * lots of good stuff: http://www.beezwaxproducts.com/index.php?manufacturers_id=11&osCsid=00c9df71ebfff87c0b1a966601b96c49
  * [solar calculator](http://freecleansolar.com/solar_calculator.php)
  * [Solar radiation calculator](http://rredc.nrel.gov/solar/calculators/PVWATTS/version1/)

> More stuff in our [GIANT HARDWARE SPREADSHEET](https://spreadsheets.google.com/spreadsheet/ccc?key=0AnA6LOF3_NU1dHBkaHRIUlktZWxzUTdBdC1wb0xHV0E&hl=en_US)

_"Any Ubiquiti radio can use a PoE
supply of 12 to 24V. A NanoStation
requires around 6W._

Remember that the Ubiquiti PoE
supply provides grounding for the
required shielded (FTP) CAT5
cable. If you use another PoE
system, you need to provide
grounding for the shield."_http://ubnt.com/forum/showthread.php?t=38378&highlight=volt_

# Hardware: Other #
Technically these are hardware, RF but that section was full...
[nice DIY omni](http://www.dxzone.com/cgi-bin/dir/jump2.cgi?ID=12609)
[more antenna links](http://www.dxzone.com/catalog/Antennas/WiFi/)

# Software: Security / Captive portal / QoS management #

Preface all of this with "Antoine Can't Stand Chilli"...  Need to develop a roadmap to quickly prove that this direction isn't biting off more than we can chew.

## Assumptions ##
  * There are no truly trustworthy links on the mesh, but we want to make causing problems a little challenging...
  * After some thought, we prefer that Authorization (for the mesh) and Authentication (for your identity) be the same method because it discourages sharing credentials.  The drawback here is that if Auth is cert-based and multiple users are using the same device, they would get access to each other's resources.

## Network Security ##
  * Run OLSR Secure such that a key is required to join the mesh
  * Encrypt Mesh transmissions with WPA and a shared key

## Authorization / Authentication / Accounting ##
  * Run 802.11x on the system
    * Mesh Access: Anonymous Cert that can be obtained on an unrestricted SSID
    * Web Access: Need more secure Cert that you get some other way.  Access control is checked first at Access node, then again at Triangle. This allows mesh connectivity in the event of isolation from the core.
  * Certs are controlled by Radius (which is replicated to all triangles)
  * Certs are partitioned from a web browser.
  * Client addresses are inserted directly in routing table

Unknowns: Routing for PTP when a user is using a Web Access Cert.

  * Accounting only required on Internet Gateway.  User access to net is all handled there. (Requires that every gateway be capable of running radius)

## Traffic Control ##

  * Access: Cap on individual client: 4096Mbps
  * Mesh: No QOS -> Build capacity instead
  * Gateway: Fair-Queuing. Ideal to have two separate gateway interfaces from ISP if need lots of RTP traffic.  Otherwise maybe add: http://www.provu.co.uk/converged_ctx1000.html

# Software: Network Monitoring #

The qualitative approach is we want to have every piece of data that one might need to do remote diagnosis.

Major Questions:
  * How much value is AirControl? Specifically, will it find nodes across routed, non-AirOS transitions **ANTOINE: TEST**
  * How flexible are the AirOS nodes WRT building in our own features?
  * How do we serve all this data up to the Cloud?  (we want/need it at a remote site)


## To Monitor: ##
  * Encapsulate all in SNMP
  * PARAMETERS: SNR, txpower, ETX, wireless packet loss, SSID's, software versions,
> > OLSR LQ, OLSR Neighbor LQ's, OLSR Gateway, Net access,
> > Interface throughput (NTOP/SFLOW?  I think this data is available natively...), Interface capacity (ASSOLO), status of connected devices,
> > Power Monitoring via RS232 to Power Control Device, software versions, memory, disk-space, processor
  * longterm dev: Mesh MIB? (currently FabFi Script that logs mesh data)
  * For MaximumKudos: UBNT style site surveys
  * Squid Stats (lightsquid) **ANTOINE: Why not Squid3?**

## Visualization ##

On Map (Afrimesh??):
  * % traffic of clients to mesh, % traffic of client to gateway
  * congested node bottlenecks
    * line color     -> LQ
    * line thickness -> b/w capacity
    * node color -> on/off
    * node shape -> device type
    * node coverage :-)
  * up/down time
  * Click Through to node details
  * (advanced) theoretical max throughput calculation between any two locations based on types of hops and link capacities (KB: I say theoretical because empirical probably doesn't scale.

For Visited URLs
  * Calamaris

For Graphing
  * Cacti


# Software: Network Management #

  * Bulk Node management
    * firmware updates w/ config retention, incl updates based on current FW version
    * change a config var for whole network (e.g. WEP key, SSID's)-> firmware can ship with postupgrade scripts

  * Server management
    * Puppet/Matahari

  * etwork Optimization (advanced)
    * Identification of potential single points of failure  (to gateway, to content)
    * Channel and power management based on ambient conditions
      * interference
      * neighboring access nodes
      * Goal, to achieve maximum performance while achieving adequate redundancy.

# Proxty and Caching #

  * Polipo: Web cache optimized for crawling

# Etc: Miscellaneous #

  * Fabfi starter kit:
    * Two devices to build a basic network (flashed/configured extra)
    * Net cables
    * USB Stick with any relevant software

  * Stable, generally accessible cloud management server for starter kits
    * When you get your starter kit it automatically can use cloud server with little or no config

  * FabTrek Tricorder:  Android-based tablet with all the network diagnosis tools you can dream of and a 3g backup in case you need net when fabfi is down. Need a tablet with wired ethernet and USB (for usb-serial or wi-spy) tho.

  * Long-link:  build and debug a fabfi link that's 20Km+, develop how-to
