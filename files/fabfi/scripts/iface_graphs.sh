#!/bin/sh
#

# Directory for storing RRD Databases
RRDDATA="/root/rrd/"


# Directory for storing webpages / images
RRDIMG="/www/stats/"

if [ ! -d "${RRDDATA}" ]
	then
		mkdir -p "${RRDDATA}"
fi

if [ ! -d "${RRDIMG}" ]
	then
		mkdir -p "${RRDIMG}"
fi

if_list=$( ifconfig | grep HWaddr | cut -d " " -f 1 | tr "\n" " " )

WANRRD="${RRDDATA}/${WANIF}.rrd"
LANRRD="${RRDDATA}/${LANIF}.rrd"
WLANRRD="${RRDDATA}/${WLANIF}.rrd"


CreateRRD ()
{	
	rrdtool create "${1}" \
	DS:in:DERIVE:600:0:12500000 \
	DS:out:DERIVE:600:0:12500000 \
	RRA:AVERAGE:0.5:1:576 \
	RRA:AVERAGE:0.5:6:672 \
	RRA:AVERAGE:0.5:24:732 \
	RRA:AVERAGE:0.5:144:1460
}

CreateGraph ()
{
	rrdtool graph "${1}.new" -a PNG -s -"${2}" -w 550 -h 240 -v "bits/s" \
	'DEF:ds1='${3}':in:AVERAGE' \
	'DEF:ds2='${3}':out:AVERAGE' \
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
	-t "${4}"
	mv -f "${1}.new" "${1}"
}


EIGHT=8
for i in ${if_list}
do
	RRDfile=${RRDDATA}/$i.rrd
	if [ "$i" != "eth1:1" ] && [ "$i" != "niit4to6" ] && [ "$i" != "niit6to4" ]; then
		if [ ! -f "${RRDfile}" ]
		then
			CreateRRD "${RRDfile}"
		fi
		
		if_out=$(($(ifconfig eth1 | grep "TX packets" | cut -d ":" -f 2 | cut -d " " -f 1) * $EIGHT ))
		if_in=$(($(ifconfig eth1 | grep "RX packets" | cut -d ":" -f 2 | cut -d " " -f 1) * $EIGHT ))
		echo $if_out	
		echo $if_in	
		rrdupdate "${RRDfile}" -t in:out N:"${if_in}":"${if_out}"
		CreateGraph "${RRDIMG}/"$i"_daily.png" 86400 "${RRDfile}" $i
	fi
done

# $1 = ImageFile , $2 = Time in secs to go back , $3 = RRDfil , $4 = GraphText 
