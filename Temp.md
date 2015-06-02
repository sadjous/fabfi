## TEMP: Configuration needs for Live map ##

The live map script requires that every node have a name an a correct set of GPS coords.  Coords are currently listed directly in
```
/etc/fabfi-scripts/fabfimap.sh
```
and need to be written in the same format in /www/mygooglemapscoords.txt, which must be web available.  This should be automated...

The server grabs txtinfo data on port 2006.

## TEMP: squid setup ##


ENABLE USB STORAGE

We will format the USB Stick to ext3

Make sure that you have the following installed:
kmod-usb2, kmod-fs-ext3, block-extroot , block-hotplug , fdisk

The easy way to format the USB stick is from a Ubuntu-Linux computer.
Plugin the disk--> Go to administration--> Disk utilities  --> {your usb stick (sdb/sdc/...}
Unmount any open file systems on the usb stick - Click on unmount (or run umount /mount-point on terminal) - Do not use gnome to unmount the disk
Click format disk - Choose "Master Boot Record" as the partitioning method - this is for compatibility with fdisk GUID partition map may not work

Once the disk is formated, create an ext3 partition on the empty space.
Unmount and safely remove the disk

Plug the disk into the router and log in to the router
run dmesg - confirm if disk was detected.
Alternatively, run fdisk -l and check for /dev/sda

If you successfully formated the disk, you should see /dev/sda1 as well
Assuming /dev/sda1 exists (if not, reformat the disk using fdisk /dev/sda , then make a partition using mkfs.ext3)

make a directory that shall be used as the mount point for the disk - e.g mkdir /home
Edit /etc/config/fstab

Add :
```
	config mount      
        	option target   /home 
        	option device   /dev/sda1
        	option fstype   ext3 
        	option options  rw,sync 
        	option enabled 1    
        	option enabled_fsck 1
```

Also, make sure the "config global automount" has anon\_mount set to 1

```
	config global automount 
        	option from_fstab 1   
        	option anon_mount 1
```

reboot the router. Confirm if the disk got mounted automatically

Change permissions on the disk
```
chmod 777 /home -R 
```
CONFIGURE SQUID
```
opkg update
opkg install squid
```
Open /etc/squid/squid.conf
To add the USB stick as a caching directory, add the line:
```
	cache_dir ufs /home 100 16 256
```
preferrably after the commented line #cache\_dir ufs /var/cache

run squid -z to add update cache directories

To set squid for transparent proxying:
Replace the line
```
	http_port 3128
```
> with
```
	http_port 10.100.0.200:3128 transparent
```
where 10.100.0.200 is the lan address of your router.

Add the ACL rule
```
	always_direct allow all
```
after the "#  TAG: always\_direct" section of the documentation.

A full sample squid.conf without the comments is shown below
```
	http_port 3128 transparent
	hierarchy_stoplist cgi-bin ?
	acl QUERY urlpath_regex cgi-bin \?
	cache deny QUERY
	acl apache rep_header Server ^Apache
	access_log /var/log/squid/access.log squid
	hosts_file /etc/hosts
	refresh_pattern ^ftp: 1440 20% 10080
	refresh_pattern ^gopher: 1440 0% 1440
	refresh_pattern . 0 20% 4320

	# newer Squid's don't need "all", it's built in:
	acl all src 0.0.0.0/0.0.0.0

	# 1000MB max cache size (default is 100MB):
	cache_dir ufs /home 1000 16 256

	acl manager proto cache_object
	acl localhost src 127.0.0.1/255.255.255.255
	acl to_localhost dst 127.0.0.0/8
	acl SSL_ports port 443 563 # https, snews
	acl SSL_ports port 873 # rsync
	acl Safe_ports port 80 # http
	acl Safe_ports port 21 # ftp
	acl Safe_ports port 443 563 # https, snews
	acl Safe_ports port 70 # gopher
	acl Safe_ports port 210 # wais
	acl Safe_ports port 1025-65535 # unregistered ports
	acl Safe_ports port 280 # http-mgmt
	acl Safe_ports port 488 # gss-http
	acl Safe_ports port 591 # filemaker
	acl Safe_ports port 777 # multiling http
	acl Safe_ports port 631 # cups
	acl Safe_ports port 873 # rsync
	acl Safe_ports port 901 # SWAT
	acl purge method PURGE
	acl CONNECT method CONNECT
	http_access allow manager localhost
	http_access deny manager
	http_access allow purge localhost
	http_access deny purge
	http_access deny !Safe_ports
	http_access deny CONNECT !SSL_ports
	http_access allow localhost
	acl lan src 10.0.0.0/8
	http_access allow localhost
	http_access allow lan
	http_access deny all
	http_reply_access allow all
	icp_access allow all
	visible_hostname fabfi.headnode
	always_direct allow all
	coredump_dir /home
```


FIREWALL CONFIGS

In the example firewall rules below, eth0 is your LAN (switch) port and eth1 is the WAN (internet) port.
```
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 \
        -j REDIRECT --to-port 3128
iptables -A INPUT -j ACCEPT -m state \
        --state NEW,ESTABLISHED,RELATED -i eth0 -p tcp \
        --dport 3128
iptables -A OUTPUT -j ACCEPT -m state \
        --state NEW,ESTABLISHED,RELATED -o eth1 -p tcp \
        --dport 80
iptables -A INPUT -j ACCEPT -m state \
        --state ESTABLISHED,RELATED -i eth1 -p tcp \
        --sport 80
iptables -A OUTPUT -j ACCEPT -m state \
        --state ESTABLISHED,RELATED -o eth0 -p tcp \
        --sport 80
```
REFERENCES:	OpenWRT USB Storage
```
		http://wiki.openwrt.org/inbox/howto/configure-external-storage-overlay?s[]=table&s[]=hardware
```
> Squid
```
		http://www.linuxhomenetworking.com/wiki/index.php/Quick_HOWTO_:_Ch32_:_Controlling_Web_Access_with_Squid
		http://www.lesismore.co.za/squid3.html
		http://www.deckle.co.za/squid-users-guide/Transparent_Caching/Proxy
```