

# Introduction #

This page will soon contain tools and tricks for managing your network installation.

# Node Mapping #

Thanks to some help from Christiaan Adams of the Google Earth team, we have a nifty automated way of visualizing nodes in google maps or earth.

There are two parts to the system:
  * [A Google form to enter node data](https://spreadsheets.google.com/a/fabfolk.com/viewform?hl=en&formkey=dFZoRm9zRUtkYktiNTU3NFhFU255Tnc6MA#gid=0). Get a copy [here](https://spreadsheets.google.com/a/fabfolk.com/ccc?key=0Apnn7ogs3vm1dFVORHdaUnRQMWVCMXpIY3VMajExU1E&newcopy).
  * [A special Google spreadsheet that makes map overlays](https://spreadsheets.google.com/a/fabfolk.com/ccc?key=0Apnn7ogs3vm1dHNCX0tFVHZYTE1Qakc2LWxocWtOd3c&hl=en#gid=1). Get a copy [here](https://spreadsheets.google.com/a/fabfolk.com/ccc?key=0Apnn7ogs3vm1dHNCX0tFVHZYTE1Qakc2LWxocWtOd3c&newcopy).

Once you have your copies of both documents, fill in the red fields on the first sheet of the spreadsheet, then enter your node data with a form.  If you want to have pictures for your nodes, upload them to the web directory you specified in the spreadsheet with the name:
```
<node number>.jpg
```

When you're all done, the spreadsheet will give you a link to a Google map that you can post online [like this](http://maps.google.com/maps?f=q&hl=en&geocode=&q=https:%2F%2Fspreadsheets.google.com%2Fa%2Ffabfolk.com%2Fpub%3Fhl%3Den%26hl%3Den%26key%3D0Apnn7ogs3vm1dHNCX0tFVHZYTE1Qakc2LWxocWtOd3c%26output%3Dtxt%26gid%3D0%26range%3Dkml_output%26time1%3D4060933) and a link to [a list of placemark data](https://spreadsheets.google.com/a/fabfolk.com/pub?hl=en&hl=en&key=0Apnn7ogs3vm1dHNCX0tFVHZYTE1Qakc2LWxocWtOd3c&output=html&output=csv&gid=2&range=data_dump).  If you use earth, it is also supposed to create KML [like this](http://fabfi.googlecode.com/svn/wiki/files/nodelist_netlink.kmz), but I've had trouble getting this feature to work in the linux version of Google Earth (the linked file was created in Windows)

# Monitoring with Cacti #

Cacti is an RRD based monitoring tool that uses SNMP and RRD to graph node data.
For a short tutorial on SNMP , go [here](IntroductionToSNMP.md) and to learn a little on rrdtool, go [here](RRDtutorial.md) .

To install cacti on an ubuntu desktop/server computer :

Install `mysql server`

`sudo apt-get install mysql-server`

don't forget the root database password

`sudo apt-get install apache2`

Test your webserver - make sure it works ( go to http://127.0.0.1 - you should see "IT WORKS" in bold h1 )


`sudo apt-get install php5`

`sudo apt-get install libapache2-mod-php5`

Now,

`sudo apt-get install snmpd snmp php5-mysql php5-cli php5-snmp`

`sudo apt-get install rrdtool`

`sudo apt-get install cacti`

Running the last command should resolve other cacti dependencies

Access cacti from http://localhost/cacti/

Should you get a 404 error while trying to access cacti ( happened to me on Ubuntu desktop 11.04 , didn't happen on Ubuntu Server ), add the lines below to your `/etc/apache2/sites-enabled/000-default`

```
Alias /cacti /usr/share/cacti/site

<Directory /usr/share/cacti/site>
        Options +FollowSymLinks
        AllowOverride None
        order allow,deny
        allow from all

        AddType application/x-httpd-php .php

        <IfModule mod_php5.c>
                php_flag magic_quotes_gpc Off
                php_flag short_open_tag On
                php_flag register_globals Off
                php_flag register_argc_argv On
                php_flag track_vars On
                # this setting is necessary for some locales
                php_value mbstring.func_overload 0
                php_value include_path .
        </IfModule>

        DirectoryIndex index.php
</Directory>
```

The same lines can be found in `/etc/cacti/apache.conf`

Restart apache by running

`/etc/init.d/apache2 restart`

Access cacti from http://localhost/cacti/ or from another computer `http://<server-ip-address>/cacti/`

Click next ( if you agree with the terms )

Login to cacti - the default username is "admin" and password is "admin". Cacti will prompt a password change after the first login.

To add devices click on `Create devices for network`

Click `ADD`  ( top right corner )

The most important fields are :

**Description** - Enter fabfi number of the device

**IP address** - Enter device IP address ( I'm assuming your server is on the same network as the devices / device is on public IP address - if not, there's a "dirty hack" I'll soon post to monitor devices behind the NAT router )


**Host template** - Choose `Generic SNMP-enabled host`


**SNMP Version** - Choose Version 2


Leave the other options as default or change them ( if you know what you are doing )

Click on `create` button once you've filled all ( important ) fields

Click on `Create Graphs for this host`

Select the interfaces you want to monitor traffic on

Cacti should confirm if graph creation was successful.

Now click on the `console` tab ( top left corner )

On the left side bar, click `graph trees` ( under management )

Add a new tree - Call it fabfi

Add hosts to the tree -

**Tree Item Type** - host

Leave everything else as default ( unless you know what you're doing )

Click on `create` button

Now click on the `graphs` tab

On the left sidebar, expand the fabfi tree

Click on the host whose graphs you want to view - it may take a while to see meaningful stuff on the graph as the rrd database is still updating - be patient and check 10 minutes later :-)

Enjoy using cacti !

explore more graph options and even create your own graph templates - click on the link below for more.


To learn more on other data input methods besides SNMP, click on the link below.

References

[Complete cacti manual](http://docs.cacti.net/manual:087:2_basics.0_principles_of_operation#basics).

# General Linux System Management #

See [Computing Basics](ComputingBasics#System_Administration_Principals,_Obtaining_Software_and_Support.md)