# Introduction #

PortalGun is the fabfi mesh network access controller.


## Bump OpenWRT iptables to 1.4.12.1 ##

The standard iptables in OpenWRT backfire & trunk does not include support for the tproxy modules we need to redirect client requests to the portal splash page or transparent proxy.

  * Edit: package/iptables/Makefile
```
  #PKG_VERSION:=1.4.10
  PKG_VERSION:=1.4.12.1

  #PKG_MD5SUM:=f382fe693f0b59d87bd47bea65eca198
  PKG_MD5SUM:=b08a1195ec2c1ebeaf072db3c55fdf43
```

  * Run:   TODO update patches for 1.4.12.1
```
  rm package/iptables/patches/010-multiport-linux-2.4-compat.patch
  rm package/iptables/patches/011-recent-add-reap.patch
  rm package/iptables/patches/020-iptables-disable-modprobe.patch
  rm package/iptables/patches/100-bash-location.patch
  rm package/iptables/patches/200-configurable_builtin.patch
```

  * You may also need to edit packages/iptables/Makefile
> Comment out these lines
```
     #(cd $(PKG_INSTALL_DIR)/usr/lib/iptables ; \
     #       $(CP) libip6t_*.so $(1)/usr/lib/iptables/ \
     #)
```


## Package Compilation ##

  * Edit: feeds.conf.default
```
  src-svn fabfi http://fabfi.googlecode.com/svn/trunk/openwrt/package-scripts
  src-svn afrimesh http://afrimesh.googlecode.com/svn/trunk/package-scripts/openwrt
```

  * Run:
```
  ./scripts/feeds update fabfi afrimesh
  ./scripts/feeds/install portalgun

  make menuconfig

      Network -> Captive Portals -> portalgun 

  make
```


## Installation ##

  * Run on head node:
```
  opkg install portalgun
  /etc/init.d/lucid enable
  /etc/init.d/haproxy enable
```


  * Edit on head node: /etc/haproxy.cfg
```
  # Global parameters
  global
        maxconn 32000
        ulimit-n 65535
        uid 0
        gid 0
        daemon
        #debug
        #nbproc 2

  defaults
        log /dev/log daemon 
        mode    http
        contimeout      4000
        clitimeout      42000
        srvtimeout      43000
        balance roundrobin
        stats enable                    
        stats uri /stats                
        #stats realm HA_Stats           
        #stats auth username:password   

  listen transparent_proxy                          
        bind 2001:470:8c0e:fab::1:3128 transparent  # mesh interface IPv6 address
        mode http                                 
        option forwardfor                         
        option http-use-proxy-header              
        server proxy01 192.168.20.77:3128  # squid server IPv4 (no haproxy support yet for server IPv6)
                                                                                
  listen freebeer_proxy                             
        bind 2001:470:8c0e:fab::1:3129 transparent  # mesh interface IPv6 address
        mode http                                 
        option forwardfor                         
        option http-use-proxy-header              
        server proxy02 192.168.20.77:3129  # squid server IPv4 (no haproxy support yet for server IPv6)         
                                                                                
  listen portalgun_splash                           
        bind 2001:470:8c0e:fab::1:3130 transparent  # mesh interface IPv6 address
        mode http                                 
        option forwardfor                         
        reqadd Foo-Header:\ plonk                     
        server splash01 127.0.0.1:8001            
```


## Firewall & Routing Configuration ##

The portalgun access controller provides for two client access scenarios:

  1. A splashpage presented on first access allowing for free access, paid access via username/password, new account creation and account administration.
  1. Transparent access using dot1x and a provisioned certificate or username/password.

### splashpage & transparent proxy ###

All outgoing HTTP traffic on the network is transparently redirected by the HAProxy load balancer to either the splashpage after the client has connected or a squid proxy once the client is logged in.

HAProxy configuration has already been covered but before HAProxy can receive requests it is necessary to add routing entries to the head node as follows:

```
  ip -6 rule add fwmark 0xfab lookup 0xf1  # portalgun_splash
  ip -6 rule add fwmark 0xfac lookup 0xf2  # freebeer_proxy
  ip -6 rule add fwmark 0xfac lookup 0xf3  # transparent_proxy
  ip -6 -f inet6 route add local ::0/0 dev wlan1 table 0xf1
  ip -6 -f inet6 route add local ::0/0 dev wlan1 table 0xf2
  ip -6 -f inet6 route add local ::0/0 dev wlan1 table 0xf3

  # send everyone to portalgun_splash
  ip6tables -t mangle -I PREROUTING -i wlan1 -p tcp --dport 80 \
      -j TPROXY --tproxy-mark 0xfab/0xFFFFFFFF \
      --on-ip 2001:470:8c0e:fab::1 --on-port 3130

  # send a host to transparent_proxy
  ip6tables -t mangle -I PREROUTING -i wlan1 -p tcp --dport 80 \
      -s 2001:470:8c0e:fab:30e1:14e5:e6a4:13a \
      -j TPROXY --tproxy-mark 0xfac/0xFFFFFFFF \
      --on-ip 2001:470:8c0e:fab::1 --on-port 3128

  # send a host to freebeer_proxy
  ip6tables -t mangle -I PREROUTING -i wlan1 -p tcp --dport 80 \
      -s 2001:470:8c0e:fab:1e4b:d6ff:fe80:dada \
      -j TPROXY --tproxy-mark 0xfac/0xFFFFFFFF \
      --on-ip 2001:470:8c0e:fab::1 --on-port 3129
```


### dot1x ###

Portalgun controls dot1x access to the mesh gateway via rules in the FORWARD table.

The basic configuration goes something like this:

```
  # flush 'em all
  ip6tables -F
  ip6tables -X PORTALGUN

  # block gateway access to mesh clients but leave icmp6 & dns open
  ip6tables -I FORWARD -s 2001:470:8c0e:fab::/64 -o tun0 -j REJECT
  ip6tables -I FORWARD -o tun0 -p icmpv6 -j ACCEPT -m comment --comment "public icmpv6"
  ip6tables -I FORWARD -o tun0 -p udp --dport 53 -j ACCEPT -m comment --comment "public dns"

  # the portalgun chain
  ip6tables -N PORTALGUN
  ip6tables -I FORWARD -o tun0 -j PORTALGUN

  # allow mesh fabric access to gateway
  ip6tables -N MESHFABRIC
  ip6tables -I FORWARD -o tun0 -j MESHFABRIC
  ip6tables -I MESHFABRIC -s 2001:470:8c0e:fab::1 -j ACCEPT -m comment --comment "G"
  ip6tables -I MESHFABRIC -s 2001:470:8c0e:fab:218:aff:fe01:102c -j ACCEPT -m comment --comment "A"
  ip6tables -I MESHFABRIC -s 2001:470:8c0e:fab:218:aff:fe01:107d -j ACCEPT -m comment --comment "C"

  # allow a host access to gateway
  ip6tables -I PORTALGUN -j ACCEPT -m mac --mac-source 1c:4b:d6:80:da:da

  # remove host access to gateway
  ip6tables -D PORTALGUN -j ACCEPT -m mac --mac-source 1c:4b:d6:80:da:da
```



## Testing ##

  * Run on head node:
```
  tail -f /var/log/villagebus.log
```


## Hacking ##