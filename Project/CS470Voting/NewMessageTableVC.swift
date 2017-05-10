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
   
   // hold a user who we chat with when a cell in this view is clicked
    var userToWriteTo = aFirebaseUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
       
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
        // loads all the possible users I can chat with from the global array allFireUsersPulled
        // this is set in the previous view ChatTableVC
        
        // NOTE IM NOT USING MY OWN CELL FILE HER, I build it programatically here
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        
        // pull one user per cell to display in the cell
        let tempFireUser = allFireUsersPulled[indexPath.row]
        
        // set cell data
        cell.textLabel?.text = tempFireUser.account_nickname
        cell.detailTextLabel?.text = tempFireUser.account_email
        
        // Configure the cell...

        return cell
    }
    
    //var chatController: ChatTableVC?
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // when user clicks on a cell they decided who they wanted to create a new message thread with
    
    
        // set who to creat a new ChatLogTableVC for
        userToWriteTo = allFireUsersPulled[indexPath.row]
        //print("in new message user to write to \(userToWriteTo.account_nickname) | looked ", allFireUsersPulled[indexPath.row].account_nickname )
        //self.performSegue(withIdentifier: "newMsgToChatLog", sender: self) // old code I wrote delete
    
        // get an instance of the ChatLogTableVC to transition to
        let TempChatLogController = storyboard?.instantiateViewController(withIdentifier: "chatLogStoryBoardID")  as!ChatLogTableVC
    
        // set the variable of who you are chating with in the ChatLogTableVC
        TempChatLogController.setWhoToWriteTo(userToWriteTo)
        // transition to the new ChatLogTableVC view
        self.navigationController?.pushViewController(TempChatLogController ,animated: true)
    
    
    }
    


}
