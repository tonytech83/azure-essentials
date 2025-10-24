<?php
	// CONNECTION INFORMATION START 
	$connectionInfo = array("UID" => "tonytech", "pwd" => "New_1234512345", "Database" => "DB", "LoginTimeout" => 30, "Encrypt" => 1, "TrustServerCertificate" => 0);
	$serverName = "tcp:prepexamdbserver.database.windows.net,1433";
	$conn = sqlsrv_connect($serverName, $connectionInfo);
	// CONNECTION INFORMATION END
?>
