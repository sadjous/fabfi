# Introduction #

The content server as set up in Lima, Peru currently runs on Ubuntu 11.04. This will probably change in the near future. For now, the installation instructions below relate to the Ubuntu server.

# Installation on Ubuntu 11.04 #

You will need these config files: [content-server-config-20110821.tgz](http://fabfi.googlecode.com/files/content-server-config-20110821.tgz)

## Update packages ##

```
apt-get update
apt-get upgrade
```

## Additional packages ##

```
apt-get install openssh-server
```

## Network ##

Replace /etc/network/interfaces

Make sure the IP addresses in it are what you want. The IP of the server will be static and referenced explicitly by the T-node with which the server is associated.

Replace /etc/resolv.conf

```
/etc/init.d/network-manager stop
/etc/init.d/networking restart
```

**Explanation:** The transparent proxy server is set up to live inside the mesh network. The T-node with which the server is associated forwards its port 80 traffic to port 3128 on the server. This requires a forwarding rule on the T-node. For example, if the server is at 10.0.90.5:

```
iptables -t nat -A PREROUTING -p tcp -s ! 10.0.90.5 -d ! 10.0.0.0/8 --dport 80 -j DNAT --to 10.0.90.5:3128
```

Note that any port 80 traffic originating from the server does not get routed back to the server, but through the uplink.

## Squid ##
(and the Calamaris log analyzer)

```
apt-get install squid3 calamaris
```

Replace /etc/squid3/squid.conf and set the IP range (find "acl localnet src") from which the squid server should accept requests.

I haven't been able to figure out how to do this otherwise, but you need to reboot the computer. Otherwise you get a message along the lines of "access denied, contact your sysadmin" whenever you try to load a web page via the proxy. Restarting the squid server didn't seem to help.

## LAMP ##

This is optional at this stage, but I installed Apache2, MySQL, PHP5 to host and test a simple user-generated content site on the server.

```
apt-get install tasksel
tasksel install lamp-server
service apache2 restart
```