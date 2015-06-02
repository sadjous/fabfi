# Introduction #

RRDTOOL stands for Round Robin Database Tool. Unlike ordinary databases, a round robin database never grows in size - it simply writes over old data.

rrdtool is the successor to [MRTG](http://en.wikipedia.org/wiki/Multi_Router_Traffic_Grapher) - the Multi Router Traffic Grapher.

Cacti uses rrdtool to store and graph data.

There are basically three things done with rrdtool :

  * Create a round robin database
  * Updating the round robin database
  * Graphing the information in the RRD database

## Creating a RRD database ##

This is done with the command

`rrdtool create`

for example

```
rrdtool create meshdata.rrd --step 60  \
	DS:meshin:DERIVE:600:30:12500000 \
	DS:meshout:DERIVE:600:30:12500000 \
	RRA:AVERAGE:0.5:1:60 \
	RRA:AVERAGE:0.5:5:288 \
	RRA:AVERAGE:0.5:60:168 
	
```

Where :

**meshdata.rrd** is the name of the rrd database we are creating

**--step 60** - means that the database is to be updated every 60 seconds - or rather, the rrd database expects data every 60 seconds

**DS** - stands for data source. In this example, we have two data sources : meshin and meshout

**Derive** - is a data source type . The data source types are
GAUGE, COUNTER, DERIVE and ABSOLUTE.

> _COUNTER_ - Used to store continuously increasing values i.e where the current value is always greater than the last value e.g consider the reading on a car mileage counter. The value stored is the difference between the current and the previous value ( stored value is always positive ).

> _GAUGE_ -  Stores the actual value as it is read. i.e does nothing special with the reading -just stores it.

> _DERIVE_ - Stores a derivative of the last and the current value

> _ABSOLUTE_ - Stores values which reset after each reading


600 is the minimum value - below which the reading will be ignored

30 is the heartbeat  - Heartbeat is the period ( in seconds ) that rrdtool will wait for a reading before storing the value as "unknown" ( remember rrdtool expects a value every 60 seconds i.e the step value )

12500000 is the maximum value - above which the reading will be ignored.

**RRA** - stands for round robin archive. This example defines 3 RRAs. The first RRA `RRA:AVERAGE:0.5:1:60` - averages data every time it is read and stores 60 such values. Since our `--step` was 60 seconds ( one minute ), this RRA will store an hour of data.AVERAGE is a consolidation function - Used to consolidate multiple primary data points (PDPs). Typical consolidation functions are AVERAGE, MIN, MAX.

`RRA:AVERAGE:0.5:5:288` - averages every 5 samples of data ( 5 minute averages ) and stores 288 averages. i.e it will keep a day's worth of data ( 5 x 288 = 1440 minutes & 1440/60 = 24 hours )

`RRA:AVERAGE:0.5:60:168` - averages 60 samples ( one hour averages, since step size = 60 ) and stores 168 such values . i.e 1 week of data ( 24 x 7 = 168 hours )

Check the links at the bottom of the page for more examples.

## Updating a RRD database ##

This is done with the command

`rrdtool update`

For example

`rrdupdate meshdata.rrd -t meshin:meshout N:100:250`

This would update the datasources meshin and meshout with the values 100 and 250 respectively.

To make this more realistic, lets write a script to update meshdata.rrd with interface data and cron it to run every one minute.

```
#!/bin/bash

MESHRRD=/home/user/meshdata.rrd
MESHIF=eth0
MESHIN=`ifconfig "${MESHIF}" |grep bytes|awk -F ":" '{print $2}'|awk '{print $1}'`
MESHOUT=`ifconfig "${MESHIF}" |grep bytes|awk -F ":" '{print $3}'|awk '{print $1}'`
rrdupdate "${MESHRRD}" -t meshin:meshout N:"${MESHIN}":"${MESHOUT}

```

### Fetching data from an RRD database ###

This is done using the command `rrdtool fetch`

For example

`rrdtool fetch meshdata.rrd AVERAGE`

To fetch data stored between certain periods ( in unix time stamp )

`rrdtool fetch meshdata.rrd AVERAGE --start 1310229568 --end 1310229868`


## Generating a graph ##

This is done with the command

`rrdtool graph`

For example, to graph the data we just created

```

rrdtool graph meshgraph.png -a PNG -s -120 -w 550 -h 240 -v "bits/s" \
  'DEF:ds1=meshdata.rrd:meshin:AVERAGE' \
  'DEF:ds2=meshdata.rrd:meshout:AVERAGE' \
  'LINE1:ds1#00FF00:Incoming Traffic' \
  GPRINT:ds1:MAX:"Max %6.2lf %s" \
  GPRINT:ds1:MIN:"Min %6.2lf %s" \
  GPRINT:ds1:AVERAGE:"Avg %6.2lf %s" \
  GPRINT:ds1:LAST:"Curr %6.2lf %s\n" \
  'LINE1:ds2#0000FF:Outgoing Traffic' \
  GPRINT:ds2:MAX:"Max %6.2lf %s" \
  GPRINT:ds2:MIN:"Min %6.2lf %s" \
  GPRINT:ds2:AVERAGE:"Avg %6.2lf %s" \
  GPRINT:ds2:LAST:"Curr %6.2lf %s" \
  -t MeshDataGraph
  
```

This will create a simple line graph ( title= **MeshDataGraph** ) that shows the last 2 hours ( -s 120 ) of traffic through the mesh interface.

For more on rrdtool, follow the links below.

References

http://oss.oetiker.ch/rrdtool/tut/rrdtutorial.en.html

http://www.cuddletech.com/articles/rrd/index.html