

# Introduction #

Authentication Authorization and Accounting (AAA) services are provided on the system by a program called [Freeradius](http://freeradius.org/). This program runs on a cloud-based server and manages a database of users and settings.  We control many of these settings through a web interface called [daloradius](http://daloradius.com/).

When a node wants to authenticate a client, it makes a request to freeradius with the client's name and password.  Freeradius responds to the node with an accept or deny message and some settings for that user's session.

Without freradius running, nobody gets access.

# Configuration #

For information on configuring RADIUS with different user settings, see [UserAndGroupSettings](UserAndGroupSettings.md)

# Troubleshooting #

The best way to see what's going on with a client login is to open a terminal to the freradius machine and run freeradius in debug mode.  like so:

First see if freeradius process is running by running:
```
$ ps -A
```
and looking for a process called
```
freeradius
```
If freeradius isn't running that's probably your problem.  You can start it with
```
$ sudo /etc/init.d/freeradius start
```

If it is running but the client isn't getting logged in on the remote node, start debug mode:
```
$ sudo /etc/init.d/freeradius stop
$ sudo freeradius -X
```
This will cause the server to print status messages to the console.

With freeraius in debug mode, you can try to log in your client and watch the debug messages to determine the issue.

When you're done kill the running freeradius by hitting `ctrl` and `c` at the same time, then restart the normal way with the start command shown earlier.