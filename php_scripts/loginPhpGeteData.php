<?php
	require_once('connectionInfo.php'); 
	$host = connectionInfo::$host;
        $user =  connectionInfo::$user;
        $mysqlPassword =  connectionInfo::$mysqlPassword;

        $connection = mysql_connect($host,$user,$mysqlPassword);

        $username = htmlentities($_POST["username"]); //$_POST['a'];
        $password = htmlentities($_POST["password"]);  //$_POST['b'];
	
	function dbgFile($email, $password){
		// loginDbg.txt
		$myfile = fopen("dbgLogin.txt", "w") or die("Unable to open file!");
		$txt = "$username, $password";
		fwrite($myfile, $txt);
		fclose($myfile);	
	}


	function creatJSON($array){
		$data = $array;
		$jsontext = "[{";
		foreach($data as $key => $value) {
    			$jsontext .= "\"".addslashes($key)."\": \"".addslashes($value)."\",";
		}
		$jsontext = substr_replace($jsontext, '', -1); // to get rid of extra comma
		$jsontext .= "}]";

		echo $jsontext;
	}


	//dbgFile($username,$password);	
	$returnValue = array();

	// check if all fields filled out
	if(empty($username) || empty($password))
	{
		$returnValue["status"] = "empty";
		$returnValue["message"] = "Missing required field";
		
		//echo (creatJSON($returnValue));
		echo json_encode($returnValue);//json_encode($returnValue);
		return;
	}

	





	// begin code to get data from database
        if(!$connection){
                die('Connection failed');
        }
        else{
                $dbconnect = @mysql_select_db('mogannam', $connection);

                if(!$dbconnect){
                        die('Could not connect to database');
                }
                else{
                        $query = "select * from mogannam.users where username='$username'";
			$resultSet = mysql_query($query, $connection);

			$records = array();
			while($r = mysql_fetch_assoc($resultSet)){
				$records[] = $r;
			}
			
                       
                        //echo 'Successful querry';
                        //echo json_encode($records);
                }
        }
	// end run mysql code to get data from database

	// if mysql code gives back valid record
	if(!empty($records)){
		$returnValue["status"] = "Success";
		$returnValue["message"] = "User is Registered";
		$returnValue["query"] = $query;
		$returnValue["qResults"] = $records;
		
		echo json_encode($returnValue);
	}
	else { // if mysql code has no record for username
		$returnValue["status"] = "tryAgain";
		$returnValue["message"] = "User is not found";
		$returnValue["query"] = $query;
		
		//echo creatJSON($returnValue);//json_encode([$records]);
		echo json_encode($returnValue);
	}
	

?>
