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

	$con = mysql_connect("localhost","mapserver","cisco123");
	if (!$con)
        {
	        die('Could not connect: ' . mysql_error());
        }

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
		$node_ip=mysql_fetch_array( mysql_query( "select ipv6_address from node_ip where fabfi_number = '".$node_fabfi_number."'"));
		$node_ip=$node_ip['ipv6_address'];

		//Finally, generate required Javascript to place a marker
		
		echo "addNodeMarker(new google.maps.LatLng(" . $node_coordinates ."),". $node_icon .",".$row['cacti_index'].");\n" ;



		// Draw Lines

		$three_minutes_ago=date("Y-m-d H:i:s",time()-180);

		$links=mysql_query("select * from links where timestamp >='".$three_minutes_ago."' AND source_ip = '".$node_ip."'");

		while ($result = mysql_fetch_array($links) )
		{
			$cost=$result['cost'];
			
			$neigh_fabfi_number=mysql_fetch_array( mysql_query("select fabfi_number from node_ip where ipv6_address = '".$result['dest_ip']."' limit 1" ) );  
			$neigh_fabfi_number=$neigh_fabfi_number['fabfi_number'];
			$neigh_details=mysql_fetch_array ( mysql_query("select `latitude`,`longitude`,`type` from node where fabfi_number = '".$neigh_fabfi_number."'"));
			$neigh_coordinates=$neigh_details['latitude'].", ".$neigh_details['longitude'];
			$neigh_type=$neigh_details['type']. "_NODE";
	
			$conntype=$node_type."to".$neigh_type;
	
			//generate javascript for a line - first check that we've not drawn this line before.

			if (! in_array($node_coordinates.$neigh_coordinates,$lines_array) && ! in_array($neigh_coordinates.$node_coordinates,$lines_array) ){
echo "addLine(new google.maps.LatLng(".$node_coordinates."), new google.maps.LatLng(".$neigh_coordinates."),".$cost.",".$conntype.");\n";
				array_push($lines_array, $node_coordinates.$neigh_coordinates);
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

<?php
mysql_close($con);
?>

</body>
</html>
