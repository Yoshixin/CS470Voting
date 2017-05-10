//
//  CreateGroupViewController.swift
//  CS470Voting
//
//  Created by student on 5/8/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {
    
    @IBOutlet weak var groupText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCreateButton(_ sender: UIButton) {
        print("Tapped the create button.")
        
        let groupName = groupText.text
        
        if ((groupName?.isEmpty)!) {
            // display error message
            //DispatchQueue.main.async{self.displayMSG("A Register field was empty ", "Ooops!") }
            print("empty for some reason")
            return; // return, stops user from continuing
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.cs.sonoma.edu/~mogannam/createGroup.php")! as URL)
        
        
        // bundle up data needed by script in POST method
        request.httpMethod = "POST"
        let postString = "group_name=\(groupName!)"
        
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
            
            
            
            
            //print("\n\n data is : ", data)
            //print("\n \n response of registering is :", response)
            //print("\n \n error is : ", error)
            
            // if the connection fails to even connect at all
            if error != nil {
                print("error:", error ?? "**No response received**" )
                
                return;
            }
            
            //print("\n\n\ndata: ",data!, "\n \n error: ", error)
            
            //print("response: ", response ?? "**No response revievd**")
            
            
            // converts what the php script sends back as "good" data to something swift can read (aka of type NSString )
            // generally my understanding is you can convert it to either a NSString, a NSArray, or NSDictionary, but
            // what you can actually convert it to is dependent on what the php script sends back
            var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            if responseString == "duplicate_group_name" {
                let myAlert = UIAlertController(title:"Duplicate Group!", message: "That group name already exists",
                                                preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title:"Okay", style: UIAlertActionStyle.default, handler: nil);
                
                myAlert.addAction(okAction)
                
                self.present(myAlert, animated:true, completion: nil)
                
                return;
            }
            
            // this php script returns a one line string message to indicate if a push of data was
            // succesful or not.
            // One thing to note is the "duplicate" message can be sent out of an error occures when inserting
            // I don't know how to seperate a duplicate error from other errors in php. However
            // i have never noticed recieving the duplicate response, and having it be something else
            
            //Script to create a group goes HERE
            
            
        }
        
        
        task.resume() // my basic understanding is that this line of code can resume the download if a conection error ocures
        // for example say the connection timed out, everything fails, so the thread for downloading comes back to the main thread.
        // I believe when this line of code is hit & if a time out error is recieved the swift code knows to re attempt the download
        
        // ++++++++ WARNING END OF THREADING ++++++++
        let myAlert = UIAlertController(title:"Group Created!", message: "You can find your new group on the list of groups",
                                        preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title:"Okay", style: UIAlertActionStyle.default, handler: { action in
            let tempGroupCOntroller = self.storyboard?.instantiateViewController(withIdentifier: "GroupsWithButtonVC")  as! GroupsWithButtonVC
            
            
            // transition to ChatLogTableVC and display message thread for this user and you
            self.navigationController?.pushViewController(tempGroupCOntroller ,animated: true)

        
        }
        
        
        );
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated:true, completion: nil)
        
        
        
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
