<?php

/*
Thanks to the Cacti guys -- Some functions included here have been heavily borrowed from Cacti's SNMP libs -- /usr/share/cacti/site/lib/snmp.php
*/

define("REGEXP_SNMP_TRIM", "(hex|counter(32|64)|gauge|gauge(32|64)|float|ipaddress|string|integer):");

function format_snmp_string($string, $snmp_oid_included) {
	global $banned_snmp_strings;

	$string = eregi_replace(REGEXP_SNMP_TRIM, "", trim($string));

	if (substr($string, 0, 7) == "No Such") {
		return "";
	}

	if ($snmp_oid_included) {
		/* strip off all leading junk (the oid and stuff) */
		$string_array = explode("=", $string);
		if (sizeof($string_array) == 1) {
			/* trim excess first */
			$string = trim($string);
		}else if ((substr($string, 0, 1) == ".") || (strpos($string, "::") !== false)) {
			/* drop the OID from the array */
			array_shift($string_array);
			$string = trim(implode("=", $string_array));
		}else {
			$string = trim(implode("=", $string_array));
		}
	}

	/* return the easiest value */
	if ($string == "") {
		return $string;
	}

	/* now check for the second most obvious */
	if (is_numeric($string)) {
		return trim($string);
	}

	/* remove ALL quotes, and other special delimiters */
	$string = str_replace("\"", "", $string);
	$string = str_replace("'", "", $string);
	$string = str_replace(">", "", $string);
	$string = str_replace("<", "", $string);
	$string = str_replace("\\", "", $string);
	$string = str_replace("\n", " ", $string);
	$string = str_replace("\r", " ", $string);

	/* account for invalid MIB files */
	if (substr_count($string, "Wrong Type")) {
		$string = strrev($string);
		if ($position = strpos($string, ":")) {
			$string = trim(strrev(substr($string, 0, $position)));
		}else{
			$string = trim(strrev($string));
		}
	}

	/* Remove invalid chars */
	$k = strlen($string);
	for ($i=0; $i < $k; $i++) {
		if ((ord($string[$i]) <= 31) || (ord($string[$i]) >= 127)) {
			$string[$i] = " ";
		}
	}
	$string = trim($string);

	if ((substr_count($string, "Hex-STRING:")) ||
		(substr_count($string, "Hex-")) ||
		(substr_count($string, "Hex:"))) {
		/* strip of the 'Hex-STRING:' */
		$string = eregi_replace("Hex-STRING: ?", "", $string);
		$string = eregi_replace("Hex: ?", "", $string);
		$string = eregi_replace("Hex- ?", "", $string);

		$string_array = split(" ", $string);

		/* loop through each string character and make ascii */
		$string = "";
		$hexval = "";
		$ishex  = false;
		for ($i=0;($i<sizeof($string_array));$i++) {
			if (strlen($string_array[$i])) {
				$string .= chr(hexdec($string_array[$i]));

				$hexval .= str_pad($string_array[$i], 2, "0", STR_PAD_LEFT);

				if (($i+1) < count($string_array)) {
					$hexval .= ":";
				}

				if ((hexdec($string_array[$i]) <= 31) || (hexdec($string_array[$i]) >= 127)) {
					if ((($i+1) == sizeof($string_array)) && ($string_array[$i] == 0)) {
						/* do nothing */
					}else{
						$ishex = true;
					}
				}
			}
		}

		if ($ishex) $string = $hexval;
	}elseif (preg_match("/(hex:\?)?([a-fA-F0-9]{1,2}(:|\s)){5}/", $string)) {
		$octet = "";

		/* strip of the 'hex:' */
		$string = eregi_replace("hex: ?", "", $string);

		/* split the hex on the delimiter */
		$octets = preg_split("/\s|:/", $string);

		/* loop through each octet and format it accordingly */
		for ($i=0;($i<count($octets));$i++) {
			$octet .= str_pad($octets[$i], 2, "0", STR_PAD_LEFT);

			if (($i+1) < count($octets)) {
				$octet .= ":";
			}
		}

		/* copy the final result and make it upper case */
		$string = strtoupper($octet);
	}elseif (preg_match("/Timeticks:\s\((\d+)\)\s/", $string, $matches)) {
		//$string = $matches[1];
		$string_array=explode ( " " ,$string);
		$string=$string_array[2];
	}

#	foreach($banned_snmp_strings as $item) {
#		if(strstr($string, $item) != "") {
#			$string = "";
#			break;
#		}
#	}

	return $string;
}

?>
