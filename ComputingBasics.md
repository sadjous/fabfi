

# Introduction #

This page contains instructions for performing useful basic operations on your computer.  It is almost entirely linux (specifically ubuntu 10.04) focused.  If you don't have linux, run it from a LiveCD and make your life easier.  Windows is not designed to do what we do well.  You're better than Windows.


# The terminal #

In Linux, the terminal window (the Linux analog of the windows "command prompt") is your friend.  In Ubuntu 10.04, go to **Programs > Accessories > Terminal** to find it.

The terminal windows lets you directly type commands for your computer to execute or log onto a remoted computer and run commands on it from your desktop.  In general, commands take the following shape:
```
$ command -option argument
```
`$` simply illustrates the prompt at the beginning of the line where you type in the terminal.  every command will have a name, which comes first.  Some commeands we use frequently are:
```
ping
ps
cat
vi
echo
free
route
ls
```

sometimes you can use a command with nothing after it.
```
$ route
```
for instance, prints the contents of your computer's routing table.

Other programs require that some more information be added after the command
```
$ echo "hello"
```
prints "hello" to the terminal

finally, some programs require configuration options
```
$ tar -czf archive.tar.gz etc/
```
compresses the contents of the `etc/` directory into a file called `archive.tar.gz` while
```
$ tar -xzf archive.tar.gz etc/
```
extracts the contents of the file `archive.tar.gz` back into the current directory.

For examples of useful commands to know when working with Fabfi, [click here](TroubleShooting#Useful_Commands.md).

# Network Settings #

## Configure a Static IP ##
  1. Go to **System tab-> Preferences-> Network Connections**:
  1. Select the Wired option-> Add (you may rename this "connection")
  1. Select **ipv4** and set method to **Manual**
  1. Under **Address** put say **192.168.1.254**
  1. Under **Netmask** put **255.255.255.0**
  1. Under **Gateway** put **192.168.1.1** and press **Enter**
  1. (optional) Click the **routes** button and in the resulting dialog, check the box for **Use this connection only for resources on its network**
    * Checking this box will allow you to be connected to a router on the wired link and browse the internet with your wireless connection at the same time.
  1. Apply the changes.

# System Administration Principals, Obtaining Software and Support #

Linux system management is significantly different, and simpler, than the management of the desktop systems that most people are used to.

The people who have put together your Linux Distribution have gone to a lot of work to obtain a large collection of software, large enough to contain all the software you should need, _AND_ make sure that it all works together. (Fabfi uses Ubuntu Linux for it's server and distributes it's own Linux for the nodes.)

The In general, typical user should therefore obtain ''''all'''' his or her software from their Linux distributor. (This software collection is known as a 'Linux distro".)

Experts who are willing and able to diagnose and solve one-of-a-kind problems may wish to obtain some software directly from the project or company that developed it, but those who take this path must also be willing and able to provide their own support. This is particularly burdensome given that such self-supported software must be continually monitored for security vulnerabilities and must have security patches applied in a timely fashion.

Linux distributors have security teams that release fixes in a timely manner so those that use the Linux distro can easily keep their systems secure. Administrators who install non-distro 3rd-party software, especially drivers that closely integrate with other system components, must also themselves ensure that the 3rd-party software continues to operate as the Linux distribution releases security patches. Having a single supplier for all your software greatly simplifies system administration.

Because a Linux distro's software is designed to work as a unit it is always best to obtain support directly from the Linux distribution's official channels, be that the documentation supplied in man pages, in info pages, in written reference guides, or support provided by official mailing lists and their archives, by official web forums, by official irc channels, etc. (Ubuntu software packages may also contain a

`/usr/share/doc/<packagename>/README.Debian.gz`

file that describe how the operation of the Ubuntu version of the package differs from that of a stock installation.)

It is worth remembering that as a rule the people who provide support are volunteers and appreciate at least an attempt at reading whatever written instructions exist before asking for help. Because everyone using your Linux distro is using the same software combination it is likely that someone has already encountered your problem. (Obviously this will not be true if you have installed software from a 3rd party.)

As a fallback it can be good to seek support directly from the authors of the software, the project team or company that produced the software, via their official documentation and support channels. Only as a last resort should the web be searched for the advice of random strangers.

Finally, if you choose to configure your system using textual configuration files you will have the opportunity to leave yourself written notes as to what changes you've made and, most importantly, why you made them. Such notes can be invaluable help at a later date.