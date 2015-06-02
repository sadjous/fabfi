# Introduction #

SNMP stands for Simple Network Management Protocol and is an Internet standard protocol for managing devices on IP networks.

The SNMP architecture consists of 3 major components

**SNMP Agent** - This is software that resides in the device that is to be monitored ( for example, snmpd - the SNMP server daemon ). SNMP Agents provide information to managers.

**SNMP Manager** - This is software responsible for retrieving/setting data on network devices that run an SNMP agent software. For example, the snmp client.

**Management Information Base** - MiBs are files that describe the structure of the management data of a device subsystem and use a hierarchical namespace containing Object Identifiers (OiDs). In other words, an MiB is a collection of OiDs.
Each OiD identifies a variable that can be read or set via SNMP.

The SNMP manager and SNMP agent use an SNMP Management Information Base ( MiB ) and a set of commands to exchange information.


SNMP can be used to monitor information such as:

Networking information - This includes data such as interface information

There are 5 basic SNMP commands:

**GET** - Retrieve OID data from a device

**GETNEXT** - Retrieve the next OID from the device

**SET** - Used to set configuration data on an OID ( if allowed )


**TRAP** - A network node can send a notification to the management station

**INFORM** - An acknowledged trap (network nodes can try and send it again if no acknowledgement is received)


# Some SNMP Commands and examples #

**snmpwalk** - Used to display all OiDs and their corresponding values at once.

e.g To view all OIDs of a device whose IP address is 192.168.1.1

`snmpwalk -v 2c public -c public 192.168.1.1`

snmpwalk can also be used to view just a single 'branch' of the MiB tree

e.g To display MiB  iso.3.6.1.2.1.31.1.1.1

`snmpwalk -v2c -c public 41.204.176.76 iso.3.6.1.2.1.31.1.1.1`

where

-v is the snmp version ( 2c in this example )

-c is community ( public in this example ) - The snmp community string is like a password and is used to restrict access to reading or writing snmp data.

**snmpget** - Used to retrieve the value of a specific OID

e.g.

`snmpget -v 2c -c public 192.168.1.1 iso.3.6.1.2.1.31.1.1.1.16.9`

Where iso.3.6.1.2.1.31.1.1.1.16.9 is the OID whose value we want to retrieve..

**snmpgetnext** - This is used to retrieve the "next" valid OiD.

e.g

`snmpgetnext -v2c -c public 41.204.176.76 iso.3.6.1.2.1.31.1.1.1.16.1`

will return the value for OiD iso.3.6.1.2.1.31.1.1.1.16.2 ( if it exists )

**snmpset** - This is used to set the value of an OID ( if the host device allows )


## SNMP IPv6 ##

For SNMP version 1 and 2c, the community must be specified as rocommunity6 or rwcommunity6

The syntax for entering ipv6 addresses `ipv6:[2001:470:af08:bfa::4]` or `udp6:[2001:470:af08:bfa::4]`

To specify the SNMP agent port number ( 161 in this case ) - `ipv6:[2001:470:af08:bfa::4]:161`

References

http://en.wikipedia.org/wiki/Simple_Network_Management_Protocol

http://www.net-snmp.org/wiki/index.php/Tutorials