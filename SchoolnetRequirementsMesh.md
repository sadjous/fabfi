# requirement specification for the Schoolnet mesh network

# Schoolnet Mesh Network Requirements #

## Mesh Architecture ##

```
[2011/06/27 11:07:40] Amy Sun: goes like this:
[2011/06/27 11:07:42] Amy Sun: there are "triangle" nodes and "circle" nodes
[2011/06/27 11:07:48] Amy Sun: (T and C)
[2011/06/27 11:08:31] Amy Sun: T creates a backbone, can be mesh or infrastructure, but is planned and installed by network "experts".  T's are gateways for C's, they map local dns's  (and do not imply a local AP)
[2011/06/27 11:08:50] Amy Sun: C are "dual band" mesh among C's or at most one T
[2011/06/27 11:09:24] Amy Sun: they are installed in homes by non-techincal user/residents.  (ie, pictorial Ikea-style install instructions).  they have an AP which are set to unique ssid
[2011/06/27 11:09:33] Amy Sun: X are devices, meaning smart phones, laptops, etc.
[2011/06/27 11:10:03] Amy Sun: good.  so, "end state" goal is
[2011/06/27 11:10:09] Amy Sun: max 1000 C's per T
[2011/06/27 11:10:23] Amy Sun: min 3 X per C
[2011/06/27 11:10:40] Amy Sun: "mostly covered" coverage will require minimum 15 T's
[2011/06/27 11:11:43] Amy Sun: the chief goal is this: that the C nodes are totally packaged idiot nodes that go at homes.
[2011/06/27 11:11:49] Amy Sun: they are true meshes
[2011/06/27 11:12:02] Amy Sun: as you add more T's, the performance gets better
[2011/06/27 11:13:38] Amy Sun: so, for example, with ~11-15 T's, need each T to support (max) around 1000 C's
[2011/06/27 11:13:49] Amy Sun: but with 30 T's, each T support 500 C's...  etc
[2011/06/27 11:13:58] Amy Sun: want to keep T's "under 100" ish, you know?
[2011/06/27 11:14:20] Amy Sun: oh, and so we figure we need "akamai light" boxes at all T'
[2011/06/27 11:14:42] Amy Sun: but the thing we want you to stress about is T's supporting 500-1000 C's
[2011/06/27 11:14:50] Amy Sun: (which is to say, waaaaay more than 200)
[2011/06/27 11:14:59] Amy Sun: ok?  no problem, right?
[2011/06/27 11:15:07] Amy Sun: :: innocent smile ::
[2011/06/27 11:15:10] Antoine van Gelder: Excellente. Can has challenge!
[2011/06/27 11:15:27] Antoine van Gelder has learned to phear the innocent smile of the Amy!
[2011/06/27 11:15:47] Antoine van Gelder: What kind of budget are you thinking for T hardware?
[2011/06/27 11:16:05] Amy Sun: my guess is $1500 :
[2011/06/27 11:16:10] Amy Sun: (1) omni 2.4
[2011/06/27 11:16:13] Amy Sun: (2) dir 5
[2011/06/27 11:16:26] Amy Sun: AP?  (if can't get 2.4 to do it also)
[2011/06/27 11:16:33] Amy Sun: ethernet switch
[2011/06/27 11:16:37] Amy Sun: stick/enclosure/etc
[2011/06/27 11:16:41] Amy Sun: ethernet cable
[2011/06/27 11:16:45] Amy Sun: "server" computer
[2011/06/27 11:16:50] Amy Sun: ups, etc
[2011/06/27 11:17:01] Amy Sun: that makes $1500 with some spare
[2011/06/27 11:17:22] Amy Sun: that's what I budgeted for the "test bed".  will probably come down a little when we decide on exact stuf
[2011/06/27 11:17:30] Amy Sun: ah, so,
[2011/06/27 11:18:32] Amy Sun: "The Test Bed"  = { 2 T's, 3C' } + 1 uplink T    (and stuff) =  "minimum set"
[2011/06/27 11:18:45] Amy Sun: = ~$8k
```

### capability requirements ###

  * Support 500-2000 C nodes per T node
  * Support minimum 3 Client devices per C node
  * Transparent Client roaming between mesh nodes
  * .
  * .
  * TODO Keith/Amy

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


### linkage ###
  * http://tldp.org/HOWTO/OLSR-IPv6-HOWTO/  _OLSR IPv6 HOWTO_
  * http://wiki.freifunk.net/6mesh.freifunk.net  _OLSR IPv6 Tools_
  * http://www.open-mesh.org/wiki/batman-adv  _B.A.T.M.A.N. Advanced_

## Routing Architecture ##

TODO Keith


## Roaming and Mobility ##

TODO


## Gateway Routing ##

TODO Keith/Thomas


## Network Provisioning ##

TODO Keith/Thomas/Antoine

### Gateway Provisioning ###

### Node Provisioning ###

### Client Provisioning ###

### User Provisioning ###


## Access, Authorization and Accounting ##

TODO Amy/Keith/Thomas