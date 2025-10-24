<h1>Voting Time! Which one you like most?</h1>
<?php
require_once ('config.php');

if( $conn === false ) {
  die( print_r( sqlsrv_errors(), true));
}

$stmt = sqlsrv_query( $conn, "SELECT * FROM voteoptions");

if( $stmt === false ) {
  die( print_r( sqlsrv_errors(), true));
}

print "<form id=\"voteform\" name=\"voteform\" method=\"POST\" action=\"vote.php\">\n";

while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC) ) {
  print "<button name=\"vote\" type=\"submit\" value=\"".$row['optionname']."\">".$row['optionname']."</button>\n";
}

print "</form>\n";

print "<small>Processed by <b>".gethostname()."</b> on ".date('Y-m-d-H-i-s')."</small>\n";
?>