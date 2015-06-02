# Introduction #

This page details the steps for using various USB Modems with OpenWRT.  Though we have not tried it, we suspect that it is possible to use a single linksys with both a USB Storage device and a USB modem by adding a USB hub. This page currently explains how to install the modem on a stock OpenWRT image.

When using a USB modem as an uplink we always suggest running s squid cache on your headnode for best performance.

# Basic Requirements #

All USB Modem applications will require (or at least won't be hurt by the following:

  1. Install stock image
  1. remove kmod-usb-ohci
  1. install usbutils kmod-usb-serial, kmod-usb-serial-option, kmod-usb2 kmod-usb-uhci usb-modeswitch usb-modeswitch-data comgt (auto-installed dependencies libusb zlib chat)

# Device Specific Instructions #

## ZTE AC 2726 ##

_Note: This device currently may require hotplugging between connections to work correctly.  I suspect we're missing some sore of reset in the disconnect commands_

  1. edit /etc/modules.d/60-usb-serial
```
usbserial vendor=0x19d3 product=0xfff1 maxSize=4096
```
  1. Mod network settings:
```
config interface wan                                                                                                                  
        option ifname   ppp0                                                                                                          
        option proto    3g                                                                                                            
        option auto     1                                                                                                             
        option service  evdo                                                                                                          
        option device   /dev/ttyUSB0                                                                                                  
        option apn      orange.co.ke                                                                                                  
        option username <phone #>                                                                                                   
        option password <pin>
```



Now your device should be recognised and have the correct device type (0xfff1 - read from lsusb)

NOTES:

on reboot, device is recognized after a while (I think).  In it's base state light blinks red. you have to manually switch it (usb\_modeswitch /etc/usb\_modeswitch.d/19d2\:fff5), then ifup wan works and turns light fast blinking green.

## Huawei E160 / 220 ##

[Start here](http://josefsson.org/openwrt/dongle.html) and scroll down to "Enabling 3G/UMTS"

# Auto-switching and detecting Modems #

_This section is under construction_

The following script looks for one of the supported modems.  If it doesn't find it, it tries modeswitching.  Once it finds a modem it enables the correct interface (assumes you have configured two interfaces called `wan` and `saf` and expects to be dealing with Huawei modems (a CDMA and a HSPA))
```
#!/bin/sh

#the huawei modem doesn't switch on the first run of usb_modeswitch. it will switch after the second, third, etc
while  ( lsusb | grep -i 12d1:1446 ) do 

echo "Trying to switch device to modem mode";
usb_modeswitch;
done

sleep 2;
#orange modem settings are defined in /etc/config/network under interface wan
#safaricom modem settings are defined under saf

if ( lsusb | grep -i 12d1:1001 ) then  
echo "Orange Modem detected";
ifup wan;
fi

#the safaricom modem works out of the box - no need for modeswitching. The Kisumu one , however, does require modeswitching

if ( lsusb | grep -i 12d1:1003 ) then 
echo "Safaricom Modem detected";
ifup saf

fi
```