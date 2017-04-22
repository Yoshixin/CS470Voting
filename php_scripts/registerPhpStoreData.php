<?php
	require_once('connectionInfo.php');
	
	$host = connectionInfo::$host;
	$user =  connectionInfo::$user;
	$mysqlPassword =  connectionInfo::$mysqlPassword;
	
		
		
	$connection = mysql_connect($host,$user,$mysqlPassword);

	$username = $_POST['a'];
	$password = $_POST['b'];
	function dbgFile($email, $password){
                // loginDbg.txt
                $myfile = fopen("dbgRegister.txt", "w") or die("Unable to open file!");
                $txt = "$username, $password";
                fwrite($myfile, $txt);
                fclose($myfile);
        }		
	//dbgFile($email, $password);

	if(!$connection){
		die('Connection failed');
	}
	else{
		$dbconnect = @mysql_select_db('mogannam', $connection);

		if(!$dbconnect){
			die('Could not connect to database');
		}
		else{
			$query = "insert into mogannam.users (username,password) values ('$username', '$password');";
			
			if (mysql_query($query,$connection) ) { //or die(mysql_error())) {
				$result = "success";
			}
			else{
				$result = "duplicate";
			}

			//echo 'Successful querry';
			//echo $result;
			echo $result;
		}
	}

	//echo $connection;
?>
