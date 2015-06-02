# SNMP V3 #

Please read [Introduction to SNMP](IntroductionToSNMP.md) first. This tutorial is based on netSnmp on openWrt, but may also be used by other net-snmp users - the location of certain config files may be different though.

## Improved security ##

This is the most important reason for choosing SNMPv3 - the community strings for SNMP 1 and 2c don't provide sufficient security

The "password" is no longer sent in plain text but is encrypted in SHA or MD5 .
The SNMP data is either encrypted in DES or AES.  TLS or SSl for SNMP versions > 5.5

There are several models for security, only 1 will be considered here :

**USM** ( User Security Model )

The others are SNMPv3 over SSH, SNMPv3 with TLS or DTLS, and SNMPv3 with Kerberos ( which we'll upgrade to soon ).

For access restrictions, one would use :

**VACM** ( View Access Control Model )

Documentation ( complete with colourful pictures ) of these two models are provided in the links at the bottom of this page

In this tutorial, we'll cover the easier to configure of the two : USM, and perharps touch a little of VACM . First, the general stuff

### Security Levels ###

**auth** - refers to authentication ( username + password )
**priv** - refers to encryption ( passphrase )

Security levels can be specified as:

**NoauthNopriv** -  authentication neither takes place nor does encryption of SNMP data. -lowest level of security possible

**authNopriv** - Authentication of the user takes place but SNMP data isn't encrypted.

**authPriv** - The highest level of security ( and definitely my favourite )

You can also define the security level simply as "auth" or "priv" - that is if you're not really concerned about the other.



### Views ###

By defining views, one can specify which OiD's a user is allowed to see ( or the ones the user isn't allowed to see )

views are defined as

`view viewname type oid [MASK]` - Mask is optional

Type -this defines whether the OiD's specified are viewable or not and is thus defined as `included` or `excluded`

for example

`view myview included .1 `

`view hiddenview exclude iso.3.6.1.2.1.25`

MASK defines which sub-OiDs belonging to the given OiD to match - if not specified, then all OiD's in the OiD tree are matched. A mask is specified with a 0x in front of the bits to match e.g

`view myviewname included .1 0xf0 # this will`

## CreateUser ##

When creating a user, bear in mind the security levels you want to assign to the user, i.e there's no point of creating a user with a password
then setting 'noauth' as the security level

First stop all running instances of snmpd

`killall snmpd`  # this is very important - else no users will be created

Then enter one of the following in /usr/lib/snmp/snmpd.conf ( depending on security level you want to assign )

`createUser fabfi `#this will create a user with no password ( security level probably NoauthNopriv )

`createUser fabfi MD5 "fabpassword"` #creates a user with a password and no encryption ( security level probably authNopriv )

`createUser fabfi MD5 "fabpassword" DES "fabpassphrase`" #Creates a user with an MD5 password, and DES encryption ( security level for this user is most probably authPriv)

To create a user with SHA password

`createUser fabfi SHA1 "fabpassword" DES "fabpassphrase`"  #note the 1 after SHA.


## Security Models ##

Choose either USM or VACM

### USM ###


Add the users you've created to your /etc/snmp/snmpd.conf file

A rwuser has both read and write permissions for the specified oid's

A rouser has only read permissions for the specified oid's


`rwuser fabfi authPriv .1` # in this case, .1 stands for all oids

or

`rouser fabfi authPriv .1.3.2.5` # where .1.3.2.5 is an OiD tree

or

`rwuser fabfi authPriv -V myviewname` # where myviewname is a view

e.g

`snmpwalk -v 3 -u myuser -l authPriv -a MD5 -A mypassword -x DES -X mypassphrase  ipv6:[::1]`

or for a SHA password ( remember when creating the user we specified SHA1 , but when accessing SNMP data, SHA is used - using SHA1 throws an error )

`snmpwalk -v 3 -u myuser -l authPriv -a MD5 -A mypassword -x DES -X mypassphrase  ipv6:[::1]`

For a authNopriv user

`snmpwalk -v 3 -u myuser -l authPriv -a MD5 -A mypassword ipv6:[::1]`

For a noauth user, the username still has to be specified, e.g

`snmpwalk -v 3 -u myuser -l NoauthNoPriv ipv6:[::1]`


### VACM ###

we'll need the following

com2sec and com2sec6 - For mapping community names to a security name. Use com2sec6 when dealing with ipv6 addresses

Group - This is the security module name ( for v1 and v2 ) or the usm username ( for v3 )

Access - this maps the group with the view - syntax

`access group context level prefix read write notify`

Where

**group** is the group you're defining the ACL for

**context** - ( v1, v2c , usm or any )

**level** - the security level ( auth, noauth authpriv etc )

**prefix** - specifies how **context** should be matched against the context of the incoming request ( exact or prefix )

**read**, **write** and **notify** specify which views to use for snmpget, snmpset and snmptrap respectively

As you can see, VACM involves a little more work, but offers the most highly configurable security control . USM without VACM , however, suffices for most applications requiring good security.

Read more below

-- Some Very Useful Links --

-SNMP V3 - http://www.net-snmp.org/wiki/index.php/TUT:SNMPv3_Options

-User security model (usm) -http://www.net-snmp.org/wiki/index.php/TUT:SNMPv3_Options ,http://insanum.com/docs/usm.html

-View Access Control Model - http://www.net-snmp.org/wiki/index.php/Vacm , http://insanum.com/docs/vacm.html

-The snmpd.conf man page - http://www.net-snmp.org/docs/man/snmpd.conf.html#lbAF