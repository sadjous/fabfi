<?php


/* do NOT run this script through a web browser */
if (!isset($_SERVER["argv"][0]) || isset($_SERVER['REQUEST_METHOD'])  || isset($_SERVER['REMOTE_ADDR'])) {
   die("<br><strong>This script is only meant to run at the command line.</strong>");
}

# deactivate http headers
$no_http_headers = true;

include("snmp_libs.php");

// OIDs

# define all OIDs we need for further processing
$oids = array(
	"uptime"         => "1.3.6.1.2.1.1.3.0",
	);

$snmp_port      = 161;                          
$snmp_timeout   = 500;                          
$snmp_retries   = 1;                            
$max_oids       = 1;
                  
# required for SNMP V3
$snmp_auth_username     = "fabfi-user";
$auth_password     = "cisco123";
$auth_protocol     = "SHA";
$priv_passphrase   = "cisco123";
$priv_protocol     = "AES";
$snmp_context           = "";

$object_id = $oids['uptime'];
$sec_level = "AuthPriv";


$con = mysql_connect("localhost","mapserver","cisco123");
        if (!$con)
        {
                die('Could not connect: ' . mysql_error());
        }

        mysql_select_db("meshmib", $con);

$node_ip_query = mysql_query("SELECT * FROM  `node_ip`");

//Start The Polling
while ($result = mysql_fetch_array($node_ip_query) )
{

	$host_address="ipv6:[".$result['ipv6_address']."]";
	$fabfi_number=$result['fabfi_number'];
	$result = @snmp3_get ( $host_address , $snmp_auth_username ,  $sec_level ,  $auth_protocol , $auth_password , $priv_protocol ,  $priv_passphrase , $oids['uptime'], ($snmp_timeout*1000), $snmp_retries );
	
	if ( $result === false ) {		//We start with Uptime - Checking if the node is up. If this query fails, do nothing else.
		$result="";
	}
	else {
		$result=format_snmp_string($result,$object_id);
		mysql_query("UPDATE  `meshmib`.`node` SET  `uptime` =  '".$result."' WHERE  `node`.`fabfi_number` =$fabfi_number");
	}
}

mysql_close($con);

?>
