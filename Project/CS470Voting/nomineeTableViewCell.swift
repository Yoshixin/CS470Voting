//
//  nomineeTableViewCell.swift
//  CS470Voting
//
//  Created by student on 4/17/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit


// an extension to get the view controller from a cell
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}







class nomineeTableViewCell: UITableViewCell {
    
    
  
    
    
    
    var chosenNomineeId = -1
    
    @IBOutlet weak var nomineeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
    
    
   /*
    // button to vote for user
    @IBAction func chooseNominee(_ sender: Any) {
        print("in button n id: ", chosenNomineeId )
        
        let url =  "https://www.cs.sonoma.edu/~mogannam/chooseNominee.php"
        
        
        
        let postString = "account_id=\(logedInId)&category_id=\(chosenCategoryId)&nominee_id=\(chosenNomineeId)"
        print(postString)
        
        // currently the php script to inseert data is on my blue account
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        
        // bundle up data needed by script in POST method
        request.httpMethod = "POST"
        
        // I dont belive the php script uses the category_id anymore since we changed the script
        // to always pull all data
        
        // account_id, category_id, nomine_id
        //let postString = "account_id=\(logedInId)&category_id=\(catId)" //"a=\(email!)&b=\(password!)"
        
        // actually bundeling up done
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        
        
        
        // ++++ Waring start of threading ++++
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            // I believe this let structure is using the format of "completion handler"
            // my basic understanding is: data contains the response the script outputs back to swift,
            // response is used by swift to generate message based on what happens when communication with the script,
            // error will contain hopefully an error code/message that swift generates when the connection fails
            
            // used to insert new data in our dictionary,
            print("after")
            
            
            // check if the connection is even possible
            if error != nil {
                print("\n error: ", error ?? "no error explenation given")
                return;
            }
            
            
            var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            
            // attempt to retrive data from database
            do {
                
                // converte the data response from php script to json array
                
                //print("before response")
                
                var json = data//(try JSONSerialization.jsonObject(with: data!, //options: .mutableContainers) as? NSString)!
                
                
                
                //get nomineeTableVC from sthe extension at top of file
                let tempNomineeTableVC = self.parentViewController as? nomineeTableVC
                
             
                
                
                //print(responseString)
                print(responseString!)
                // the server includes  extra qoutation marks in the string of responseString
                // so for string comparison we need to include them when comparing
                
                
                
                if responseString == "\"success\"" {
                    
                    
                    DispatchQueue.main.async(execute: {
                        
                        gDisplayMSG( myMessage: "We saved your vote",  myTitle: "Thank you for voting", sendSelf : tempNomineeTableVC! as! nomineeTableVC )
                    })
                    
                    
                    
                    
                }
                else if(responseString == "\"succesfully replace\""){
                   DispatchQueue.main.async(execute: {
                        gDisplayMSG( myMessage: "We changed your vote",  myTitle: "Thank you for voting", sendSelf : tempNomineeTableVC! as! nomineeTableVC)
                    })
                     
                }
                else {
                    DispatchQueue.main.async(execute: {
                        gDisplayMSG( myMessage: "Try voting again.",  myTitle: "Sorry, an Error ocured", sendSelf : tempNomineeTableVC! as! nomineeTableVC)
                    })
                }
                
                
                
                if let parseJson = json as? NSString  { // unwrap json as an NSArray
                    // parjson will contain an array of Json Dictionaries
                    // each dictionary represents 1 category stored on database
                    
                    
                    
                    globalPushFunctionMsg =  String(parseJson)
                    
                    
                    
                }
                globalPushFunctionMsg =  "No string from php"
                
                
                // reload the data b/c we are changin cell color
              
                
                
                
                
            }
            catch let caughtError as NSError {
                print("caught error: ", caughtError)
                return;
            }
            
        }
        
        
        
        task.resume()
        
        
        
    }*/
    
    
    func useNominee(_ nominee: String, _ nominee_id : Int ) {
        /*if let aImage = artist.getImage()  {
         cellImage.image = aImage
         }*/
        print("dbg in use nominee")
        chosenNomineeId = nominee_id
        
        nomineeName.text = nominee
        
        
    }
    
    
   
    
    
    
}
