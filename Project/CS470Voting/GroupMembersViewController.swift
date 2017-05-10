//
//  GroupMembersViewController.swift
//  CS470Voting
//
//  Created by student on 5/8/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class GroupMembersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    //  a variable to hold original json data from script in case its needed in future
    var json = NSArray()
    
    var groupID = -1
    
    //variables for handling all members
    var members = [String]()
    var memberIds = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadMembers()
        
        // Do any additional setup after loading the view.
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func setgroupID(_newID: Int) {
        groupID = _newID
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapJoinButton(_ sender: UIButton) {
        print("Tapped the join button.")
        
        // a script that will be used to save the user votes
        let url =  "https://www.cs.sonoma.edu/~mogannam/joinGroup.php"
        
        let postString = "group_id=\(groupID)&account_id=\(logedInId)"
        print(postString)
        
        // currently the php script to inseert data is on my blue account
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        // bundle up data needed by script in POST method
        request.httpMethod = "POST"
        
        // actually bundeling up done
        request.httpBody = postString.data(using: String.Encoding.utf8)
        // cast the vote to the database
        // ++++ Waring start of threading ++++
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
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            // attempt to cast vote
            do {
                let json = data//(try JSONSerialization.jsonObject(with: data!, //options: .mutableContainers) as? NSString)!
                print("vote response message", responseString!)
                // the server includes  extra qoutation marks in the string of responseString
                // so for string comparison we need to include them when comparing

                if responseString == "\"success\"" {
                    // let user know they joined
                    DispatchQueue.main.async(execute: {
                        gDisplayMSG( myMessage: "You are now a member of this group",  myTitle: "Group joined!", sendSelf : self )
                    })
                }// let user know they were in group
                else if(responseString == "\"succesfully replace\""){
                    DispatchQueue.main.async(execute: {
                        gDisplayMSG( myMessage: "You're already a member of this group",  myTitle: "Note:", sendSelf : self )
                    })
                }// an error occured let user know
                else {
                    DispatchQueue.main.async(execute: {
                        gDisplayMSG( myMessage: "Try joining again.",  myTitle: "Sorry, an Error ocured", sendSelf : self )
                    })
                }
                self.tableview.reloadData()
                globalPushFunctionMsg =  "No string from php"
            }
            catch let caughtError as NSError {
                print("caught error: ", caughtError)
                return;
            }
        }
        task.resume()

        
    }
    
    //Table view data sources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        
        //let allGroups = groups
        let allMembers = members
        var member = ""
        
        if let theCell = cell as? GroupMembersViewCell {
            member = (allMembers[indexPath.row] as? String)!
            theCell.useMember(member)
        }
        
        return cell
    }
    //end of table view data sources
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     }
     */
    
    func downloadMembers()  {
        // currently the php script to inseert data is on my blue account
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.cs.sonoma.edu/~mogannam/membersOfGroup.php")! as URL)
        
        // bundle up data needed by script in POST method
        request.httpMethod = "POST"
        //we don't need to send any parameters for this php script, so leave post string empty
        let postString = "groupID=\(groupID)"
        // actually bundeling up done
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        // ++++ Waring start of threading ++++
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
            // attempt to retrive data from database
            do {
                
                // converte the data response from php script to json array
                self.json = (try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray)!
               
                if let parseJson = self.json as? NSArray  { // unwrap json as an NSArray
                    // parjson will contain an array of Json Dictionaries
                    // each dictionary represents 1 category stored on fatabase
                    // loop through all categories.
                    if(parseJson.count > 0) {
                        for index in 0 ... parseJson.count - 1 {
                            var tempData = parseJson[index] as! NSDictionary
                           
                            // get the category name as a string
                            var memberName = tempData["account_nickname"] as! String
                            var memberId = tempData["account_id"] as! String
                            var tempId = Int(memberId)
                            self.memberIds.append( tempId!)
                            self.members.append( memberName)
                        }
                    }
                    self.json = parseJson;
                    print(self.members)
                    print("server done")
                }
                // *** Important Code ****
                // this code is needed to update the table view controller
                // since this code runs on its own thread, there is potential of the
                // view controller loading before the data was even donloaded resulting in an empty view controller
                // So at the end of the download we need the view controller to update itself
                DispatchQueue.main.async(execute: {
                    self.tableview.reloadData()
                })
            }
            catch let caughtError as NSError {
                print("caught error: ", caughtError)
                return;
            }
        }
        task.resume()
    }
    
}
