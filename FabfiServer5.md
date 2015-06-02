
# Introduction #
The Fabfi server is a cloud-hosted device that houses the authentication database and Management/Monitoring web GUI for the network.  The current version runs on Ubuntu 10.04 Server (i386).  This page provides configuration instructions for building the server from bare metal.

**NOTE: This configuration was documented piecemeal, so there may be redundant instructions, especially related to package installation.  It is unlikely that doing anything multiple times will cause problems, however.**

NOTE2:  This page does NOT cover configuration of user accounts.  For information on user acconuts configuration go to the [UserAndGroupSettings](UserAndGroupSettings.md) page.

NOTE3:  This page isn't done, or correct, yet.

## OS Installation ##

  * Used U11.04 server i386,
  * set up disk with LVM.
  * 25GB HD (could be smaller)
  * 512M RAM
  * No other disk specified at this time
  * No proxy server
  * Select time zone as UTC
  * Install Security Updates Automatically
  * Installed Packages During OS Install
    * OpenSSH Server
    * LAMP Server
  * Installed GRUB

## Configure the OS and the Apache ##

  * set time zone to UTC (if you missed it in OS setup)
```
sudo dpkg-reconfigure tzdata
```
> select "etc" and then "UTC"

  * Set custom date format for apache log
> _Note: the only matters if we're doing custom parsing of this log later, which we currently do not do_
```
$ sudo vi /etc/apache2/apache2.conf
```
> Change
```
LogFormat "%h %l %u %{%Y-%m-%d %H:%M:%S}t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined
```
> to
```
LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined
```

  * Configure time Sync
```
$ sudo vi /etc/cron.daily/ntpdate
```
> enter
```
ntpdate ntp.ubuntu.com
```


## Install 3rd Party Software ##

### Install mysql-server ###

**THIS SHOULD ALREADY BE DONE IF YOU INSTALLED LAMP SERVER DURING OS INSTALL**

```
sudo apt-get install mysql-server
```

  * Select a root user and password (it doesn't matter for our purposes)
  * log into mysql

```
mysql --user root -p
```

  * Set up a user and password for radius, then create the radiusdb

```
mysql> CREATE USER 'radius'@'localhost' IDENTIFIED BY 'some_pass';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'radius'@'localhost'
    ->     WITH GRANT OPTION;
mysql> CREATE DATABASE radiusdb;
```

### Install phpmyadmin ###

```
sudo apt-get install phpmyadmin 
<select apache2 as default server>
<use dbconfig-common>
<enter MySql root password>
<create application password for phpmyadmin>
```

### Install Cacti ###

```
sudo apt-get install cacti
<use dbconfig-common>
<enter MySql root password>
<select apache2 as your configuration>
```

You can ignore errors about php include path.

### Install Freeradius ###

```
sudo apt-get install freeradius freeradius-mysql freeradius-ldap
```

eap.conf (left):

< 			private\_key\_file = ${certdir}/server.pem
---
> 			private\_key\_file = ${certdir}/server.key


< 			random\_file = ${certdir}/random
---
> 			random\_file = /dev/urandom



< 			#make\_cert\_command = "${certdir}/bootstrap"
---
> 			make\_cert\_command = "${certdir}/bootstrap"

Copy your certs to /etc/freeradius/certs/  MAKING CERTS NEEDS DOCUMENTION


Then edit

```
/etc/freeradius/radiusd.conf
```

Uncomment

```
$INCLUDE sql.conf
```

Set proxy\_requests to no and comment the include

```
proxy_requests  = no
#$INCLUDE proxy.conf
```

Then edit

```
/etc/freeradius/sites-enabled/default
```

and uncomment all references to "sql"

Then edit

```
/etc/freeradius/sql.conf
```

and change username and password to match the user and password you created above.  Also change database name to 'radusdb' because this is the db name that will be used by daloradius below.

```
        # Connection info:
        server = "localhost"
        #port = 3306
        login = "radius"
        password = "<your password>"

        # Database table configuration for everything except Oracle
        radius_db = "radiusdb"
```

Then edit

```
/etc/clients.conf
```

set your NAS secret

```
secret = <yoursecret>
```

and add

```
client 10.0.0.0/8 {
  secret = <radius secret for this domain>
  shortname = fabfi-portal
}

client 41.0.0.0/8 {
  secret = <radius secret for this domain>
  shortname = fabfi-cloud
}
```
at the end of the file.  The IPs in this last section are the IPs your networks will be connecting from


### Install Daloradius ###

```
sudo apt-get apache2 php-db php-pear php5-mysql
```

Download the latest Daloradius distribution:
```
sudo cd /etc/ && wget http://downloads.sourceforge.net/project/daloradius/daloradius/daloradius-0.9-8/daloradius-0.9-8.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fdaloradius%2Ffiles%2Fdaloradius%2F&ts=1295083448&use_mirror=garr
```

Extract it to your webserver directory:

```
cd /var/www
sudo tar -xzf ~/daloradius-0.9-8.tar.gz
sudo mv daloradius-0.9-8 daloradius
```

Then Edit your config:

**Navigate to the settings file**

```
cd daloradius/library
vi daloradius.conf.php
```

  * Specify Freeradius version
  * Specify database details.  The values you need to change from the defaults will be:

```
$configValues['DALORADIUS_VERSION'] = '0.9-8';
$configValues['FREERADIUS_VERSION'] = '2';
$configValues['CONFIG_DB_USER'] = 'root';  //Your database username
$configValues['CONFIG_DB_PASS'] = 'password';  //Your database password
$configValues['CONFIG_DB_NAME'] = 'radiusdb';  //The name of your database
$configValues['CONFIG_MAINT_TEST_USER_RADIUSSECRET'] = 'yoursecret';
```

  * The complete config will then look like this:

```
$configValues['DALORADIUS_VERSION'] = '0.9-8';
$configValues['FREERADIUS_VERSION'] = '2';
$configValues['CONFIG_DB_ENGINE'] = 'mysql';
$configValues['CONFIG_DB_HOST'] = '127.0.0.1';
$configValues['CONFIG_DB_USER'] = 'radius';
$configValues['CONFIG_DB_PASS'] = 'password';
$configValues['CONFIG_DB_NAME'] = 'radiusdb';
$configValues['CONFIG_DB_TBL_RADCHECK'] = 'radcheck';
$configValues['CONFIG_DB_TBL_RADREPLY'] = 'radreply';
$configValues['CONFIG_DB_TBL_RADGROUPREPLY'] = 'radgroupreply';
$configValues['CONFIG_DB_TBL_RADGROUPCHECK'] = 'radgroupcheck';
$configValues['CONFIG_DB_TBL_RADUSERGROUP'] = 'radusergroup';
$configValues['CONFIG_DB_TBL_RADNAS'] = 'nas';
$configValues['CONFIG_DB_TBL_RADPOSTAUTH'] = 'radpostauth';
$configValues['CONFIG_DB_TBL_RADACCT'] = 'radacct';
$configValues['CONFIG_DB_TBL_RADIPPOOL'] = 'radippool';
$configValues['CONFIG_DB_TBL_DALOOPERATOR'] = 'operators';
$configValues['CONFIG_DB_TBL_DALORATES'] = 'rates';
$configValues['CONFIG_DB_TBL_DALOHOTSPOTS'] = 'hotspots';
$configValues['CONFIG_DB_TBL_DALOUSERINFO'] = 'userinfo';
$configValues['CONFIG_DB_TBL_DALOUSERBILLINFO'] = 'userbillinfo';
$configValues['CONFIG_DB_TBL_DALODICTIONARY'] = 'dictionary';
$configValues['CONFIG_DB_TBL_DALOREALMS'] = 'realms';
$configValues['CONFIG_DB_TBL_DALOPROXYS'] = 'proxys';
$configValues['CONFIG_DB_TBL_DALOBILLINGPAYPAL'] = 'billing_paypal';
$configValues['CONFIG_DB_TBL_DALOBILLINGPLANS'] = 'billing_plans';
$configValues['CONFIG_DB_TBL_DALOBILLINGRATES'] = 'billing_rates';
$configValues['CONFIG_DB_TBL_DALOBILLINGHISTORY'] = 'billing_history';
$configValues['CONFIG_FILE_RADIUS_PROXY'] = '/etc/freeradius/proxy.conf';
$configValues['CONFIG_PATH_RADIUS_DICT'] = '';
$configValues['CONFIG_PATH_DALO_VARIABLE_DATA'] = '/var/www/daloradius/var';
$configValues['CONFIG_DB_PASSWORD_ENCRYPTION'] = 'cleartext';
$configValues['CONFIG_LANG'] = 'en';
$configValues['CONFIG_LOG_PAGES'] = 'no';
$configValues['CONFIG_LOG_ACTIONS'] = 'no';
$configValues['CONFIG_LOG_QUERIES'] = 'no';
$configValues['CONFIG_DEBUG_SQL'] = 'no';
$configValues['CONFIG_DEBUG_SQL_ONPAGE'] = 'no';
$configValues['CONFIG_LOG_FILE'] = '/tmp/daloradius.log';
$configValues['CONFIG_IFACE_PASSWORD_HIDDEN'] = 'no';
$configValues['CONFIG_IFACE_TABLES_LISTING'] = '25';
$configValues['CONFIG_IFACE_TABLES_LISTING_NUM'] = 'yes';
$configValues['CONFIG_IFACE_AUTO_COMPLETE'] = 'yes';
$configValues['CONFIG_MAINT_TEST_USER_RADIUSSERVER'] = '127.0.0.1';
$configValues['CONFIG_MAINT_TEST_USER_RADIUSPORT'] = '1812';
$configValues['CONFIG_MAINT_TEST_USER_NASPORT'] = '0';
$configValues['CONFIG_MAINT_TEST_USER_RADIUSSECRET'] = 'yoursecret';
```

Run the setup script for freeradius and daloradius:

```
mysql --user root -p radiusdb < /var/www/contrib/db/fr2-mysql-daloradius-and-freeradius.sql
```

### Check your configuration ###

Stop freeradius service then run the configuration check:

```
sudo /etc/init.d/freeradius stop
sudo freeradius -X
```

You should see freeradius start up and the end of the startup message will look something like tis

```
Listening on authentication address * port 1812
Listening on accounting address * port 1813
Ready to process requests.
```

once you have confirmed proper startup you can quit with ctrl+C, then start the service normally:

```
sudo /etc/init.d/freeradius start
```

### Configure SSL for Apache2 ###

**NOTE: It turns out you actually don't need SSL for our current setup, but setting up SSL is generally useful so I'm leaving this section in.  You can skip it if you wish.**

We did this by following the tutorial [here](http://library.linode.com/web-servers/apache/ssl-guides/using-ssl-ubuntu-10.04-lucid#use_a_self_signed_ssl_certificate_with_apache).  The following is a screenscrape of my session:

```
ja@ja2:~$ sudo a2enmod ssl
[sudo] password for ja: 
Enabling module ssl.
See /usr/share/doc/apache2.2-common/README.Debian.gz on how to configure SSL and create self-signed certificates.
Run '/etc/init.d/apache2 restart' to activate new configuration!
ja@ja2:~$ sudo mkdir /etc/apache2/ssl
ja@ja2:~$ sudo openssl req -new -x509 -days 365 -nodes -out /etc/apache2/ssl/apache.pem -keyout /etc/apache2/ssl/apache.key
Generating a 1024 bit RSA private key
.............................................++++++
..............++++++
writing new private key to '/etc/apache2/ssl/apache.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:US
State or Province Name (full name) [Some-State]:MA
Locality Name (eg, city) []:Cambridge
Organization Name (eg, company) [Internet Widgits Pty Ltd]:MyOrg
Organizational Unit Name (eg, section) []:sandbox
Common Name (eg, YOUR name) []:John Doe
Email Address []:foo@bar.com
ja@ja2:~$ 
```

Then edit

```
/etc/apache2/ports.conf
```

and add a new virtual host entry your IP address (or `*` for all IPs)

```
NewVirtualHost *:443  <---you add this
Listen 443 <---this should already be in the file
```

Then you will have to edit the virtual hosts file.  On our machine this file was

```
/etc/apache2/sites-enabled/000-default
```

But it could be named differently on your machine!  It will be in the same directory as above, however.

In this file I copy the entire `<virtualhost>` block for `*:80` and then change the name of the new block to `*:443`.  I then added the following to the top of the new '443' block (just below the `<VirtualHost *:443>` tag) and changed the webmaster email.

```
     SSLEngine On
     SSLCertificateFile /etc/apache2/ssl/apache.pem
     SSLCertificateKeyFile /etc/apache2/ssl/apache.key
```

Then restart your werbserver:

```
$ sudo /etc/init.d/apache2 restart
```

### Configure timeserver ###

TBD

### Set Up IPv6 Tunnel ###

If you have a native ipv6 address, this section can be skipped

  1. [Get a tunnel](IntroductionToIPv6#Setting_up_an_IPv6_tunnel.md)
  1. Edit rc.local to set up the tunnel on boot:
```
ip tunnel add tun0 mode sit remote <tunnel server ipv4 endpoint> local <your local ipv4 ip> ttl 255
ip -6 address add <your local (client) tunnel IP, ex: 2001:320:2e12:130d:fac::d1/64> dev tun0
ip -6 route add default via <tunnel server ipv6 endpoint>
ip -6 link set tun0 up
```

## Configure Server to Serve Splash and Map Content ##

Fabfi nodes are configured to look for cotent at the following urls:
```
master.mesh
radius.mesh
map.mesh
time.mesh #Not necessary for map or splash
```
currently, the router setup on the headnode will resolve all four of these to the same IP. which is configured on the headnode as the IP of your cloud server.

In order to serve web content from a central location you need to do three two things:
  1. Configure a headnode with the correct cloud-server address during the setup script
  1. Configure the remote server to serve splash content at this location
  1. Install appropriate libraries on server

1 will be covered in node setup. The rest is covered here

### Copy Files (map and splash) ###

copy the contents of trunk/www to the home directory of your web server.  A correct setup will have the splash plage resolve to <your IP>/splash.html.  If you are not configuring the live map, you may stop here.

### Configure Fabfi Map ###


Fabfi5 Map is an in-house developed map application.
The map consists of the following components

# meshmib\_db.sql

# db.php

# index.php

# snmp-libs.php

# add-cacti.php

# icons folder


To install the map database, from phpmyadmin, create a database and import meshmib\_db.sql file in trunk/src/ff5map .
Also create a map-server user and edit the password in db.php
The created user should have permissions to read the cacti database or alternatively, use the cacti user for the cacti database.

Copy index.php, add-cacti.php, snmp-libs.php and db.php into a folder in your web server folder.


#### How it works ####

The nodes table holds information pertaining to individual nodes such as the node fabfi number, main IPv6 address, node coordinates, type and info.

Nodes update by calling the index.php script with relevant parameters.

When a new node updates, the add-cacti.php script is called to add it to the the cacti database and also creates graphs for the newly added host.

Every time a node updates, the timestamp field is updated - online nodes are those which have updated within the past 3 minutes and will appear green on the map. Nodes which updated less than 10 minutes ago appear yellow.

The links table is also updated with every node update - it holds the node's IP address, every neighbour's main IP address and corresponding OLSR information. Like above, Only links updated within the past 3 minutes are considered and shown on the map.



#### Optional: Security ####

Since this application doesn't do any sort of real security checking, you might want to update your firewall configuration to accept requests from only certain sites on the port you configure your map server to listen.  Doing this is outside the scope of this tutorial for now.