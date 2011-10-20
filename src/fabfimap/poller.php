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
	"uptime"	=> "1.3.6.1.2.1.1.3.0",
	"neigh_ip"	=> "1.3.6.1.4.1.8072.1.3.2.12.4.1.2.12.78.101.105.103.104.98.111.117.114.95.73.80",	
	"neigh_lq"	=> "1.3.6.1.4.1.8072.1.3.2.14.4.1.2.12.78.101.105.103.104.98.111.117.114.95.76.81",
	"neigh_nlq"	=> "1.3.6.1.4.1.8072.1.3.2.16.3.1.4.13.78.101.105.103.104.98.111.117.114.95.78.76.81",
	"neigh_cost"	=> "1.3.6.1.4.1.8072.1.3.2.17.4.1.2.14.78.101.105.103.104.98.111.117.114.95.67.79.83.84",
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
	$host_ip=$result['ipv6_address'];
	$host_address="ipv6:[".$result['ipv6_address']."]";
	$fabfi_number=$result['fabfi_number'];
	$result = @snmp3_get ( $host_address , $snmp_auth_username ,  $sec_level ,  $auth_protocol , $auth_password , $priv_protocol ,  $priv_passphrase , $oids['uptime'], ($snmp_timeout*1000), $snmp_retries );
	
	if ( $result === false ) {		//We start with Uptime - Checking if the node is up. If this query fails, do nothing else.
		$result="";
	}
	else {
		//get uptime and update node database
		$result=format_snmp_string($result,$oids['uptime']);
		mysql_query("UPDATE  `meshmib`.`node` SET  `uptime` =  '".$result."' WHERE  `node`.`fabfi_number` =$fabfi_number");
		
		//get OLSR neighbours
		$neigh_ip = @snmp3_getnext ( $host_address , $snmp_auth_username ,  $sec_level ,  $auth_protocol , $auth_password , $priv_protocol ,  $priv_passphrase , $oids['neigh_ip'], ($snmp_timeout*1000), $snmp_retries );
		$neigh_ip=format_snmp_string($neigh_ip, $oids['neigh_ip']);
		
		$neigh_lq = @snmp3_getnext ( $host_address , $snmp_auth_username ,  $sec_level ,  $auth_protocol , $auth_password , $priv_protocol ,  $priv_passphrase , $oids['neigh_lq'], ($snmp_timeout*1000), $snmp_retries );
		$neigh_lq=format_snmp_string($neigh_lq, $oids['neigh_lq']);
		
		$neigh_nlq = @snmp3_getnext ( $host_address , $snmp_auth_username ,  $sec_level ,  $auth_protocol , $auth_password , $priv_protocol ,  $priv_passphrase , $oids['neigh_nlq'], ($snmp_timeout*1000), $snmp_retries );
		
		$neigh_nlq=format_snmp_string($neigh_nlq, $oids['neigh_nlq']);
		
		$neigh_cost = @snmp3_getnext ( $host_address , $snmp_auth_username ,  $sec_level ,  $auth_protocol , $auth_password , $priv_protocol ,  $priv_passphrase , $oids['neigh_cost'], ($snmp_timeout*1000), $snmp_retries );
		$neigh_cost=format_snmp_string($neigh_cost, $oids['neigh_cost']);

		mysql_query("INSERT INTO  `meshmib`.`links` (`index` ,`source_ip` ,`dest_ip` ,`lq` ,`nlq` ,`cost`,`timestamp`)VALUES (NULL ,'".$host_ip."','".$neigh_ip."','".$neigh_lq."','".$neigh_nlq."','".$neigh_cost."', NULL)");
				
		echo $neigh_ip."\n";
		echo $neigh_lq."\n";
		echo $neigh_nlq."\n";
		echo $neigh_cost."\n";
	}
}

mysql_close($con);

?>
