

# Introduction #

The LinksysWRT16NL is the device most commonly used as a headnode in Fabfi.  It has a weaker radio than the Ubiquiti devices, so it is generally not used for client access or long-range applications.

# Flashing #

**MAKE SURE YOU HAVE STABLE POWER WHEN FLASHING A DEVICE.** A power cycle while the flash is writing will almost surely brick your device.

## Prerequisites ##

**Hardware you will need:**
  1. A serial cable (or, for most modern users, a usb --> serial connection)
  1. A RS232 converter
    * combine 1 and 2: Google "USB to TTL Serial" and you'll find lots of products [like this](http://www.makershed.com/ProductDetails.asp?ProductCode=TTL232R) or [this](http://www.sparkfun.com/products/9718)

  1. A Linksys WRT160NL Router

**Software you will need:**
  * The latest image to be flashed
    * (This can either be [built using openWRT and the latest SVN download](HowtoBuildAFabFiImage.md), or downloaded directly from [here](http://fabfi.googlecode.com/files/fabfi-wrt160nl-factory.bin))
  * A TFTP program
    * Linux: tftp
```
sudo apt-get tftp
```
    * Windows: tftp
      * On Windows 7 you'll have to enable TFTP.  open Control Panel > Programs and Features > click Turn Windows features on or off in left side > enable Client Telnet  and  Client TFTP then click in OK.
      * we found we couldn't really ever get tftp working well on windows, but we're biased.
  * A Serial program
    * Linux: minicom
```
sudo apt-get minicom
```
then read HowToSetUpSerialMinicomLinux
    * Windows: Did we mention windows is not recommended? Windows no longer has "hyperterminal". Google for "windows hyperterminal alternatives" (we used "Tera Term", recommended from http://helpdeskgeek.com/windows-7/windows-7-hyperterminal/ and it worked ok)

_NOTE: All the instuctions on this page are linux-specific._

## Procedure ##

In this procedure you will be setting up the linksys to receive a firmware image via TFTP, then sending the image from your computer over an ethernet connection. TFTP is VERY sensitive to extra stuff being sent over the wire.  In order to minimize the time between when the reouter starts listening for data and when you send the firmware, we recommend you do the ["on the computer"](#On_the_Computer.md) section below all the way through step 8, then do all of the ["on the router"](#On_the_Router.md) section, then finish the ["on the computer"](#On_the_Computer.md) section.

### On the Router ###

  1. Open up the Linksys case (OMG, you just voided your warranty!  Why'd you do that?!?) connect your computer to the Linksys Device via serial cable as shown below.  Pinout is
    1. 3.3V
    1. TX
    1. RX
    1. NC
    1. GND (this is the pin closest to the fromt of the device)
    * Note: serial pins are also accessible from the ethernet ports. See the link in the intro for an image of this.
  1. Launch your hyperterminal (serial) program and set the baud rate to 115200. Or, if you are in linux, HowToSetUpSerialMinicomLinux
  1. Restart the router (by power cycling)
  1. You should see lots of things start printing in the serial connection
    * (If the text is not understandable (lots of black blocks, etc.) it means you are either at the wrong baud rate, or the physical serial connection is not good. Try fiddling with the wires)
  1. You'll see the text "hit any key to stop autoboot".  Immediately start pressing any key.  You get a fraction of a second to do so.
  1. Assuming you have done this correctly, you should see the console message change to "ar7100>"  and it should be ready for you to write commands
  1. Enter the command
```
$ upgrade code.bin
```

### On the Computer ###

> _Note: "tftp" stands for 'trivial ftp', and is used for simple transfer protocols - like flashing a device._

  1. Download the [fabfi firmware for linksysWRT160NL](http://fabfi.googlecode.com/files/fabfi-wrt160nl-factory.bin).
  1. Connect an ethernet cable to port 4 on the linksys device
  1. Change your ip (or if linux, your network connection) to the following settings:
    1. Set the wired connection mode to "manual" (instead of dhcp)
    1. ip: 192.168.1.(2-254) (ie. 192.168.1.254)
    1. netmask: 255.255.255.0
    1. default gateway: 192.168.1.1
  1. Make sure you are connected and your computer can see the ethernet connection to the linksys
  1. Open up a new terminal window
  1. Navigate to the folder where you have saved firmware
  1. Now type the following to start the tftp program and bring up the "tftp" prompt
```
$ tftp 192.168.1.1
```
  1. Now type:
```
$ binary (sets program mode to binary)
$ trace on (shows you output)
```
  1. Now type
```
$ put fabfi-wrt160nl-factory.bin code.bin
```
As the tftp starts pushing data to the router, you should be lots of stuff happening in your terminal window.

When the tftp finishes sending all of the commands, you should
  * Exit tftp by typing
```
$ q
```
  * DON'T TOUCH THE ROUTER UNTIL IT SAYS DONE in the minicom window.

Once the minicom window says "done", power cycle the router and move on to the next section

### Possible Errors While Flashing: ###
Problems:
  * While re-flashing, on the serial console something is printed out about "bad code sector" (or something serial) OR
  * On reboot, the device never finishes starting up, and (despite you trying to press enter a couple times) will never get to the "open wrt wireless freedom" screen.

Diagnosis:
  * Possible incomplete or corrupt code download OR
  * Image too old

Solution:
  * Check to make sure you have the correct .bin file (the flash image)
    * You should have the flash image - not the sys-upgrade image
  * Try downloading the .bin file again (it may have gotten corrupted on download
    * Note: firefox is better for downloading than chrome
  * Try contacting the FabFi admins to get the latest image - you may have an image that's too old.

# Configuration Script #

Once you've flashed and power-cycled your router, you're ready to run the configuration script.

_Note: In addition to the connection method described below, is also possible to run the configuration script from the serial console (but BEWARE, you can't use backspace when running the script from the serial console).  You can also connect to the router on port 1 or 2 at 192.168.1.10, using the same static settings as you used in the flashing section._

  1. set your ethernet settings back to automatic
  1. Plug into port 4 of the router (you should get a DHCP address)
  1. run
```
$ telnet fabfi.lan
```
This should log you into the router
  1. run
```
$ sh setup
```
You will see the following prompts/settings when you do so, so you should prepare all of your settings beforehand. Explanations/examples are listed below:

  * Number of Fabfi: A unique number for this node
  * Wireless Channel: The channel the wireless network will be on
  * Headnode? (y/n): Is this a headnode?
  * Transmit distance: How fat away is the farthest device this node will be connecting to?
  * WEP Key (d for default)
  * Device Name: A descriptive name for this node
  * Radio Mode: how would you like to use the wireless interface?
  * GPS Location? (using decimals): Where is this device?
  * IP of your Cloud (radius) Server (for headnodes only)
  * radius secret: (for client access nodes only)
  * a login password

Most settings are self explanatory, except for the Wireless Configuration.  You will be presented with 7 choices:

  * STA: wifi is part of WIFIMESH as a Station
  * Dual AP: wifi is part of WIFIMESH as an AP and provides a client-access AP
  * ADHOC: wifi is part of the ADHOCMESH
  * Client AP: wifi is used to provide only a client-access AP
  * Fabfi AP: wifi is part of WIFIMESH as an AP
  * Admin AP" wifi is a private AP for administrative use only

Check out [the addressing conventions](SystemArchitecture#Network_Architecture_and_Addressing_Conventions.md) for explanations of what the different networks in caps are, then choose the setting that fits you best.

For further explanation of exactly what each setting does, you'll have to read [the config script](http://code.google.com/p/fabfi/source/browse/trunk/files/router_configs/WRT160NL/etc/fabfi-scripts/fabfi-setup)

After the script completes, the router will reboot automatically and will be ready to go.

**After running the configuration script, you will no longer be able to use telnet.  You will have to log in using `ssh` and the password you set during setup.**

## Squid Configurations (headnode only) ##

If you choose "y" for creating a headnode, you will be asked if you want to configure squid.

Squid requires the use of a USB storage device.  It can be a USB stick or an external hard-drive.  When you choose to install squid, the script will attempt to configure your drive for you.  We're not geniuses at writing software, so for some parts the script will simply give you instructions for what to enter into the terminal (in particular for formatting the hard disk).  Simply follow them.  The instructions will look something like this:

```
 * d - delete all partitions
 * n - new partition
 * p - primary partition
 * 1 - for partition number
 * 1 - for first block
 * +<somenumber>M for next block where <somenumber> is the size of your drive in MB. minus 250MB.
 * n - for new partition
 * p - for primary position
 * 2 - for partition number
 * <enter> 2x - for defaults
 * w - write changes
```
This will format your external disk for squid and swap.

**Choosing squid configuration adds and extra automatic reboot cycle after you have completed the script** at the end of the script the router will reboot all the way, run some more tasks, then reboot again.  **Do not disturb the device during this process**.

At this stage of development, there are some manual tasks that need to be completed after the auto-config has completed.  see [the squid page](SquidTroubleshooting#Squid_Configuration.md) for more information.

## Config Script Troubleshooting ##

If you mess up the setup script at any point, do the following (in the serial console):
  * Type "firstboot"
  * Wait 15 seconds (for the command to finish)
  * Do a full hard reboot
  * Try the setup process again

If your password did not have register correctly, and when you try to log into ssh, it refuses your password:
  * Connect via serial
  * Type "passwd" and reset your password. Then try logging in again


# Additional Configuration #

In many installations, you will want to have static I settings for the WAN connection on your headnode.  By default the WAN is set to automatic.  You will have to manually edit the network settings if you want it to be otherwise. Here's how.

In all the auto-configurations, port 4 on the router (and sometimes others too) is a good old-fashioned LAN port.  Set your laptop to automatic and plug into it with a network cable.  You should get a dhcp address.  Then do the following

log in:
```
$ ssh root@fabfi.lan
```
fabfi.lan should simply be the default gateway you get from dhcp.

Once you're logged in, configure the wan interface [according to these instructions](CustomConfigurations#Static_WAN_IP.md)

# Flash Troubleshooting #
This is unsubstantiated, but:

"If it gets locked up, power up and click the WPS button repeatedly while pinging.  Once you get a response, you're in."