//
//  LoginViewController.swift
//  CS470Voting
//
//  Created by Joe Mogannam on 4/19/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit



class LoginViewController: UIViewController {
    
    // text fields to get user data
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    
    // local variables to hold response/data from database
    
    //var emailPulled = String() // used to store credentials pulled from database
    var passwordPulled = String() // to check against users inputed credentials
    var emailPulled = String()
    var accountIdPulled = Int()
    var nickname = String()
    
    var resultValue = String() // contains the message to indicate how Mysql responds to the query
                            // will contain one of my custom reponse message from php script
                            // ex: success (aka credentials found, but are they right?) ,
                            // tryAgain (aka user not found), empty(aka a required filed is empty)
    
    
    
    // will eventually contain a single record from the database, after I parse it.
    var queryResults = NSArray()
    
    
    //  a variable to hold original json data from script in case its needed in future
    var json = NSDictionary() // contains everything sent bacl from script including : resultValue's dat & queryResults' data
    
    var isUserLoggedIn = false;
    
    
    // event handler for handleing when login button tapped
    @IBAction func LoginButtonTapped(_ sender: Any) {
        // handler for when loggin button pressed
       
        
        
       
        
        //get credentials from user
         email = userEmail.text!
         password = userPassword.text!
        
        
        // both fields must be filled out
        if ((email.isEmpty) || (password.isEmpty)) {
            DispatchQueue.main.async {self.displayMSG("Both Fields must be filled out! ", "Oops!")}
            
            
            return;
        }
        
        
        
        
        
        // supposed to send credentials to server, do validation on server
        // & server sends response. Based on response app repsonds
        // instead we are using the default user credentials stored on the device
        
        // where script is licated on blue
        let url = NSURL(string: "https://www.cs.sonoma.edu/~mogannam/loginPhpGeteData.php")
        let request = NSMutableURLRequest(url: url as! URL)
        
        // package up credentials to search database
        request.httpMethod = "POST"
        let postString = "account_email=\(email)&account_password=\(password)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        
        
        
        // ++++++++ WARNING THREADED  block of code+++++++++
        
        // one thing to note is that the code in the pluses runs on its own thread apparently.
        // so you have to be careful when saving data to global variables because any code after the threaded part
        // when accessing global data may or may not have valid values yet.
        
        // also because this code is threaded, display messages, and other function have to be forced to execute
        // on the main thread. So if you see code wrapped in a function like so "DispatchQueue.main.async{ }", thats what is going on
        // You probably noticed the "DispatchQueue.main.async{} " in previous code before threading that was just to be safe.
        
        
        // also because its thread becareful about this block of code having its own scoped variables.
        // For example: say you have a global variable "G". To use it you need to use self.G in this code block
        // If you just use it like "G = 5", than it could use its own scoped variable instead.
        let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
            // I believe this let structure is using the format of "completion handler"
            // my basic understanding is: data contains the response the script outputs back to swift,
            // response is used by swift to generate message based on what happens when communication with the script,
            // error will contain hopefully an error code/message that swift generates when the connection fails

            
            
            
            // check if the connection is even possible
            if error != nil {
                print("\n error: ", error ?? "no error explenation given")
                return;
            }
            
            //var err: NSError?
            //self.queryResults: NSArray
            
           // print("task: ",  URLSession.shared.dataTask(with: request as URLRequest) )
            //print("\n\n data: ", data)
            print("\n\n response: ", response)
            //print("\n\n initial error: ", error)
            
            
           
            // attempt to retrive data from database
            do {
                
                // converte the data response from php script to json dictionary
                 self.json = (try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary)!
                
                //print("json: ", json)
                
                
                if let parseJson = self.json as? NSDictionary  { // unwrap json 
                    
                    // get reult of query was it? , succesful search, no user found, error when searching, emoty field
                    self.resultValue = parseJson["status"] as! String
                    print("result of php script : ", self.resultValue )
                    
                   // print("\n ****\n", parseJson, "\n ****\n"  )
                    
                    // if a user was found, but still need to verify password matches
                    if self.resultValue == "Success"{
                       
                        
                        
                        // will contain a single record from the database
                        self.queryResults = (parseJson["qResults"]  as? NSArray)!
                        //UserDefaults.standard.set(self.resultValue, forKey: "resultValue")
                       
                        
                        
                        //print("\n ****\n", self.queryResults, "\n ****\n"  )
                        
                        // queryResults is an array of dictionaries, in this case it only ever has 1 element
                        // i just need the 1 dictionary
                        var tempResults = self.queryResults[0] as! NSDictionary
                        
                        
                        // set global variables, by parsing dictionary from queryResults
                        self.emailPulled = tempResults["account_email"] as! String;
                        self.passwordPulled = tempResults["account_password"] as! String;
                        let tempId = tempResults["account_id"] as! String;
                        self.nickname = tempResults["account_nickname"] as! String;
                        
                        //set potential current user data, 
                        // you can't use this user  data yet. unless they are logged in
                        // b/c you don't know if the credentials are right yet.
                        // If the credential are wrong than the user will be forced to login again
                        // and therfore these variables cleared out in the login proccess
                        loggedInUser.setValuesForKeys(tempResults as! [String : Any])
                       
                        // an id matching the username saved on the DB
                        self.accountIdPulled  = Int(tempId)!
                        
                        self.json = parseJson;
                        
                        
 
                        
                        
                        
                    }
                    // if a record is not found the only valid data sent back will be the resultValue message
                    // in this case queryResults will not even exists
                    self.json = parseJson;
                    //self.resultValue = (parseJson["status"] as? String)!;
                   
                    
                    
                    
                    
                    print("server done")
                    
                    
                }
                
                
                
                
                
            
            }
            catch let caughtError as NSError {
                print("caught error: ", caughtError)
                return;
            }
            
            // force the code to finish at same time as the main thread
            // check user inputed  credentials against pulled credentials
            DispatchQueue.main.async{self.check_credentials(email,password)}
            
        }
    
        task.resume() // my basic understanding is that this line of code can resume the download if a conection error ocures
        // for example say the connection timed out, everything fails, so the thread for downloading comes back to the main thread.
        // I believe when this line of code is hit & if a time out error is recieved the swift code knows to re attempt the download
        
        // ++++++++ WARNING END OF THREADING +++++++++

        
        return;
        
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func check_credentials(_ email : String, _ password : String){

        print("-- Checking credentials --")
       
    
        
        if self.resultValue == "tryAgain"{ // user nor found at all, inform user & do nothing
            DispatchQueue.main.async { self.displayMSG("Username not Found, try again!", "Sorry")}
            return;
            
        }
        else{ // user found but should check password, assuming resultValue message is success
            if(!(email.isEmpty) && !(password.isEmpty)){
                // if user entered both fields, we can check credentials if they match
                // if they match the variable isUserLoggedIn will be changed to true
                // and we can allow the login bellow
                self.attemptLogin(email, password, self.emailPulled, self.passwordPulled, self.resultValue, self.accountIdPulled)
            }
            
        }
        
        // allows login
        // initiate segue to home screen if login is valid
        if isUserLoggedIn {
            self.performSegue(withIdentifier: "LoginToHome", sender: self)
        }
    }
    
    
    
    func displayMSG(_ myMessage: String, _ myTitle:String){
        let myAlert = UIAlertController(title: myTitle, message: myMessage,
                                        preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.default, handler: nil);
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion: nil)
        
    }

  
    
    
    func attemptLogin (_ theEmail: String, _ thePassword: String, _ theEmailPulled: String,
                       _ thePasswordPulled: String, _ theresultValue: String, _ theIdPulled : Int) {
        
        //print("-- email: ",theEmail, "|| password: ",  thePassword, "|| passwordPulled :", thePasswordPulled, " -- ")
        
        // check for matching credentials
        if theEmail == theEmailPulled{
            
            if thePassword == passwordPulled{
                // sucesful login
                
                    
                //print("the user ", userEmail, "sucessfully loged in")
                
                // update firebase  logged in credentials for this user
                gUpdateLoginInfo(loggedInUser)
                
                // update our credentials for mysql user
                loggedInUser.account_email = theEmail
                loggedInUser.account_id = accountIdPulled
                loggedInUser.account_nickname = nickname
                
                
                // change the boolean var that screens if the user is allowed to login
                logedInId =  theIdPulled
                self.isUserLoggedIn = true
                
                
            }
            else   {
                // if passwords don't match and username do match
                // bad password don't login
                
                print(theresultValue)
                
                self.displayMSG("Wrong Password, try again!", "Sorry")
                
                return;
                
                
            }
           
        }
       
        else{
            // bad username don't login
            //UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            //UserDefaults.standard.synchronize()
            self.displayMSG("Wrong User Name, try again!", "Sorry")
            return;
        }
        
    }

    
    
    

}




