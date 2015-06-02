

# Introduction #

This is the troubleshooting page.  Come here for help with solving network problems.  Before reaching out to others for help, you should do the following:
  1. Read and understand the [Required Signaling](SystemArchitecture#Required_Signaling.md).  The Required Signaling page has lots of links to term definitions and generally gives the overview of how things are glued together.
  1. Know how to use [Basic Linux Commands](#Useful_Commands.md)
  1. Work through the [troubleshooting procedures](#Troubleshooting_Procedures.md) at the end of this page.

# Useful Commands #

For even more useful commands check out DiagnosticTools

Log into a device
```
$ ssh root@<ip of device>

example: ssh root@10.100.0.49
```
To do the above, you will need a terminal client that supports SSH. in Linux or MacOS, the native terminal will work.  In windows, you should use [PuTTY](http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe).

View a file
```
$ cat <filename>
```

Edit a file
```
$ vi <filename>
```
> for more info on vi go [here](http://www.cs.fsu.edu/general/vimanual.html)

See what other olsr devices a node has as a neighbor
```
$ echo '/links' nc | localhost 2006
```

Reboot a device
```
$ reboot && exit
```

Check connectivity with another device
```
$ ping <ip address>

example: ping 8.8.8.8
```

Check DNS and connectivity
```
$ ping <url>

example: ping google.com
```

List running processes
```
$ ps
```

Test the download of a web page
```
$ wget -s http://<your url here>
```

View the associated devices on the wireless link
```
$ iw dev <physical interface name, usually wlan0> station dump
```

Reset wireless interfaces
```
$ wifi
```

## Operators ##

Pipe:
```
<command> | <other command>
```
> Takes the output of the first command and sends it to the input of the next

Double Ampersand:
```
<command> && <other command>
```
> executes the first command and then the second if the first is successful

[Complete Bash reference guide](http://www.gnu.org/software/bash/manual/bashref.html) Note: OpenWRT does  not use a complete/standard bash, so expect only basic things to work.

## Advanced commands and Scripts ##

Repeatedly measure the receive signal of a wireless neighbor for signal peaking:
```
$ while true; do iw dev wlan0 station get "<MAC Address from above>" | grep "signal"; sleep 1; clear; done;
```
When you've got the best signal, stop the program above by hitting the ctrl and c keys at the same time.

Pull the timestamps for the last day+ (will be more if you had downtime) of "phone home" messages from a default apache log for a particular node at a particular IP.  This is a quick hack to see uptime downtime
```
cat /var/log/apache2/access.log | grep "<your IP>" | grep "=<node number>%20" | \
cut -c20-39 | sed 's,\(.*\)/\(.*\)/2011:,\2/\1/2011 ,' | \
sed 's/Jan/01/' | sed 's/Feb/02/' | sed 's/Mar/03/' | sed 's/Apr/04/' | \ 
sed 's/May/05/' | sed 's/Jun/06/' | sed 's/Jul/07/' | sed 's/Aug/08/' | \ 
sed 's/Sep/09/' | sed 's/Oct/10/' | sed 's/Nov/11/' | sed 's/Dec/12/' | \ 
tail -1440
```
Note: change the "cut" numbers based on IP address length.  20-39 works for an IP that's xx.xxx.xx.xxx

Pull the timestamps for the last day+ (will be more if you had downtime) of "phone home" messages from our custom-configured apache log for a particular node at a particular IP.  This is a quick hack to see uptime downtime
```
cat /var/log/apache2/access.log | grep "<your IP>" | grep "=<node number>%20" | \
cut -c19-38 | tail -1440
```
Note: change the "cut" numbers based on IP address length.  20-39 works for an IP that's xx.xxx.xx.xxx.  This gives output with the date and time in two different columns.

# Troubleshooting Procedures #

_"The internet is broken"_ is not a bug report!

Good troubleshooting should be a purely mechanical process of comparing _expected_ structure and behavior to _observed_ structure and behavior.  When you find the place where expected and observed are not the same, you've either found what's broken or you've discovered a bug.  Either way you're closer to a solution.

Your skill at debugging is directly proportional to how well you know the details of the [System Architecture](SystemArchitecture.md) and communication protocols.  The more detail you know, the more precisely you can isolate a problem.  Do your homework, and your life will be much improved!

With that said, on to the details...

**The troubleshooting guide is organized as a Question and Answer session with links out to specific troubleshooting procedures based on your answers. To use the guide, start answering questions as if you were the client having a problem and follow your answers to the specific troubleshooting steps**

Have a procedure that's not on the wiki?  [Email it to us](mailto:&#102;&#097;&#098;&#102;&#105;&#064;&#102;&#097;&#098;&#102;&#111;&#108;&#107;&#046;&#099;&#111;&#109;)

## Basic Troubleshooting Start here ##

The section is written from the client perspective and assumes less less access to the system than advanced troubleshooting.  Answering these questions will help you find the correct section in the advanced troubleshooting section and/or provide more information to a network operator who is trying to help you.

Answer each of the questions below.  If you answer "yes", move on to the next question.  If you answer "No", click on the link.

**Before beginning the questions, disconnect your wireless connection and try to reconnect from scratch.**

  1. On your computer, can you see the "`JoinAfrica <#>`" wireless network? [No](#Power_Off.md)
  1. Can you connect to the "`JoinAfrica <#>`" without any wireless errors? [No](#Chilli_Down.md)
  1. Can you see the content in the center of the splash page (without error)? [No](#No_Master_via_HTTP.md)
  1. Can you see the login fields on the splash page? [No](#HTTP_Layering_Error.md)
  1. Can you click on the links in the main section of the splash page? [No](#HTTP_Layering_Error.md)
  1. When you enter your username and password, do you get a response other than the "loading" icon? [No](#No_Radius_Response.md)
  1. Does the response you receive say you are "logged in"? [No](#Login_Errors.md)

If you've answered "Yes" to all the above, you should be online. If you're not, contact your local representative for more help.

## Advanced Troubleshooting Start Here ##

Which of the following statements best describe the issue you're trying to solve?

  * I'm having trouble powering a device
  * My node is having connection problems with other nodes or the internet
  * The Chilli captive portal is not working properly
  * The Squid proxy is not functioning properly

## Conclusions ##

This section consists of landing answers from the Basic and Advanced troubleshooting sections.  It is not mean to be read out of context.

### Power Off ###

Is the wireless device on your computer enabled/powered up?  If not, enable it and start over.

If your computer's wireless is on, your symptoms suggest the wireless node that serves you is powered off.  Verify this is true by checking that there is at least one LED lit solidly on the node.  If all the LEDs on your device are off, check that all the cables are plugged in and mains power is on.  For devices with a UPS, make sure the power button for the UPS is in the "on" position (the UPS should have a power LED as well).  If you're not sure about the mains, check with a multimeter or a device you know works.

For more information on device power, [click here](PoweringDevices.md).

### Chilli Down ###

Your symptoms suggest that chilli, the program that provides the [captive portal](http://en.wikipedia.org/wiki/Captive_portal), is not running.  The most likely reason for this is the chilli program cannot connect to the RADIUS server.  Contact someone with administrative access to the network and direct them to [ChilliTroubleshooting](ChilliTroubleshooting.md)

### No Master via HTTP ###

Your symptoms suggest that you cannot make HTTP requests to master.mesh over http.

Open a terminal window (linux) or the command prompt (windows) and run
```
$ ping master.mesh
```
If you don't get something that looks roughly like this:
```
$ ping master.mesh
PING master.mesh (18.181.3.77): 56 data bytes
64 bytes from 18.181.3.77: seq=0 ttl=51 time=276.607 ms
64 bytes from 18.181.3.77: seq=1 ttl=51 time=272.640 ms
64 bytes from 18.181.3.77: seq=2 ttl=51 time=273.117 ms
```
[Click Here](NetworkTroubleshooting.md)

Otherwise, it is likely the [squid](http://www.squid-cache.org/) proxy located on the network headnode has shut down. Contact someone with administrative access to the network and direct them to [SquidTroubleshooting](SquidTroubleshooting.md)

### HTTP Layering Error ###

Some web browsers don't display web pages properly according to published standards.  You have one of them.

We'd like to know what browser you have so we can support all browsers.  Go to the menu of your browser and select:
```
Help > About
```
Note the name and version number, then contact your local support person and explain what you see.

In the meantime, you won't have any problems if you [browse with Firefox](http://www.mozilla.com/en-US/firefox/).

### No Radius Response ###

Our accounting server is not logging you in, but it's not telling you why.  (reminder for developers: this is the symptom we saw when we originally implemented single-login-per-user but had yet to configure a radius response to tell a user he/she was logged in already)

to figure out why, contact an administrator and direct them to [RadiusTroubleshooting](RadiusTroubleshooting.md)

### Login Errors ###

If you're here, you're seeing a specific error when you try to log in.  The most common problem for failed logins is captialization

YoUR usERnaMe is CASE SENSITIVE.

if you can't figure out how to log in, contact your local representative and tell them the error you see.