#Freeradius Authentication, Authorization and Accounting

# Introduction #

This wiki assumes that you have a working freeradius setup. For instructions on installing freeradius, go [here ](http://code.google.com/p/fabfi/wiki/FabfiServer#Install_Freeradius).

Remote Authentication Dial-In User Service (RADIUS) is a networking protocol for for carrying authentication, authorization and accounting information between a Network Access Server (NAS) or Access Controller and a shared Accounting Server.

`CoovaChilli` is a software access controller ( RADIUS client ) installed in Fabfi Access points and is used in conjunction with Freeradius to restrict access and login users.

Fabfi uses `FreeRADIUS` though any other RADIUS server will work fine provided that it is configured correctly. Other opensource RADIUS servers include, [JRadius](http://coova.org/JRadius) , [BSDRadius](http://www.bsdradius.org/) and [FreeRADIUS.net](http://freeradius.net/) which is FreeRADIUS for Windows.

## HOW RADIUS WORKS ##

RADIUS uses the UDP protocol to communicate between the Network Access Server (`CoovaChilli`) and the RADIUS server.

#### Authentication ####

Authentication requests are listened to on port 1812. Here's a step-by-step summary of the Authentication process when using `CoovaChilli` and Freeradius

> User connects to the Access Point and attempts to browse to a webpage.

> `CoovaChilli` redirects user to login splash page where he enters Username and Password

> Chilli encrypts password with [CHAP](http://en.wikipedia.org/wiki/Challenge-Handshake_Authentication_Protocol)

> `CoovaChilli` sends username and encrypted password to the RADIUS server.

> RADIUS server responds with Access-Accept or Access-Reject together with some Reply Attributes.

> `CoovaChilli` client acts upon services and services parameters specified in the Reply Attributes bundled with Accept or Reject.

The Authentication Packet is a UDP packet that looks like

```
rad_recv: Access-Request packet from host 41.204.176.76 port 47577, id=198, length=237
        ChilliSpot-Version = "1.2.6"
        User-Name = "superuser"
        CHAP-Challenge = 0xa6e3460b11dcec2756fcc4b5355092bf
        CHAP-Password = 0x004c38f55956c8346ecb7de2cf43b700a1
        Service-Type = Login-User
        Acct-Session-Id = "4e37c4e500000007"
        Framed-IP-Address = 10.116.98.105
        NAS-Port-Type = Wireless-802.11
        NAS-Port = 7
        NAS-Port-Id = "000000UTHENTICATION07"
        Calling-Station-Id = "C4-17-FE-BC-DB-BB"
        Called-Station-Id = "00-15-6D-4C-43-E4"
        NAS-IP-Address = 10.116.98.1
        NAS-Identifier = "fabfi98"
        WISPr-Logoff-URL = "http://10.116.98.1:3990/logoff"
        Message-Authenticator = 0x253d5079d20da0b73a621158d5ea99e3
```

Where the  Calling-Station-Id is the MAC-address of the client computer,  Called-Station-Id is the MAC address of the access point.

The radius server acts on the information contained in this packet - and responds with an ACCESS-ACCEPT or ACCESS-REJECT message.


#### Accounting ####

When an authentication request is successful, the UAM server immediately sends an accounting session start packet

```
rad_recv: Accounting-Request packet from host 41.204.176.76 port 44120, id=14, length=163
        ChilliSpot-Version = "1.2.6"
        ChilliSpot-Attr-10 = 0x00000002
        Event-Timestamp = "Jan  1 1970 03:20:11 EAT"
        Acct-Status-Type = Start
        User-Name = "superuser"
        Acct-Session-Id = "4e37c62300000008"
        Framed-IP-Address = 10.116.98.106
        NAS-Port-Type = Wireless-802.11
        NAS-Port = 8
        NAS-Port-Id = "00000008"
        Calling-Station-Id = "00-1F-3C-21-20-D9"
        Called-Station-Id = "00-15-6D-4C-43-E4"
        NAS-IP-Address = 10.116.98.1
        NAS-Identifier = "fabfi98"
```

While the user's session is on, the UAM sends interim update packets - the length of time between interim update packets is 5 minutes, but this can be adjusted using the ChilliSpot-Interval reply attribute.  These interim update packets update the table `radacct` ( for SQL accounting ) with details such as session time, uploaded data, downloaded data etc.

```
rad_recv: Accounting-Request packet from host 41.204.176.76 port 44120, id=13, length=206
        ChilliSpot-Version = "1.2.6"
        ChilliSpot-Attr-10 = 0x00000002
        Event-Timestamp = "Jan  1 1970 03:18:07 EAT"
        Acct-Status-Type = Interim-Update
        User-Name = "superuser"
        Acct-Input-Octets = 743566
        Acct-Output-Octets = 207481
        Acct-Input-Gigawords = 0
        Acct-Output-Gigawords = 0
        Acct-Input-Packets = 1940
        Acct-Output-Packets = 2186
        Acct-Session-Time = 602
        Acct-Session-Id = "0000005a00000004"
        Framed-IP-Address = 10.116.98.102
        NAS-Port-Type = Wireless-802.11
        NAS-Port = 4
        NAS-Port-Id = "00000004"
        Calling-Station-Id = "00-23-4E-76-05-8C"
        Called-Station-Id = "00-15-6D-4C-43-E4"
        NAS-IP-Address = 10.116.98.1
        NAS-Identifier = "fabfi98"
```

When the user terminates his session, the "stop" packet is sent. This removes the user from the online clients list.

```
rad_recv: Accounting-Request packet from host 41.204.176.76 port 44120, id=18, length=215
        ChilliSpot-Version = "1.2.6"
        ChilliSpot-Attr-10 = 0x00000002
        Event-Timestamp = "Jan  1 1970 03:21:45 EAT"
        Acct-Status-Type = Stop
        User-Name = "superuser"
        Acct-Input-Octets = 253
        Acct-Output-Octets = 663
        Acct-Input-Gigawords = 0
        Acct-Output-Gigawords = 0
        Acct-Input-Packets = 4
        Acct-Output-Packets = 6
        Acct-Session-Time = 40
        Acct-Terminate-Cause = User-Request
        Acct-Session-Id = "4e37c4f800000007"
        Framed-IP-Address = 10.116.98.105
        NAS-Port-Type = Wireless-802.11
        NAS-Port = 7
        NAS-Port-Id = "00000007"
        Calling-Station-Id = "C4-17-FE-BC-DB-BB"
        Called-Station-Id = "00-15-6D-4C-43-E4"
        NAS-IP-Address = 10.116.98.1
        NAS-Identifier = "fabfi98"
```


## ATTRIBUTES ##

There are two general kinds of attributes : Check Attributes and Reply Attributes

check attributes are used in the authentication stage. e.g user-password is a check-attribute. The radius server sends an Access-Accept or Access-Reject based on the results of evaluating the check attributes.

Reply attributes are bundled with an Access-Accept or Access-Reject message. The reply attributes are acted upon by the NAS server. e.g ChilliSpot-Bandwidth-Max-Down is used by the NAS ( coova-chilli) to determine the download speed that a client computer gets.

Here's an example of an Access-Accept message bundled with reply attributes.

```
Sending Access-Accept of id 163 to 41.204.176.76 port 58832
        Idle-Timeout := 120
        ChilliSpot-Bandwidth-Max-Down := 1024
        ChilliSpot-Bandwidth-Max-Up := 512
        Session-Timeout := 1800

```

Attributes MUST be defined in a dictionary. If you define your own attributes, make sure you add them to a dictionary ( or make your own dictionary ) . For example, dictionary.fabfi looks like :

```
VENDOR          FabFi                   16559

BEGIN-VENDOR    Fabfi


ATTRIBUTE       Max-Daily-Data                  1       integer
ATTRIBUTE       Max-Total-Data                  2       integer
ATTRIBUTE       Max-Monthly-Data                3       integer

```

Where FabFi is the vendor name and 16559 is the vendor id ( self-set in this case ). No two vendors should have the same Id.

Below are some attributes frequently used by JoinAfrica

#### Check-Attributes ####

`Simultaneous-Use` - This is defined in dictionary.freeradius.internal . If set, no more than x users can login simultaneously on the same account, where x is an integer.


`Max-Daily-Session` - Defined in dictionary.freeradius.internal. Specifies the maximum time ( in seconds ) a user gets in a day.


`Max-Monthly-Session` - Defined in dictionary.freeradius.internal. Specifies the maximum time ( in seconds ) a user gets in a month.


`Max-All-Session` - Defined in dictionary.freeradius.internal. Specifies the maximum non-renewable time ( in seconds ) will ever get.


`Max-Daily-Data` - Defined in dictionary.fabfi Specifies the maximum data ( in bytes ) a user gets in a day.


`Max-Monthly-Data` - Defined in dictionary.fabfi Specifies the maximum data ( in bytes ) a user gets in a month.


`Max-Total-Data` - Defined in dictionary.fabfi Specifies the total data ( in bytes ) a user will ever get.

#### Reply-Attributes ####

`Idle-Timeout` - This attribute is defined in dictionary.rfc2865. If set, the NAS will automatically logout the user if the Idle time has expired. Set in seconds.


`Session-Timeout` - This attribute is defined in dictionary.rfc2865. It gives a user a fixed session time. If set, the user gets logged out when his session time expires. The session time is set in seconds.


`ChilliSpot-Bandwidth-Max-Down` - This is a vendor specific attribute defined in dictionary.Chillispot. It determines the maximum download speed a user will get. It is set in KiloBits/Second.


`ChilliSpot-Bandwidth-Max-Up` - This has also been defined in dictionary.Chillispot
It determines the maximum upload speed a user will get. It is set in KiloBits/Second.


`Reply-Message` - Sends back a message which is displayed on the splash page.

For the full list of attributes, see the links at the bottom of the page.

#### Operators & Assigning Values to Attributes ####

Attributes have a "type" e.g string, integer etc . The value assigned to an attribute must match its "type".

When setting an attribute for a user/group, an appropriate operator must be used to assign a value to the attribute. Below are the valid operators
(copied from [here](http://freeradius.org/radiusd/man/users.html) )
`Attribute = Value`
> Not allowed as a check item for RADIUS protocol attributes. It is allowed for server configuration attributes (Auth-Type, etc), and sets the value of on attribute, only if there is no other item of the same attribute.
> As a reply item, it means "add the item to the reply list, but only if there is no other item of the same attribute."

`Attribute := Value`
> Always matches as a check item, and replaces in the configuration items any attribute of the same name. If no attribute of that name appears in the request, then this attribute is added.
> As a reply item, it has an identical meaning, but for the reply items, instead of the request items.

`Attribute == Value`
> As a check item, it matches if the named attribute is present in the request, AND has the given value.
> Not allowed as a reply item.

`Attribute += Value`
> Always matches as a check item, and adds the current attribute with value to the list of configuration items.
> As a reply item, it has an identical meaning, but the attribute is added to the reply items.

`Attribute != Value`
> As a check item, matches if the given attribute is in the request, AND does not have the given value.
> Not allowed as a reply item.

`Attribute > Value`
> As a check item, it matches if the request contains an attribute with a value greater than the one given.
> Not allowed as a reply item.

`Attribute >= Value`
> As a check item, it matches if the request contains an attribute with a value greater than, or equal to the one given.
> Not allowed as a reply item.

`Attribute < Value`
> As a check item, it matches if the request contains an attribute with a value less than the one given.
> Not allowed as a reply item.

`Attribute <= Value`
> As a check item, it matches if the request contains an attribute with a value less than, or equal to the one given.
> Not allowed as a reply item.

`Attribute =~ Expression`
> As a check item, it matches if the request contains an attribute which matches the given regular expression. This operator may only be applied to string attributes.
> Not allowed as a reply item.

`Attribute !~ Expression`
> As a check item, it matches if the request contains an attribute which does not match the given regular expression. This operator may only be applied to string attributes.
> Not allowed as a reply item.

`Attribute =* Value`
> As a check item, it matches if the request contains the named attribute, no matter what the value is.
> Not allowed as a reply item.

`Attribute !* Value`
> As a check item, it matches if the request does not contain the named attribute, no matter what the value is.
> Not allowed as a reply item.


## USERS, GROUPS AND PROFILES ##

Attributes are added against a username. For example, if we were using text-based authentication, and had a user called superuser, we'd have this entry in our users file

```
superuser  Cleartext-Password := "superpassword"
       ChilliSpot-Bandwidth-Max-Down := 1024
       ChilliSpot-Bandwidth-Max-Up := 512
       Idle-Timeout := 300
       Max-Daily-Session := 3600

```

If we were using SQL authentication, the check attributes would be entered in the `radcheck` table and the Reply attributes would be entered in the `radreply` table.

If a you have a group of users for whom you want to set similar attributes and want to avoid the drudgery of setting attributes for all of them, simply add them to a group. The user/group mappings are entered in the table `radusergroup`.

The check and Reply attributes for a group are set in the tables `radgroupcheck` and `radgroupreply` respectively.

### Daloradius ###

Daloradius provides an easy to use web-based graphical user interface for managing users, groups, profiles and also viewing their accounting data, billing, graphing etc. Daloradius simply manipulates freeradius database tables. It also adds its own set of tables for extra functionality.

Fabfi recommends using daloradius to manage users, groups (profiles) and attributes.


## TO DO ##

**Realms**

**`PostAuth`**

**`CoovaChilli`**

**`IEEE802.1x`**

# Links & References #

DIAMETER is set to be the successor of RADIUS. More on that [here](http://en.wikipedia.org/wiki/Diameter_%28protocol%29)


http://en.wikipedia.org/wiki/RADIUS

http://coova.org/CoovaChilli/RADIUS

[Cisco: How Radius Works ](http://www.cisco.com/en/US/tech/tk59/technologies_tech_note09186a00800945cc.shtml)

[Radius Extensions RFC ](http://freeradius.org/rfc/rfc2869.html)

[Radius RFC ](http://www.ietf.org/rfc/rfc2865.txt)