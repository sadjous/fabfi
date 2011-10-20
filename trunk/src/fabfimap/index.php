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

var nairobi = new google.maps.LatLng(-1.27872, 36.81696);
var capetown = new google.maps.LatLng(-1.27872, 36.81696);
var farmschool = new google.maps.LatLng(42.610109, -72.254945);

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

// End Shapes

	var contentString = "<a href='http://www.uonbi.ac.ke'>Uonbi</a>";
	
	var line1 = [ fablab, taifa ]; 

	var line2 = [ taifa, awing ]; 

	var line3 = [ awing, fablab ];

  var flightPath = new google.maps.Polyline({
    path: line1,
    strokeColor: "#FF0000",
    strokeOpacity: 0.5,
    strokeWeight: 2
  });


  var flightPath2 = new google.maps.Polyline({
    path: line2,
    strokeColor: "#FF0000",
    strokeOpacity: 0.2532,
    strokeWeight: 2

  });


  var flightPath3 = new google.maps.Polyline({
    path: line3,
    strokeColor: "#FF0000",
    strokeOpacity: 1.0,
    strokeWeight: 2
});
	
function initialize_map() {

	var mapOptions = {
		zoom: 12,
		center: nairobi,
		mapTypeId: google.maps.MapTypeId.ROADMAP
		};

	map = new google.maps.Map(document.getElementById("map_canvas"),mapOptions);

	<?php

	$con = mysql_connect("localhost","mapserver","cisco123");
	if (!$con)
        {
	        die('Could not connect: ' . mysql_error());
        }

	mysql_select_db("meshmib", $con);

	$query=mysql_query("SELECT * FROM  `node` LIMIT 0 , 30");

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

		//Finally, generate required Javascript
		echo "addNodeMarker(new google.maps.LatLng(" . $node_coordinates ."),". $node_icon .",".$row['cacti_index'].");" ;
	}

	?>
}

function addNodeMarker(location,node_icon,cactiID) {
	marker = new google.maps.Marker({
	position: location,
	map: map,
	icon: node_icon
	
	});
	nodeArray.push(marker);
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
