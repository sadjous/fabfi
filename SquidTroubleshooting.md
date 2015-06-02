

# Introduction #
[Squid](http://www.squid-cache.org/) is a caching web proxy used to accelerate web traffic.

**NOTE: Due to the limitations of USB drives, Squid will probably provide little value on connections faster than 2Mbps when using a Flash drive or 10Mbps when using a USB hard drive.**

# Squid Configuration #

As of version 4.0.0, the squid configuration is only partially automated.  This is half because squid configs are very application-specific and partially because we haven't gotten around to it yet.  In any case, there are a few things that you'll have to edit manually.  All settings live in /etc/config/squid (previously this was /etc/squid/squid.conf so check there if you are using a less-than-current version)

Set the size of your cache in the config file:
```
cache_dir ufs /home/squid/cache 220000 16 256
```
replace 220000 with the size of your cache.  This value should 10-20% smaller than the size of the drive you're using to leave room for overhead and logging

set the size of the biggest object your cache will accept
```
maximum_object_size 500 MB
```
Larger values will result in higher bitwise hit rates and more bandwidth savings.  Smaller values will result in more speed increases at the expense of bandwidth savings.

for the full set of configuration options, [go here](http://www.visolve.com/squid/squid27/contents.php).

# Wiring and Troubleshooting #

Running squid transparently (no special settings needed for clients) requires both the proxy program and a firewall rule to direct traffic to the proxy.

From a troubleshooting perspective, the above is important because if squid turns off, all the web traffic is directed into a black hole.

A classic example of this manifesting itself is when a user can log in to the system, but the content of the splash page is missing and users cannot browse to web pages.

if squid is not running, first make sure your external drive is mounted by trying to enter the cache directory:
```
cd /home/squid
```
if this directory is not there (and you ran setup proerly), make sure your drive is inserted and reboot the device.  if this was the issue, squid should start automatically.

If the drive mounts but squid does not start try to start it at the command line with:
```
$ squid -D
```
then look to see if squid is running by running
```
ps
```
and looking for three processes:
```
squid -D
(squid -D)
(unlinkd)
```

Then check the log for squid error messages by running
```
logread
```
you shouldn't see any errors here unless you have config file issues.