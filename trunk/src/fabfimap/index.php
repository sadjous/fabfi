<?php


define('IPV6_REGEX', "/^\s*((([0-9A-Fa-f]{1,4}:){7}(([0-9A-Fa-f]{1,4})|:))|(([0-9A-Fa-f]{1,4}:){6}(:|((25[0-5]|2[0-4]\d|[01]?\d{1,2})(\.(25[0-5]|2[0-4]\d|[01]?\d{1,2})){3})|(:[0-9A-Fa-f]{1,4})))|(([0-9A-Fa-f]{1,4}:){5}((:((25[0-5]|2[0-4]\d|[01]?\d{1,2})(\.(25[0-5]|2[0-4]\d|[01]?\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:){4}(:[0-9A-Fa-f]{1,4}){0,1}((:((25[0-5]|2[0-4]\d|[01]?\d{1,2})(\.(25[0-5]|2[0-4]\d|[01]?\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:){3}(:[0-9A-Fa-f]{1,4}){0,2}((:((25[0-5]|2[0-4]\d|[01]?\d{1,2})(\.(25[0-5]|2[0-4]\d|[01]?\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:){2}(:[0-9A-Fa-f]{1,4}){0,3}((:((25[0-5]|2[0-4]\d|[01]?\d{1,2})(\.(25[0-5]|2[0-4]\d|[01]?\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:)(:[0-9A-Fa-f]{1,4}){0,4}((:((25[0-5]|2[0-4]\d|[01]?\d{1,2})(\.(25[0-5]|2[0-4]\d|[01]?\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(:(:[0-9A-Fa-f]{1,4}){0,5}((:((25[0-5]|2[0-4]\d|[01]?\d{1,2})(\.(25[0-5]|2[0-4]\d|[01]?\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(((25[0-5]|2[0-4]\d|[01]?\d{1,2})(\.(25[0-5]|2[0-4]\d|[01]?\d{1,2})){3})))(%.+)?\s*$/");

define('GPS_REGEX',"/^(-?[0-9]{1,3}\.[0-9]{1,16})\s*,\s*(-?[0-9]{1,3}\.[0-9]{1,16})\s*,?\s*(.*)/" );

include("snmp_libs.php");

// open database connection

$con = mysql_connect("localhost","mapserver","cisco123");


if (!$con)
{
        die('Could not connect: ' . mysql_error());
}


if ( $_GET["action"] == "update" ) 
 // Update map
{

	// validate stuff
	
	mysql_select_db("meshmib", $con);

	$fabfi_number=$_GET["node_id"];

	$node_ip=$_GET["node_ip"];

	$node_coords=explode(",",$_GET["node_coords"]);

	$node_lat=$node_coords[0];
	
	$node_lon=$node_coords[1];

	$neigh_ip=explode(",",$_GET["neigh_ips"]);

	$neigh_lq=explode(",",$_GET["neigh_lqs"]);

	$neigh_nlq=explode(",",$_GET["neigh_nlqs"]);

	$neigh_cost=explode(",",$_GET["neigh_costs"]);

	$neighbours=count($neigh_ip);

	$timestamp=date("Y-m-d H:i:s",time());		

	// Check if we have this node's details

	$check=mysql_fetch_array(mysql_query("select * from node where fabfi_number='".$fabfi_number."'AND ipv6_address='".$node_ip."'"));

	if ( empty($check) ) { // new node - do magic

		
		$snmp_port      = 161;                          
		$snmp_timeout   = 500;                          
		$snmp_retries   = 3;                            
		$max_oids       = 1;
                  
		# required for SNMP V3
		$snmp_auth_username     = "fabfi-user";
		$auth_password     = "cisco123";
		$auth_protocol     = "SHA";
		$priv_passphrase   = "cisco123";
		$priv_protocol     = "AES";
		$snmp_context           = "";

		$sec_level = "AuthPriv";

		$host_address="ipv6:[".$node_ip."]";

		$node_type = @snmp3_get ( $host_address , $snmp_auth_username ,  $sec_level ,  $auth_protocol , $auth_password , $priv_protocol ,  $priv_passphrase , $oids['node_type'], ($snmp_timeout*1000), $snmp_retries );

		$node_type=format_snmp_string($node_type, $oids['node_type']);

		if ( empty($node_type) || empty($node_ip) || empty($node_lat) || empty($node_lon) ) {

			echo "Failed to add node";

		}
		else {

			mysql_query("INSERT INTO `meshmib`.`node` (`fabfi_number`,`ipv6_address`,`type`,`latitude`,`longitude`,`timestamp`) VALUES ('".$fabfi_number."','".$node_ip."','".$node_type."','".$node_lat."','".$node_lon."','".$timestamp."')");
			echo "Node Added";
		}

	}

	else {

		mysql_query("UPDATE  `meshmib`.`node` SET  `latitude`='".$node_lat."',`longitude`='".$node_lon."',`timestamp` =  '".$timestamp."' WHERE  `node`.`fabfi_number` =$fabfi_number");

		for ( $i=0; $i<=($neighbours-1); $i++ ) {

			if (empty($neigh_ip[$i]) || empty($neigh_lq[$i]) || empty ($neigh_nlq[$i]) || empty ($neigh_cost[$i]) ) {
				echo "Null Entry";
			}
			else {
				mysql_query("INSERT INTO  `meshmib`.`links` (`index` ,`source_ip` ,`dest_ip` ,`lq` ,`nlq` ,`cost`,`timestamp`)VALUES (NULL ,'".$node_ip."','".$neigh_ip[$i]."','".$neigh_lq[$i]."','".$neigh_nlq[$i]."','".$neigh_cost[$i]."', NULL)");

			}

		}
	}
}


//Display map

else {  


?>

<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<style type="text/css">
  html { height: 100% }
  body { height: 100%; margin: 0; padding: 0 }
  #map_canvas { height: 100% }
</style>

<script type="text/javascript"
    src="http://maps.googleapis.com/maps/api/js?sensor=true">
</script>

<script type="text/javascript">

var map;
var nodeArray = [] ;
var lineArray = [] ;


var capetown = new google.maps.LatLng(-1.27872, 36.81696);
var farmschool = new google.maps.LatLng(42.610109, -72.254945);

var nairobi = new google.maps.LatLng(-1.27085, 36.774909);

// SHAPES - Triangle, Square, Circle

var T_NODE_UP = new google.maps.MarkerImage('icons/triangle_green.png',
	new google.maps.Size(20, 20),
	new google.maps.Point(0,0),
	new google.maps.Point(10,10));

var T_NODE_TEMPDOWN = new google.maps.MarkerImage('icons/triangle_yellow.png',
	new google.maps.Size(20, 20),
	new google.maps.Point(0,0),
	new google.maps.Point(10,10));

var T_NODE_DOWN = new google.maps.MarkerImage('icons/triangle_red.png',
	new google.maps.Size(20, 20),
	new google.maps.Point(0,0),
	new google.maps.Point(10,10));
	
var T_NODE_DEAD = new google.maps.MarkerImage('icons/triangle_grey.png',
	new google.maps.Size(20, 20),
	new google.maps.Point(0,0),
	new google.maps.Point(10,10));

var T_NODE_UNKNOWN = new google.maps.MarkerImage('icons/triangle_blue.png',
	new google.maps.Size(20, 20),
	new google.maps.Point(0,0),
	new google.maps.Point(10,10));

var C_NODE_UP = new google.maps.MarkerImage('icons/circle_green.png',
	new google.maps.Size(20, 20),
	new google.maps.Point(0,0),
	new google.maps.Point(10,10));

var C_NODE_TEMPDOWN = new google.maps.MarkerImage('icons/circle_yellow.png',
	new google.maps.Size(20, 20),
	new google.maps.Point(0,0),
	new google.maps.Point(10,10));

var C_NODE_DOWN = new google.maps.MarkerImage('icons/circle_red.png',
	new google.maps.Size(20, 20),
	new google.maps.Point(0,0),
	new google.maps.Point(10,10));
	
var C_NODE_DEAD = new google.maps.MarkerImage('icons/circle_grey.png',
	new google.maps.Size(20, 20),
	new google.maps.Point(0,0),
	new google.maps.Point(10,10));

var C_NODE_UNKNOWN = new google.maps.MarkerImage('icons/circle_blue.png',
	new google.maps.Size(20, 20),
	new google.maps.Point(0,0),
	new google.maps.Point(10,10));

var S_NODE_UP = new google.maps.MarkerImage('icons/square_green.png',
	new google.maps.Size(20, 20),
	new google.maps.Point(0,0),
	new google.maps.Point(10,10));

var S_NODE_TEMPDOWN = new google.maps.MarkerImage('icons/square_yellow.png',
	new google.maps.Size(20, 20),
	new google.maps.Point(0,0),
	new google.maps.Point(10,10));

var S_NODE_DOWN = new google.maps.MarkerImage('icons/square_red.png',
	new google.maps.Size(20, 20),
	new google.maps.Point(0,0),
	new google.maps.Point(10,10));
	
var S_NODE_DEAD = new google.maps.MarkerImage('icons/square_grey.png',
	new google.maps.Size(20, 20),
	new google.maps.Point(0,0),
	new google.maps.Point(10,10));

var S_NODE_UNKNOWN = new google.maps.MarkerImage('icons/square_blue.png',
	new google.maps.Size(20, 20),
	new google.maps.Point(0,0),
	new google.maps.Point(10,10));

var T_NODEtoT_NODE = "#0000FF"; // blue
var T_NODEtoC_NODE = T_NODEtoT_NODE;
var C_NODEtoT_NODE = T_NODEtoC_NODE;
var C_NODEtoC_NODE = "#FF0000"; // red
var T_NODEtoS_NODE = "#00FF00"; // green
var S_NODEtoT_NODE = T_NODEtoS_NODE;
var S_NODEtoC_NODE = T_NODEtoS_NODE;
var C_NODEtoS_NODE = S_NODEtoC_NODE;
var S_NODEtoS_NODE = T_NODEtoS_NODE;

// End Shapes

function initialize_map() {

	var mapOptions = {
		zoom: 16,
		center: nairobi,
		mapTypeId: google.maps.MapTypeId.ROADMAP
		};

	map = new google.maps.Map(document.getElementById("map_canvas"),mapOptions);

	<?php

	$lines_array=array(); // This array holds the lines we've drawn


	mysql_select_db("meshmib", $con);

	$query=mysql_query("SELECT * FROM  `node`");

	while ( $row = mysql_fetch_array($query))
	{
		if ( ( time() - STRTOTIME($row['timestamp'])) < 180 ) {
			$node_status = "UP";
		}

		elseif ( ( time() - STRTOTIME($row['timestamp'])) < 600 ){
			$node_status = "TEMPDOWN";
		}

		
		elseif ( ( time() - STRTOTIME($row['timestamp'])) < 86400 ){
			$node_status = "DOWN";
		}


		elseif ( ( time() - STRTOTIME($row['timestamp'])) > 86400 ){
			$node_status = "DEAD";
		}

		else {
			$node_status = "UNKNOWN";
		}

		$node_coordinates = $row['latitude'] . ", " . $row['longitude'];
		$node_type = $row['type'] . "_NODE";
		$node_icon=$node_type . "_" . $node_status;
		$node_fabfi_number=$row['fabfi_number'];
		$node_ip=$row['ipv6_address'];

		//Finally, generate required Javascript to place a marker
		
		echo "addNodeMarker(new google.maps.LatLng(" . $node_coordinates ."),". $node_icon .",".$row['cacti_index'].");\n" ;



		// Draw Lines

		$three_minutes_ago=date("Y-m-d H:i:s",time()-180);

		$links=mysql_query("select * from links where timestamp >='".$three_minutes_ago."' AND source_ip = '".$node_ip."'");

		while ($result = mysql_fetch_array($links) )
		{
			$cost=$result['cost'];
			
			$neigh_fabfi_number=mysql_fetch_array( mysql_query("select fabfi_number from node where ipv6_address = '".$result['dest_ip']."' limit 1" ) );  
			$neigh_fabfi_number=$neigh_fabfi_number['fabfi_number'];
			$neigh_details=mysql_fetch_array ( mysql_query("select `latitude`,`longitude`,`type` from node where fabfi_number = '".$neigh_fabfi_number."'"));
			$neigh_coordinates=$neigh_details['latitude'].", ".$neigh_details['longitude'];
			$neigh_type=$neigh_details['type']. "_NODE";
	
			$conntype=$node_type."to".$neigh_type;
	
			//generate javascript for a line - first check that we've not drawn this line before.

			if (! in_array($node_coordinates.$neigh_coordinates,$lines_array) && ! in_array($neigh_coordinates.$node_coordinates,$lines_array) ){
				if ( ! is_null($neigh_coordinates) ||  ! is_null($neigh_type) ) {

					echo "addLine(new google.maps.LatLng(".$node_coordinates."), new google.maps.LatLng(".$neigh_coordinates."),".$cost.",".$conntype.");\n";
				array_push($lines_array, $node_coordinates.$neigh_coordinates);
			
				}
			}
		}




	}

	?>
}

/* Line Colours
Purple - FF00FF
Red - FF0000
Blue - 0000FF
Green - 00FF00


*/

function addNodeMarker(location,node_icon,cactiID) {
	marker = new google.maps.Marker({
	position: location,
	map: map,
	icon: node_icon
	
	});
	nodeArray.push(marker);
}

function addLine(node1,node2,cost,conntype) {
	
	var newLine = [ node1, node2 ];
		var opacity=1/cost;
		var newPath = new google.maps.Polyline({	
		map: map,
		path: newLine,
		strokeColor: conntype,
		strokeOpacity: opacity,
		strokeWeight: 2 
		});
		
}



function initialize() {
	initialize_map();
}



</script>

</head>



<body onload="initialize()">
  <div id="map_canvas" style="width:100%; height:100%"></div>


</body>
</html>

<?php

} // Closes else - Display map

mysql_close($con); // Close all database connections.

?>
