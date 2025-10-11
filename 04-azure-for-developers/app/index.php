<!doctype html>

<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width" />
        <title>Top 10 cities in Bulgaria</title>
        <link rel="stylesheet" type="text/css" href="/index.css" media="screen">
    </head>
    <body>
        <div class="container">
<?php
	// CONNECTION INFORMATION BELLOW
    $connectionOptions = array("UID" => "sqladminuser", "PWD" => "New_123123", "Database" => "hw-m4-db", "LoginTimeout" => 30, "Encrypt" => 1, "TrustServerCertificate" => 0); 
    $serverName = "tcp:hw-m4-db-srv.database.windows.net,1433"; 
    $conn = sqlsrv_connect($serverName, $connectionOptions);

    if ($conn) {
        $cityid = random_int(1, 10);
        $stmt = sqlsrv_query($conn, "SELECT * FROM Cities WHERE ID=".$cityid);

        if ($stmt) {
            while($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
                print "<div class=\"item\" id=\"item-city\">".$row['CityName']."</div>\n";
                print "<div class=\"item\" id=\"item-population\">".$row['Population']."</div>\n";
                print "<div class=\"item\" id=\"item-note\">Refresh for more ...</div>\n";
           }
        }
        else {
            print "<div class=\"item\">\n";
            print "ERROR: <br />\n";
            print_r(sqlsrv_errors(), false);
            print "</div>\n";
        }
    }
    else {
        print "<div class=\"item\">\n";
        print "ERROR: <br />\n";
        print_r(sqlsrv_errors(), false);
        print "</div>\n";
    }
?>
        </div>
    </body>
</html>