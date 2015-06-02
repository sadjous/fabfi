# System Overview #

Every Fabfi system consists of one or more _Head nodes,_ and one or more _Common Nodes_.  The network access is controlled, and network performance monitored, by  by a _management server_, which can either be installed locally or in any location on the public internet. For networks where IPv6 is not provided natively by the uplink, the network uses a _tunnel provider_ on the internet to obtain an IPv6 address.

This guide will walk you through the steps of:
  1. Registering for an account on the FabFi management server
  1. Obtaining an IPv6 ip address
  1. Flashing a FabFi device
  1. Configuring your first network



# Part 1: Register for a FabFi provider account #

Coming Soon.

`*` You do not need a fabfi operator account if you prefer to [build your own management server](FabfiServer5.md).

# Part 2: Configure IPv6 Tunnel #

**If your Internet Service Provider (ISP) already provides you with an IPv6 address with a /48 subnet mask, you may skip this step.**

  * If you have a static IPv4 IP from your internet service provider, you must configure a SIT tunnel.  To do this:
    1. Obtain a free account from [tunnelbroker.net](http://tunnelbroker.net/register.php)`*`.
    1. Connect any computer or home wireless router that will respond to `ping` to the IPv4 address you would like to use.
    1. In your tunnelbroker account, click "Create Regular tunnel" on the left sidebar.
    1. Enter your static IPv4 address, then choose a location closest to you.
    1. A green box should appear under the IP you entered, indicating that tunnelbroker can reach it via `ping`.  If not, make sure your address in pingable
    1. Click "Create Tunnel"
    1. On the page for your new tunnel, click "Assign/48".  The link should be replaced with an IP address.
    1. You're done!  (the router configuration script will automatically set up the other end of the tunnel for you)

  * For _dynamic_ public IPs or networks hidden behind a NAT, you must [obtain a tunnel account through SixXs.net](https://www.sixxs.net/signup/) (this process may take as long as two days to complete).
    1. Once you have a SixXS account, log in and navigate to the "request tunnel" link on the left side.
    1. Choose tunnel type:
      * If you have a _dynamic_ public IP, create a dynamic tunnel
      * If you are behind a NAT, create an AYIYA tunnel
    1. Enter the City your endpoint is in and click "Next Step"
    1. On the following page, select the endpoint closest to you, and fill in the reason for selecting the endpoint / use of tunnel.  This WILL be read by a real person, so be genuine in your response.
    1. Click "Place Request for New Tunnel"
    1. Your tunnel will typically be approved in a few hours and you will be notified by email.
    1. Once your tunnel is approved, go to your homepage and click "request subnet" on the right.
    1. Select your new tunnel from the dropdown box and enter a reason for needing a subnet.  Again, this WILL be read by a real person, so be genuine in your response.
    1. Your request will typically be approved in a few hours and you will be notified by email.

`*` You can also obtain static tunnels from SixXS.net, but their process is slower, so best to avoid them unless you are behind a NAT or do not have a static IPv4 IP.

# Part 3: Flash device firmware #

_This tutorial will help you configure a simple network using the starter kits available at [the Fabfolk Store](http://store.fabfolk.com).  If you intend to follow the tutorial verbatim, you should flash the routers from either:
  * 2 "City-Scale" kits (developer or outdoor)
  * or 1 "Budget" Head Node and 1 "Budget" Common Node Kit_

### Prepare your computer ###

This tutorial is based on ubuntu 11.04`*`:

  1. Install TFTP
```
sudo apt-get install tftp
```
  1. Set up Serial communication _(This section is only required for users of the Linksys WRT1260NL)_
    1. Install Minicom
```
sudo apt-get install minicom
```
    1. [Build CMOS Serial-->USB adapter](SerialConverter.md)

<a href='Hidden comment: # Obtain a USB to CMOS-level serial adapter, such as [http://www.makershed.com/FTDI_Friend_v1_0_p/mkad22.htm?1=1&CartID=0 this]
# Wire the  some wire or a header to attach the converter to the router, and a usb cable to connect to your computer *TODO: Spec a Kit with all the right components*'></a>

`*`If you do not have a computer running Ubuntu or another debian-based linux machine, we recommend you obtain one before proceeding.  If you do not have a computer that you can configure to run linux natively, you can boot Ubuntu from an installation CD or USB Stick as described on the [Ubuntu download page](http://www.ubuntu.com/download/ubuntu/download).

### Download and install firmware ###

The firmware image and installation procedure for each device is different.  Proceed by choosing your device:

  * Linksys WRT160NL
  * Ubiquiti RouterStation
  * Ubiquiti PicoStation and NanoStation-Loco

# Part 4: Configure your first network #

_Follow these instructions to build a simple network with the [Fabfolk Starter Kits](http://store.fabfolk.com).  If you would like to configure your network differently, you might want to read AdvancedNetworkDesign._

## Configuring the City-Scale Kit ##

coming soon

## Configuring the Budget Kit ##

coming soon

<a href='Hidden comment:  * Each device in a fabfi network has one or more radios
* Each radio in a Fabfi device can make one of three different types of connections:
# 5Ghz mesh
# 2.4Ghz mesh
# 2.4Ghz client access
# (coming soon) 2.4Ghz client access + mesh
'></a>