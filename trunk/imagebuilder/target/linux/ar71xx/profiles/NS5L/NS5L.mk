#
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/NS5L
  NAME:=ubiquiti ns5l
  FILES:=fabfi
## Assuming the following are automatically added
# base-files busybox dnsmasq dropbear firewall hotplug2 iptables kmod-diag kmod-ipt-nathelper kmod-switch
# libc libgcc mtd nvram opkg ppp ppp-mod-pppoe uci udevtrigger wpad-mini 
#
## Order of Package files
# USB
# Wireless
# Firewall stuff
# Fabfi crap...

  PACKAGES:=kmod-ath kmod-ath9k kmod-mac80211 -kmod-madwifi libnl-tiny crda wpad-mini \
libuci luci-medium luci-app-firewall luci-app-qos \
snmpd libnetsnmp \
bridge \
olsrd olsrd-mod-nameservice olsrd-mod-txtinfo olsrd-mod-dyn-gw \
awesome-chilli kmod-tun librt\
-uhttpd mini-httpd \
libpcap tcpdump \
libopenssl libpthread squid \
uclibcxx iperf \
kmod-gpio-dev kmod-button-hotplug kmod-input-core kmod-input-gpio-buttons kmod-input-polldev kmod-leds-gpio \
-kmod-usb-core -kmod-usb-ohci -kmod-usb2 -kmod-scsi-core -kmod-usb-storage -kmod-fs-ext3 -e2fsprogs -block-extroot -block-mount -kmod-fs-mbcache \
-ppp -ppp-mod-pppoe -kmod-ppp -kmod-pppoe -kmod-crc-ccitt \
-squid


#libpcap tcpdump \ uclibcxx iperf \ gpioctl \

#kmod-usb-core kmod-usb-ohci kmod-usb2 kmod-scsi-core kmod-usb-storage block-extroot \
#	crda iw kmod-b43 kmod-b43legacy kmod-cfg80211 kmod-mac80211 wireless-tools libnl-tiny \
#	libiptc libxtables kmod-ipt-conntrack kmod-ipt-core iptables-mod-conntrack iptables-mod-nat kmod-ipt-nat luci \
	


endef

define Profile/NS5L/Description
	Package set optimized for the NS5L fabfi
endef
$(eval $(call Profile,NS5L))
