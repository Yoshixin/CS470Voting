//
//  RegisterViewController.swift
//  CS470Voting
//
//  Created by Joe Mogannam on 4/19/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit


class RegisterViewController: UIViewController {
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    //2nd password is to verify user passwords match in register process
    @IBOutlet weak var userPasswordCheck: UITextField!
    
    var responseString = NSString()
    
    
    @IBAction func RegisterButtonTapped(_ sender: Any) {
        // handler for when register button pressed
        
        // get inputed user details
        let email = userEmail.text
        let password = userPassword.text
        let passwordCheck = userPasswordCheck.text
        
        // check for empty fields
        if ((email?.isEmpty)! ||  ((password?.isEmpty)!)  ||
            (passwordCheck?.isEmpty)!) {
            // display error message
             DispatchQueue.main.async{self.displayMSG("A Register field was empty ", "Ooops!") }
            return; // return, stops user from continuing
        }
        
        // check if passwords match
        if password != passwordCheck {
            // display error message
            DispatchQueue.main.async{self.displayMSG("Your Passwords dont match!", "try again!" )}
            return;
        }
        
        
        
        //"https://www.cs.sonoma.edu/~kooshesh/cs470/tracks_human_readable.json"
        
        // currently the php script to inseert data is on my blue account
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.cs.sonoma.edu/~mogannam/registerPhpStoreData.php")! as URL)
        
        
        // bundle up data needed by script in POST method
        request.httpMethod = "POST"
        let postString = "a=\(email!)&b=\(password!)"
        
        // actually bundeling up done
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        
       // ++++++++ WARNING THREADED +++++++++
        // one thing to note is that the code in the pluses runs on its own thread apparently.
        // so you have to be careful when saving data to global variables because any code after the threaded part
        // when accessing global data may or may not have valid values yet.
        
        // also because this code is threaded, display messages, and other function have to be forced to execute
        // on the main thread. So if you see code wrapped in a function like so "DispatchQueue.main.async{ }", thats what is going on
        // You probably noticed the "DispatchQueue.main.async{} " in previous code before threading that was just to be safe.
        
        
        // also because its thread becareful about this block of code having its own scoped variables.
        // For example: say you have a global variable "G". To use it you need to use self.G in this code block
        // If you just use it like "G = 5", than it could use its own scoped variable instead.
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){  // attempt to connect with the php script
            data, response, error in
            // I believe this let structure is using the format of "completion handler"
            // my basic understanding is: data contains the response the script outputs back to swift,
            // response is used by swift to generate message based on what happens when communication with the script,
            // error will contain hopefully an error code/message that swift generates when the connection fails
            

            
            
            print("\n\n data is : ", data)
            print("\n \n response is :", response)
            print("\n \n error is : ", error)
            
            // if the connection fails to even connect at all
            if error != nil {
                print("error:", error ?? "**No response revievd**" )
                return;
            }
            
            print("\n\n\ndata: ",data!, "\n \n error: ", error)
            
            print("response: ", response ?? "**No response revievd**")
            
            
            // converts what the php script sends back as "good" data to something swift can read (aka of type NSString )
            // generally my understanding is you can convert it to either a NSString, a NSArray, or NSDictionary, but
            // what you can actually convert it to is dependent on what the php script sends back
            var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            // this php script returns a one line string message to indicate if a push of data was 
            // succesful or not.
            // One thing to note is the "duplicate" message can be sent out of an error occures when inserting
            // I don't know how to seperate a duplicate error from other errors in php. However
            // i have never noticed recieving the duplicate response, and having it be something else
           
            
            
            
            print("responseString (1): ", responseString! ?? "**No, response recieved**")
            
            
            // if you successfully insert a new user into database
            if responseString! == "success"{
             
                DispatchQueue.main.async{ // force the message onto the main thread
                    self.displayMSG("Thank You For Registering!", "Congrats!" )
                    
                
                }
                
                
                
            }
            else if responseString! == "duplicate"{
                // if user already exists (or possibly other error occured. Read explenation above)
                
                DispatchQueue.main.async{ // force the message onto the main thread
                    self.displayMSG("User already Registered!", "Sorry!!" )
                    
                    
                }
                return;
                
            }
            else{
                // a different response string was sent back or nothing at all
                
                DispatchQueue.main.async{ // force the message onto the main thread
                    self.displayMSG("An error occured in registering!", "Sorry!!" )
                    
                    
                }
                print("**Error in registering user **")
                return;
                
            }
            
            
        }
        task.resume() // my basic understanding is that this line of code can resume the download if a conection error ocures
        // for example say the connection timed out, everything fails, so the thread for downloading comes back to the main thread.
        // I believe when this line of code is hit & if a time out error is recieved the swift code knows to re attempt the download
        
         // ++++++++ WARNING END OF THREADING +++++++++
        
        
       
        

        
        
        
      
        
        
 
        
    }
    
    
    func displayMSG(_ myMessage: String, _ myTitle: String){
        let myAlert = UIAlertController(title:myTitle, message: myMessage,
                                        preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title:"myTitle", style: UIAlertActionStyle.default, handler: nil);
        
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated:true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}






// similar code to a php tutorial to push data but it is old code & I don't know how to fix
// saved just in case we need it 
/* // video 3, 12:00 min
 // packagae up the data to be pushed to database
 let myURL = NSURL(string: "https://www.cs.sonoma.edu/~mogannam/public_html/cs470Project/userRegister.php")
 let request = NSMutableURLRequest(url: myURL as! URL)
 request.httpMethod = "POST"
 
 let postString = "email=\(email)&password=\(password)"
 request.httpBody = postString.data(using: String.Encoding.utf8)
 // end packaging data
 
 
 let task =   URLSession.shared.dataTask(with: request as URLRequest) {
 data, response, error in
 
 
 if error != nil {
 print("error: ", error ?? "no error")
 return;
 }
 var err: NSError?
 let  json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
 
 if let parseJSON = json{
 var resultValue = parseJSON["status"] as? String
 print("result: ", resultValue)
 
 var isUserRegistered = false;
 if resultValue == "Success" { isUserRegistered = true}
 
 var messageToDisplay = parseJSON["message"] as String!
 if !isUserRegistered {
 messageToDisplay = parseJSON["message"] as String!
 }
 }
 
 
 }
 */
