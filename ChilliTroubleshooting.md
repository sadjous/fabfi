

# Introduction #

[Chilli](http://coova.org/CoovaChilli) is the program that provides the captive portal for client logins to the system.  To start it requires a connection to the [RADIUS server](http://freeradius.org/).

If you're having trouble with client logins, it's likely a chilli problem.  Follow the troubleshooting procedure to figure out what's wrong.

# Troubleshooting procedure #
Perform each test and follow the instructions based on the results.

Most tests will require you to log in with ssh to the router that should be running chilli.  Go back to [the commands section](TroubleShooting#Useful_Commands.md) in you need more info on SSH.

## Check if Chilli is Running ##
Log into the offending device and run
```
$ ps
```
Check for a line that includes this
```
/usr/sbin/chilli
```
If you see it, chilli is running and you can [continue to the next section](#Check_for_Chilli_Complaints_in_the_Log.md).  If, not try to start it with:
```
$ /etc/init.d/chilli start
```
If you get any errors about the config file, edit the configuration in
```
/etc/config/chilli
```
according the the instructions [here](HeadnodeConfiguration.md) until chilli starts, then continue to the next section below.

## Check for Chilli Complaints in the Log ##

If chilli is already running, run:
```
logread
```
and look for messages related to chilli.  It's likely that you'll see an error about not being able to connect to the radius server.  if you see this message, do each of the checks in the next section.

## Verify Net Connection and Critical Services ##

After each of these checks, restart chilli with
```
/etc/init.d/chilli restart
```
then try to reassociate to the JoinAfrica wireless and browse to a web page to log in.

  1. [Check your network connection](NetworkTroubleshooting.md)
  1. [Test the RADIUS server](RadiusTroubleshooting.md)
  1. [Check that Squid is functioning](SquidTroubleshooting.md)

If all these tests succeed you should be online.
