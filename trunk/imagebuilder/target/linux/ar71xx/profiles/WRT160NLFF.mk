#
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/WRT160NLFF
  NAME:=Linksys WRT160NLFF
  FILES:=fabfi/wrt160nl/
## Assuming the following are automatically added
# base-files busybox dnsmasq dropbear firewall hotplug2 iptables kmod-diag kmod-ipt-nathelper kmod-switch
# libc libgcc mtd nvram opkg ppp ppp-mod-pppoe uci udevtrigger wpad-mini 
#
## Order of Package files
# USB
# Wireless
# Firewall stuff
# Fabfi crap...

#### Removed kmod-fs-mbcache, as it was not building in imagebuilder.  Also removed fabfi-device since We don't plan on using afrimesh anymore

  PACKAGES:=kmod-ath kmod-ath9k kmod-mac80211 -kmod-madwifi wpad-mini \
coova-chilli \
libuci luci-medium luci-app-firewall luci-app-qos \
mini-snmpd uclibcxx iperf \
libpcap tcpdump \
bridge swconfig \
olsrd olsrd-mod-nameservice olsrd-mod-txtinfo olsrd-mod-dyn-gw \
libopenssl libpthread squid \
-uhhtpd mini-httpd libjson netcat libmysqlclient_r\
freeradius2 freeradius2-mod-files freeradius2-mod-radutmp freeradius2-utils freeradius2-democerts freeradius2-mod-sql freeradius2-mod-sql-mysql \
freeradius2-mod-sqlcounter freeradius2-mod-eap freeradius2-mod-eap-gtc freeradius2-mod-eap-md5 freeradius2-mod-eap-mschapv2 freeradius2-mod-eap-peap \
freeradius2-mod-eap-tls freeradius2-mod-eap-ttls freeradius2-mod-pap freeradius2-mod-chap freeradius2-mod-mschap \
kmod-gpio-dev kmod-input-core kmod-input-gpio-buttons kmod-input-polldev kmod-leds-gpio \
kmod-usb-core kmod-usb2 kmod-scsi-core kmod-usb-storage kmod-fs-ext3 e2fsprogs block-extroot block-mount \
-ppp -ppp-mod-pppoe -kmod-ppp -kmod-pppoe -kmod-crc-ccitt 




#kmod-usb-core kmod-usb-ohci kmod-usb2 kmod-scsi-core kmod-usb-storage block-extroot \
#	crda iw kmod-b43 kmod-b43legacy kmod-cfg80211 kmod-mac80211 wireless-tools libnl-tiny \
#	libiptc libxtables kmod-ipt-conntrack kmod-ipt-core iptables-mod-conntrack iptables-mod-nat kmod-ipt-nat luci \
	


endef

define Profile/WRT160NLFF/Description
	Package set optimized for the WRT160NL
endef
$(eval $(call Profile,WRT160NLFF))
