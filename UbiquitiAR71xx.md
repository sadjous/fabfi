

# Introduction #

Ubiquiti devices are most often used as Fabfi common nodes.  We use three different form factors:

  * [NanostationM5-Loco](http://www.ubnt.com/downloads/loco_m5_datasheet.pdf)
  * [NanostationM2-Loco](http://www.ubnt.com/downloads/loco_m2_datasheet.pdf)
  * [PicostationM2-HP](http://www.ubnt.com/downloads/datasheets/picostationm/picom2hp_DS.pdf)

but from a software perspective they're all identical.  (their firmware is, in-fact interchangeable)

# Flashing #

**MAKE SURE YOU HAVE STABLE POWER WHEN FLASHING A DEVICE.** A power cycle while the flash is writing will almost surely brick your device.

## Prerequisites ##

**Hardware you will need:**
  1. A Router with power supply
  1. two ethernet cables

**Software you will need:**
  * The latest image to be flashed
  * (This can either be [built using openWRT and the latest SVN download](HowtoBuildAFabFiImage.md), or downloaded directly from [here](http://fabfi.googlecode.com/files/))
  * A TFTP program
    * Linux: tftp
```
sudo apt-get tftp
```
    * Windows: tftp
      * On Windows 7 you'll have to enable TFTP.  open Control Panel > Programs and Features > click Turn Windows features on or off in left side > enable Client Telnet  and  Client TFTP then click in OK.
      * we found we couldn't really ever get tftp working well on windows, but we're biased.

_NOTE: All the instuctions on this page are linux-specific._

## Procedure ##

In this procedure you will be setting up the device to receive a firmware image via TFTP, then sending the image from your computer over an ethernet connection. TFTP is VERY sensitive to extra stuff being sent over the wire.  In order to minimize the time between when the reouter starts listening for data and when you send the firmware, **we recommend you do the ["on the computer"](#On_the_Computer.md) section below all the way through step 8, then do all of the ["on the router"](#On_the_Router.md) section, then finish the ["on the computer"](#On_the_Computer.md) section.**

![http://fabfi.googlecode.com/svn/wiki/images/Devices/UbiquitiReset.jpg](http://fabfi.googlecode.com/svn/wiki/images/Devices/UbiquitiReset.jpg)

### On the Router ###

  1. Do steps 1-8 on the ["on the computer"](#On_the_Computer.md) section
  1. Connect a ethernet cable between your computer and the LAN port on the Ubiquiti power supply
  1. Connect a second cable to the POE port on the power supply
  1. Press and hold the reset button next to the ethernet port
  1. insert the other end of the second network cable into the device while continuing to hold the reset button.  You should see a green and orange LED
  1. Hold the reset button until you see a red and an orange LED light in sequence, then release.  If you succeed, you'll get pairs of LEDs blinking on and off.

### On the Computer ###

> _Note: "tftp" stands for 'trivial ftp', and is used for simple transfer protocols - like flashing a device._

  1. Download the fabfi firmware for your device:
  * [NanostationM5-Loco](http://fabfi.googlecode.com/files/fabfi-nanom5-factory.bin)
  * [NanostationM2-Loco](http://fabfi.googlecode.com/files/fabfi-nanom2-factory.bin)
  * [PicostationM2-HP](http://fabfi.googlecode.com/files/fabfi-picom2_hp-factory.bin)
  1. Change your ip (or if linux, your network connection) to the following settings:
    * Set the wired connection mode to "manual" (instead of dhcp)
    * ip: 192.168.1.(2-254) (ie. 192.168.1.254)
    * netmask: 255.255.255.0
    * default gateway: 192.168.1.1
    * for help with network settings on Ubuntu [go here](ComputingBasics#Configure_a_Static_IP.md)
  1. Open up a new terminal window
  1. Navigate to the folder where you have saved firmware
  1. Now type the following to start the tftp program and bring up the "tftp" prompt
```
$ tftp 192.168.1.20
```
  1. Now type:
```
$ binary (sets program mode to binary)
$ trace on (shows you output)
```
  1. Make sure your new static connection is selected and connected
  1. Now type
```
$ put <filename of firmware> flash_update
```
As the tftp starts pushing data to the router, you should be lots of stuff happening in your terminal window.

When the tftp finishes sending all of the commands, you should
  * Exit tftp by typing
```
$ q
```
  * DON'T TOUCH THE ROUTER until it reboots
    * You'll see the wireless indicator LEDs light up one by one as the firmware flashes, then the device will reboot.
    * When the power and LAN lights are lit and the topmost wireless LED stops blinking, it's done.


### Possible Errors While Flashing: ###

  * If you don't have your comupter connected to the device with a network cable while it's powering up, it will often not accept tftp.
  * If you wait too long after booting the device to push firmware, it will often not accept the transfer.
  * If the device goes into tftp mode (double alternating LED flash), then the firmware will not boot.  Make sure you have a good copy of the most current image and try again

# Configuration Script #

Once you've flashed and power-cycled your router, you're ready to run the configuration script.

once the router is rebooted (you can remain connected to it the whole time with the same settings)
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
  * Device Mode: how would you like to configure the interfaces on this device?
  * GPS Location? (using decimals): Where is this device?
  * IP of your Cloud (radius) Server (for headnodes only)
  * radius secret: (for client access nodes only)
  * a login password

Most settings are self explanatory, except for the Device Mode.  You will be presented with 7 choices. The Formula is "Ethernet / wireless"

  * WAN / AP:
  * Mesh /STA"
  * Mesh / Dual AP"
  * Mesh / ADHOC"
  * WAN / ADHOC"
  * MESH / Fabfi AP (intended for 5Ghz devices)"
  * Mesh / Client AP"

Ethernet side explained:

  * WAN: ethernet is an uplink to the internet
  * MESH: ethernet connects to MESH vLAN

Wireless side explained:

  * STA: wifi is part of WIFIMESH as a Station
  * Dual AP: wifi is part of WIFIMESH as an AP and provides a client-access AP
  * ADHOC: wifi is part of the ADHOCMESH
  * Client AP: wifi is used to provide only a client-access AP
  * Fabfi AP: wifi is part of WIFIMESH as an AP


Check out [the addressing conventions](SystemArchitecture#Network_Architecture_and_Addressing_Conventions.md) for explanations of what the different networks in caps are, then choose the setting that fits you best.

For further explanation of exactly what each setting does, you'll have to read [the config script](http://code.google.com/p/fabfi/source/browse/trunk/files/router_configs/UBNTNANOM/etc/fabfi-scripts/fabfi-setup)

After the script completes, the router will reboot automatically and will be ready to go.

**After running the configuration script, you will no longer be able to use telnet.  You will have to log in using `ssh` and the password you set during setup.**

# Disaster Recovery (serial connection) #

Ubiquiti devices have serial interfaces just like the linksys and can be connected [the same way](HowToSetUpSerialMinicomLinux.md).  In the event you brick a device and lose telnet and ssh access, you'll have to use the serial interface for recovery.

You will have to wire out the pins like this:

Nano

![http://fabfi.googlecode.com/svn/wiki/images/Devices/UbiquitiNanoSerial.jpg](http://fabfi.googlecode.com/svn/wiki/images/Devices/UbiquitiNanoSerial.jpg)

Pico

![http://fabfi.googlecode.com/svn/wiki/images/Devices/UbiquitiPicoSerial.jpg](http://fabfi.googlecode.com/svn/wiki/images/Devices/UbiquitiPicoSerial.jpg)

then follow the minicom instructions in the link above.