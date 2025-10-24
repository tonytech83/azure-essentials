<?php 
  if (!isset($_POST['vote']))
    header('Location: index.php');

  require_once ('config.php');

  if( $conn === false ) {
    die( print_r( sqlsrv_errors(), true));
  }

  $stmt = sqlsrv_query( $conn, "INSERT INTO votecasts (voteoption) VALUES ('".$_POST['vote']."')");

  if( $stmt === false ) {
    die( print_r( sqlsrv_errors(), true));
  }

  header('Location: result.php');
?>