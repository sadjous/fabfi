
# Introduction #
The Fabfi server is a cloud-hosted device that houses the authentication database and Management/Monitoring web GUI for the network.  The current version runs on Ubuntu 10.04 Server (i386).  This page provides configuration instructions for building the server from bare metal.

**NOTE: This configuration was documented piecemeal, so there may be redundant instructions, especially related to package installation.  It is unlikely that doing anything multiple times will cause problems, however.**

NOTE2:  This page does NOT cover configuration of user accounts.  For information on user acconuts configuration go to the [UserAndGroupSettings](UserAndGroupSettings.md) page.

## OS Installation ##

  * Used U10.04 server i386,
  * set up disk with LVM.
  * system drive 50% of disk (=10GB)
  * 256M RAM
  * No other disk specified at this time
  * No proxy server
  * Install Security Updates Automatically
  * Installed Packages During OS Install
    * OpenSSH Server
  * Installed GRUB

## Configure the OS and the Apache ##

  * set time zone to UTC
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

### Install Freeradius ###

```
sudo apt-get install freeradius freeradius-mysql
```

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

## Installing Nagios ##

Nagios is an open-source network monitoring platform.  In this section you will download, build, install and configure it on your server.

### Install Dependencies ###

  * Install apache2, php5, php5-gd, gcc and make using apt-get sudo apt-get install apache2 php5 php-gd gcc make

### Set Permissions ###

  1. Create a nagios user and usergroup
```
	sudo useradd nagios
	sudo passwd nagios  #assign the new user a password
	sudo groupadd nagios
	sudo groupadd nagcmd
```
  1. Add the nagios user to the nagios and nagcmd groups
```
	sudo usermod -G nagios nagios
 	sudo usermod -a -G nagcmd nagios
```
  1. Add the apache user to the group nagcmd
```
	sudo usermod -a -G nagcmd www-data
```

### Download, Build anf Install Source ###

  1. Download the the latest Nagios core and Nagios plugins from
```
	http://www.nagios.org/download
```
  1. Extract the tar.gz files from the nagios archive you downloaded
```
	tar -xzvf nagios-x.y.z.tar.gz
```
  1. Change into the extracted folder
```
	cd nagios-x.y.z
```
  1. Run the configure and make scripts
```
	sudo ./configure –with-command-group=nagcmd
	sudo make all
```
  1. Install everything
```
	sudo make install
	sudo make install-init
	sudo make install-config
	sudo make install-commandmode
	sudo make install-webconf
```

### Configure Nagios ###

  1. Create the nagios admin account and assign it a password
```
	sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
```
  1. Restart apache
```
	sudo /etc/init.d/apache2 reload
```
  1. Extract the plugins folder
```
	tar -xzvf nagios-plugins-x.y.z
```
  1. Change into the extracted directory
```
	cd nagios-plugins-x.y.z
```
  1. Compile the plugins
```
	sudo ./configure –with-nagios-user=nagios –with-nagios-group=nagios
```
  1. Make and install the plugins
```
	sudo make && sudo make install
```
  1. Add nagios to init ( to start it up when system starts up)
```
	sudo ln -s /etc/init.d/nagios /etc/rcS.d/S99nagios
```
  1. Check for any errors. Run
```
	sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
```
  1. If there are no errors, start nagios
```
	sudo /etc/init.d/nagios start
```
  1. Open the web interface. Point your browser to http://localhost/nagios or if installed on a different server, http://address-of-server/nagios

### Nagios Plugins on OpenWRT ###

We'll install nagios-plugins, and send\_nsca on Fabfi headnodes.  All other routers will have nagios-plugins and nrpe.  Send\_nsca passively reports monitoring info to the nagios server.  nrpe allows a remote Nagios server to actively request data (by running local plugins).  The headnode actively monitors the mesh with nrpe and passively sends the data to the server with send\_nsca. Nagios configuration is covered in headnode setup.

----------- MOVE THIS ------------------

If interested in active monitoring, read http://nagios.sourceforge.net/docs/nrpe/NRPE.pdf

Install nagios-plugins and send\_nsca
> opkg update
> opkg install nagios-plugins
> opkg install send\_nsca

------------ END MOVE -----------------

### Build, Install and Configure NSCA ###

  1. Download the latest nsca from
```
	http://prdownloads.sourceforge.net/sourceforge/nagios/nsca-x.y.z.tar.gz
```
  1. Extract the tar ball and change into the extracted folder with
```
	tar -xzvf nsca-x.y.z.tar.gz && cd nsca-x.y.z
```
  1. Configure and make
```
	./configure && make all
```
  1. Install nsca
```
	cp src/nsca /usr/local/nagios/bin
	cp sample_config/nsca.cfg /usr/local/nagios/etc
```
  1. Edit nsca config file
```
	sudo nano /usr/local/nagios/etc/nsca.cfg
	#Comment out server_address and set debug to 1, comment out encryption password and set encryption off
```
  1. Run nsca
```
	sudo /usr/local/nagios/bin/nsca -c /usr/local/nagios/etc/nsca.cfg
```
  1. Check if nsca port is open. From another computer (in the network), run
```
	telnet [address of server] 5667
```

### Test send\_nsca ###

  1. On the openwrt router, edit /etc/send\_nsca.cfg
```
 	vi /etc/send_nsca.cfg
```
> > comment out encryption password and set encryption off
  1. create a text file (name it 'test') and insert the following (use tabs, not spaces)
```
	localhost	TestMessage	0	This is a test message. [return]
```
  1. Save the file and then run
```
	send_nsca -H [address_of_nagios_server]  < test
```

> if successful, you should see "1 data packet(s) sent to host successfully"


### Further configurations of Nagios Server ###

  1. Start nsca on nagios startup
```
	#edit /etc/init.d/nagios
	sudo nano /etc/init.d/nagios
	# add this line to the start section
	/usr/local/nagios/bin/nsca -c /usr/local/nagios/etc/nsca.cfg
	#and this to the stop section
	kill nsca.pid
```


### References ###
  * http://www.ghacks.net/2009/06/08/how-to-install-nagios-on-ubuntu-server/
  * http://www.smallbusinesstech.net/more-complicated-instructions/nagios/setting-up-nagios-on-a-debian-server-to-remotely-monitor-an-openwrt-router
  * http://www.crucialwebhost.com/blog/using-nrpe-to-monitor-remote-services/
  * http://www.thegeekstuff.com/2008/06/how-to-monitor-remote-linux-host-using-nagios-30/
  * http://nagios.sourceforge.net/download/contrib/documentation/misc/NSCA_Setup.pdf
  * http://nagios.sourceforge.net/docs/2_0/distributed.html
  * http://www.packtpub.com/article/passive-checks-nsca-nagios-service-check-acceptor

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

### Configure Live Map ###

The live map is a php application adapted from [freifunkmap](http://www.layereight.de/download/freifunkmap.tgz).  It receives http requests from nodes with neighbor data, saves the data in a local database and writes it to the GoogleMaps API on demand.  To configure it for your network, You will have to configure the php application on the cloud server and configure the update script (fabfimap.sh) on the nodes.  This section will cover the server side, while the node side is covered in node setup.

#### Setup ####

Install required libraries:
```
sudo apt-get sqlite php5-sqlite
```
then copy the contents of
```
trunk/www/live
```
to your web directory. You also want to make sure that your webserver accepts index.php as a default document.  By default apache will accept index.php as a default document.  If, for some reason, it does not you should configure it to do so.

Yo will then need to configure some values for your server.   Open
```
freifunkmap.config.php
```
and you will see these values:
```
define( "GOOGLE_MAPS_KEY"       ,  "ABQIAAAA09xI2Q46-z5rGpiuYrem8hTfoQ4k9cRoM3EqAQ3hmdQlsFIAsRQQrVrH_du6CZ6dt9yavlipSSMZFw");
define( "DEFAULT_START_POSITION",  "52.526039219655445, 13.411388397216797");
define( "DEFAULT_ZOOMLEVEL",       "13");
define( "DEFAULT_UPDATEINTERVALL", "3600");
define( "DEFAULT_MAPTYPE",         "G_NORMAL_MAP");
define( "PATH_TO_DATABASE",        "/etc/sqlite/");    // in the install mode, this folder have to be writeable for the webserver user
define( "DATABASE_FILE",           "nodedb");   // this file would be created in install mode
```

  * For GOOGLE\_MAPS\_KEY, you must get a unique key from [this site](https://code.google.com/apis/maps/signup.html).
  * For PATH\_TO\_DATABASE, you need to create a path for sqlite to store data and give the webuser acct (www-data) rights to it.  For example:
```
mkdir /etc/sqlite/
sudo chown www-data /etc/sqlite/
```
I don't recommend using the /tmp/ folder (freifunkmap default) as you need to reinitialize everything after a reboot.

  * The remaining values are self-explanatory

Once you have completed the above server, go to a browser and call
```
http://{path to map script}/index.php?install
```

the server should now be up and running.  Test by browsing to:
```
http://{path to map script}/
```
you should get a google map.

#### Optional: Security ####

Since this application doesn't do any sort of real security checking, you might want to update your firewall configuration to accept requests from only certain sites on the port you configure your map server to listen.  Doing this is outside the scope of this tutorial for now.