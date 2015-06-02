# Frequently Asked Questions #



# General #

## I want to follow fabfi development ##

Subscribe to our [Google Group](http://groups.google.com/group/fabfi)

## I want to work for you! ##

  1. Start Listening in: Subscribe to our [Google Group](http://groups.google.com/group/fabfi)
  1. If you can code, go here http://code.google.com/p/fabfi/issues/list and fix something.  (Ask us if you need to log in to a testbed to do whatever.)
  1. If you are interested in volunteering at a deployment, write us at fabfi at fabfolk.com

## I want to make a business from this, how can I do that? ##

All of the software and hardware used in the FabFi project are open source under various licenses; most of the FabFi contributions to put it together as a system are CC-BY which allows others distribute, remix, tweak, and build upon your work, even commercially, as long as we are credited for the original creation as appropriate.   Everything is freely available to download at http://fabfi.fabfolk.com

## I am planning / have made a FabFi network, will you list me on your page? ##

Absolutely!  Email us at fabfi at fabfolk.com

## How can I get/give help funding, planning, installing, or running a FabFi network in my village? ##

The community of people who can answer questions grows every day.  We're always happy to answer your questions but may not be able to show up in your village with a suitcase full of gear.  The lovely thing about FabFi is you can start small and add as your local community interest grows.

We get lots of mail from both people interested in helping overseas small communities as well as people from those communities.  We do our best to help match them up.  FabFi is currently mostly technical geeks and open to further help with this process.  Some kind of web thing would be nice.

## Do you provide funding to help with my project? ##

FabFolk, the Fab User's Organization, makes small grants for projects that are socially impactful (meaning it's not just good for only you), uses Fab processes (FabFi already counts), and **contributes to** the larger Fab community.

Generally, however, FabFolk is unable to fund isolated instances of FabFi networks alone.  We are willing to help you propose your project to other philanthropic or community organizations.

# Architecting (Planning) Your System #

## How should I size my ISP uplink? ##

The rule of thumb is to allow 100 kbps for each subscriber.  This would provide decent speeds suitable for streaming content.

## How big can my mesh get? ##

The achilles heel (weak point) of meshes is that speeds are reduced every time data has to pass from A --> B --> C where B has a single radio and the A-B and B-C links are both wireless. If you're building a large mesh, you want to configure your network topology avoid this situation whenever possible.

The primary strategy for doing this is pairing multiple devices together with a wired ethernet connection and setting the radios to non-overlapping channels.  If these pairs are arranged properly in your network, you'll be able to transit traffic over many hops with very little penalty.

Another element that affects performance at scale is local interference.  Because only one device can use a radio channel at a time, dense meshes will perform poorly if all the communications are on the same channel.  Selecting channels so that adjacent access nodes are non-overlapping will improve throughput.

When configuring nodes, the current version only provides N speeds with AP in station mode.  Ad
hoc mode will peak out at ~15Mbps real.  There have been work reported
online of ath9k driver improvements that give N speeds in ad hoc.  We
haven't had a chance to try it yet, but we want to hear about it if you do.

Assuming you have all the details right, a completely unsegmented mesh (that is, a mesh where there is no hierarchical routing) can theoretically scale to on the order of 10,000 nodes before devices are unable to handle the necessary routing information.

## Sometimes you show a node with more than one radio frequency.  Are the radios dual band? ##

A "node" can refer to more than one piece of hardware or device.  All the devices together at a single site is usually termed a "node".

The Ubiquity (Kenya) and Linksys (Jalalabad) devices are single band.  We use multiple devices together, sometimes termed "[back to back](back_to_back.md)" to accomplish the multiple frequencies.  This is advisable in every case because a correctly
configured network of paired devices will have much better multi-hop
throughput.  With single devices, every hop will degrade throughput
down to a floor of 1/7 of single link capacity at 5-6 hops. Paired
devices that go `wireless` - `wire` -`wireless` on non-overlapping
channels will experience little or no degradation.

There are dual band radios such as from [http://www.open-mesh.com/index.php/enterprise-mesh.html](OpenMesh.md)  which we have not tried but are eager to hear your experiences with.

## Is there a way to use a single channel or is everything set up to use non-overlapping channels? ##

It is possible to use a single channel for everything, however this would have a significant impact on performance, particularly for multiple hops.

Where you care most is the backhaul links.  That is, the links that are carrying aggregated traffic from multiple access devices.  Those you want to carefully plan so that each hop is on a non-overlapping channel and you don't get hidden node interference from adjacent links.

Access nodes are less important for real-time internet use since the maximum amount of bandwidth delivered to a single access device is probably small in comparison to its performance, but if you anticipate a lot of intranet traffic you'll want to be careful about channel planning there too.

## I'm planning a system that is 36km away from an internet connection.  What do you think about spanning 36km for backhaul? Should we use the PowerBridgeM with 2.4 GHz or try to use a Bullet M with 11x14" grid antenna? ##

For a 35km link, you can expect somewhere between 130-140dB of free space loss (depending on freq), so you're going to need 20dBi gain or more.  2.4Ghz will likely be more robust for a very long link, but requires a much greater Fresnel clearance (33m vs 22m).

The powerbridge _should_ have enough gain (barely) @25dB, but the bullet has the advantage that you can always get a bigger antenna if you find you need more (I don't know what gain you're getting out of an 11x14" grid).

IME, large parabolics are more effective for links with weak signals than high-gain patches.  We have had good luck using nanostation-loco devices as feed elements for parabolics, increasing their gain up to 15dBi with a 3.5' homemade reflector.  Given how directional the powerstations are, I'm not sure if the same approach would give you similar results.

Some useful calculators here.
http://www.terabeam.com/support/calculations/

You want about 20dB above the noise floor for a totally robust link.  The ubiquiti datasheets will give ballpark numbers for what sort of hardware speeds you can expect at different signal strengths (the listed values will be at least double the real throughput).

# Philospophical #

## How does FabFi differ from Freifunk? ##
(aka, an essay by A. van Gelder)

**Freifunk and FabFi**

To better understand the differences between the Freifunk and FabFi
projects and identify valuable similarities we need look no further
than the different circumstances into which each was born.

The initial development of Freifunk took place in Berlin, Germany at a
time when many communities found themselves struggling to cope with
the effects of depopulation, unemployment and social instability that
followed the fall of the Berlin Wall. From the beginning, the goal of
the developers was the creation of a communal infrastructure for the
sharing of information and resources without the need for any central
authority or control. The ready availability of fast Internet access
in Germany created a situation where many users were willing to share
their connections with the mesh, creating a lifeline for residents who
could not afford commercial Internet access.

Set against the backdrop of reconstruction efforts in Afghanistan the
birth of FabFi took place in the Jalalabad FabLab with the goal of
bringing high-speed Internet to a village, hospital, university and
NGO in the city. The constraints imposed by a rural environment with
low population-density, the high cost of Internet access, limited
availability of networking equipment and scarcity of technical skills
drove FabFi development to solve a very different set of problems.

The urban environment of Berlin is an ideal environment for rapid
growth of a mesh network. High population density places nodes close
enough to each other that reliable communication can be established
without a complex installation procedure or specialized equipment to
extend the limited range of WiFi. The proportion of technically
skilled users on the network is sufficient to provision and manage the
network without requiring centralized infrastructure or dedicated
staff. Finally, the cost of Internet is low enough that bandwidth can
be shared freely without the need for billing systems or access
control.

By contrast, the rural environment of the Jalalabad network is made up
of small clusters of nodes joined by long-range links that require
expensive equipment and a high-level of skill to install. In the
absence of a pre-existing skillbase to provision and maintain the
network dedicated staff need to receive support, training and
centralized management infrastructure. Internet connectivity can only
be provided sustainably by instituting access charges.

Freifunk consists of the following components:
  * Mesh router hardware, generally the Linksys WRT54GL
  * Mesh router firmware consisting of:
    * olsr mesh routing software
    * web configuration interface
    * a choice of two functional modes:
      1. mesh node
      1. mesh node sharing an Internet gateway


FabFi is comprised of the following components:
  * Mesh router hardware
  * Mesh router firmware
    * olsr mesh routing daemon
    * captive portal
    * command-line configuration interface
    * a choice of three functional modes:
      1. mesh node
      1. backhaul
      1. head node
  * Backhaul router hardware
  * Reflector
  * Training materials
  * Mesh management server hardware
  * Mesh management server software
    * Management dashboard
    * Provisioning service
    * Gateway router
    * AAA service
    * Content filter
    * Caching proxy