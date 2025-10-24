<h1>Voting Time! Which one you like most?</h1>
<h2>Results so far</h2>
<?php
require_once ('config.php');

if( $conn === false ) {
  die( print_r( sqlsrv_errors(), true));
}

$stmt = sqlsrv_query( $conn, "SELECT voteoption, COUNT(*) votecnt FROM votecasts GROUP BY voteoption ORDER BY 2 DESC");

if( $stmt === false ) {
  die( print_r( sqlsrv_errors(), true));
}

print "<ol>\n";

while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC) ) {
  print "<li>".$row['voteoption']." (".$row['votecnt'].")</li>\n";
}

print "</ol>\n";

print "<small>Processed by <b>".gethostname()."</b> on ".date('Y-m-d-H-i-s')."</small>\n";
?>