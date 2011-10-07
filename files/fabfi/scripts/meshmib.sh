#!/bin/ash
latlonfile=/var/run/latlon-bc.js

self_ip=$( cat $latlonfile | grep -i self | cut -d "(" -f 2 | cut -d "," -f 1 | tr -d "'" )
remote_ip=$(cat $latlonfile  | grep -i node | cut -d "(" -f 2 | cut -d "," -f 1 | tr -d "'" | tr "\n" " ")

#Node's own coordinates
my_lat=`uci get olsrd.@LoadPlugin[1].lat`
my_lon=`uci get olsrd.@LoadPlugin[1].lon`

get_neigh_longitude()
{
#Require's node IP address
$node_ip=$1
cat $latlonfile | grep  "'$node_ip','$self_ip'" | cut -d "," -f 7
}

get_neigh_latitude()
{

cat $latlonfile | grep  "'$node_ip','$self_ip'" | cut -d "," -f 6

}


case $1 in

	lat )
		echo ${my_lat}
		;;
	lon )
		echo ${my_lon}
		;;

	neigh_ip )

		cat $latlonfile | grep -i node | cut -d "(" -f 2 | cut -d "," -f 1 | tr -d "'"
		;;

	neigh_hostname )
		cat $latlonfile | grep -i node | cut -d "," -f 6 | cut -d ")" -f 1 | tr -d "'"
		;;

	neigh_lat )
		for i in ${remote_ip}
		do
			get_neigh_latitude $i
		done
		;;

	neigh_lon )
                for i in ${remote_ip}
		do
			get_neigh_longitude $i
		done
                ;;
	neigh_lq )
		for i in ${remote_ip}
        	do
        		cat $latlonfile | grep  "'$i','$self_ip'" | cut -d "," -f 3
        	done
		;;
	neigh_nlq )
		for i in ${remote_ip}
		do
			cat $latlonfile | grep  "'$i','$self_ip'" | cut -d "," -f 4
		done
		;;
	neigh_cost )
		for i in ${remote_ip}
		do
			cat $latlonfile | grep  "'$i','$self_ip'" | cut -d "," -f 5
		done
		;;

	radio1_clients )

		iw dev wlan1 station dump | grep Station | cut -d " " -f 2
		;;
	avg_signal )
		iw dev wlan1 station dump | grep "signal avg" | cut -d ":" -f 2 | tr -d "\t" | cut -d " " -f 1
		;;
	tx_bitrate )
		iw dev wlan1 station dump | grep -i "tx bitrate" | cut -d ":" -f 2 | cut -d " " -f 1 | tr -d "\t"
		;;
	rx_bitrate )
		iw dev wlan1 station dump | grep -i "rx bitrate" | cut -d ":" -f 2 | cut -d " " -f 1 | tr -d "\t"
		;;


esac
