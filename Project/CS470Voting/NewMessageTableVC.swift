//
//  NewMessageTableVC.swift
//  CS470Voting
//
//  Created by Joe Mogannam on 5/6/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class NewMessageTableVC: UITableViewController {
    let cellID = "NewMsgCellID"
   
    
    var userToWriteTo = aFirebaseUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        //allFireUsersPulled = [aFirebaseUser]()
        //gFetchAllFirebaseUsers(selfSender: self)
        
        
        
       
        
        
        
       
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //print("count of ussers pulled" ,allFireUsersPulled.count)
        return allFireUsersPulled.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // NOTE IM NOT USING MY OWN CELL CLASS HERE
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        
        let tempFireUser = allFireUsersPulled[indexPath.row]
        cell.textLabel?.text = tempFireUser.account_nickname
        cell.detailTextLabel?.text = tempFireUser.account_email
        
        // Configure the cell...

        return cell
    }
    
    //var chatController: ChatTableVC?
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*dismiss(animated: true) { // original tutorial code dosent work
            //self.chatController?.segueChatToChatLog()
            //self.navigationController?.pushViewController(self.chatController!, //animated: true)
            
            //self.performSegue(withIdentifier: "newMsgToChatLog", sender: self)
        }*/
    
        userToWriteTo = allFireUsersPulled[indexPath.row]
        print("in new message user to write to \(userToWriteTo.account_nickname) | looked ", allFireUsersPulled[indexPath.row].account_nickname )
        //self.performSegue(withIdentifier: "newMsgToChatLog", sender: self) // old code I wrote delete
    
    
        let TempChatLogController = storyboard?.instantiateViewController(withIdentifier: "chatLogStoryBoardID")  as!ChatLogTableVC
        TempChatLogController.setWhoToWriteTo(userToWriteTo)
        self.navigationController?.pushViewController(TempChatLogController ,animated: true)
    
    
    }
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "newMsgToChatLog"{
            let TempChatLogController = storyboard?.instantiateViewController(withIdentifier: "chatLogStoryBoardID")  as!ChatLogTableVC
            
            
            TempChatLogController.setWhoToWriteTo(userToWriteTo)
        }

        
        
        
    }*/
    

}
