

# Introduction #
This page is a table of contents for all of the HowTo documentation on this site.  Follow the links below for what you want to build.

**Note: We STRONGLY recommend using linux for working with fabfi.  If you don't want to change your OS, run Ubuntu from a [LiveCD](http://www.ubuntu.com/desktop/get-ubuntu/download).**

# Core Tasks #

The most common use of a FabFi system is to extend or expand a high speed internet connection and charge users so as to recover cost of the leased bandwidth.

The fabfi wireless system consists of three major components which are all open source:

  * **[FabFolk's FabFi Cloud Services](FabfiCloud.md) (or make your own [Fabfi Server](FabfiServer.md))**. The Fabfi server runs in "the cloud", handles the authentication of clients and serves the stats page.  Authentication and user accounting is managed centrally on the Fabfi Server.
  * Make and install physical [Fabfi Nodes](FabfiNodes.md).  Any node can be an uplink to the internet.
    * **[Headnode](FabfiNodes#HeadNode.md)** are local DNS servers and web caches
    * **[Common Nodes](FabfiNodes#CommonNode.md)** make up the physical mesh network
  * **[Fabfi Reflectors](RFReflectors.md)** are used to enhance the RF signal of wifi devices for long-range links.

Administrators [configure Users and Groups](UserAndGroupSettings.md) to control access to the network.

# Advanced Development #

In addition to the basic configuration instructions, we also have a section on Advanced Development that explains how to build images from scratch and perform other custom tasks:

  * [Build your own FabFi Image](HowtoBuildAFabFiImage.md)