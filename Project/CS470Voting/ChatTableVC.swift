//
//  ChatTableVC.swift
//  CS470Voting
//
//  Created by Joe Mogannam on 5/6/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit
import Firebase
class ChatTableVC: UITableViewController {
    // home screen of chat function
    // will contain a button with a picture of a pen --> allows you to transition to NewMessageTableVC
            // allows you to select a new user to send a message to
    
    // will eventually contain a list of the most recent message sent to or from the user
    // clicking on a message in this list -> sends you to the 
            // chatLogTableVC --> a log of all messages between you and 1 other user
    

    override func viewDidLoad() {
         gCheckFirebaseUserLogin(self, "chat")
        
        super.viewDidLoad()
        
        // clear out this array b/c if you don't you will get duplicates
        // each time gFetchAllFirebaseUsers runs
        allFireUsersPulled = [aFirebaseUser]()
        //get all the potential firebase users you can chat with
        gFetchAllFirebaseUsers(selfSender: self)

        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // reset the array to empty b/c each time we transition between the chat table view cntroller
        // to the new message view controller it will populate this array with duplicate data
        //allFireUsersPulled = [aFirebaseUser]()
        
        
        // create pen image button to switch to NewMessageTableVC
        let penImage = UIImage(named: "compose-nav-button.png")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: penImage, style: .plain, target: self, action: #selector(handleNewMessage))
        
        let myRectangle = CGRect(x: 0, y: 0, width: 50, height: 50)
        let myChatLogButtonCentered = UIButton(frame: myRectangle)
         myChatLogButtonCentered.alpha = 1
        myChatLogButtonCentered.addTarget(self, action: #selector(segueChatToChatLog), for: .touchUpInside)
        myChatLogButtonCentered.backgroundColor = UIColor.blue
 
        
        //self.navigationItem.titleView = myChatLogButtonCentered
        
      
        // title this of the current user so you know who you are
        self.navigationItem.title = FireBaseUser.account_nickname
        
        //observeMessages() no longer used b/c we fixed a bug that showed the wrong messages for the wrong user
        
        // get one message per every user you have ever chatted with
        observeOneUsersMessages()
        
        
        
    }
    
    // an array to hold all messages I have sent or recieved
    var allMessages = [aMessageObject]()
    
    // holds only one message to be displayed on chatTableViewController
    // only newest mesage per 1 user I message with
    var allMessagesDict = [String: aMessageObject]() // will hold just one message
    
    // grab all messages between me and other users
    func observeOneUsersMessages(){ // called observeUserMessages in tutorial
        
        // get id of current firebase user, so that you can verify 
        // pulling data for this user is valid
        guard let currFireUserId = FIRAuth.auth()?.currentUser?.uid else {
            //if fails the function is exited
            return
        }
        
        
        
        // first get a refrence of the user-messages "table"
        // user-messages structure:
            // root node -> user-messages node -> UserID node -> (a list of message IDs)
        
        // in the end  user-messages : is supposed to pull a list of all message ID's one at a time
        // ever sent or recevied for this user
        let ref = FIRDatabase.database().reference().child("user-messages").child(currFireUserId)
        
        ref.observe(.childAdded, with: { (allMsgsPulled) in
            //pull the messageId's for one user
            
            //get one messageID per iteration of execution
            let messageIDPulled = allMsgsPulled.key
            
            // pull one message for this message ID
            let messagesRefrence = FIRDatabase.database().reference().child("messages").child(messageIDPulled)
            
            messagesRefrence.observe(.value, with: {(oneUsersMsgs) in
               
                // ***** code from old function observeMessages ****
                
                // converte one message pulled to a dictionary
                if let myMessageDict = oneUsersMsgs.value as? [String: AnyObject]{
                   
                    // converte the dictionary to a message object
                    let myMessage = aMessageObject()
                    
                    myMessage.setValuesForKeys(myMessageDict)
                    //self.allMessages.append(myMessage)
                    
                    // call a function to figure out who I am chatting with
                    // because a message has a toID & a FromID, we need to figure out
                    // who we are chatting with based on which user is logged in
                    guard let chatPartnerID = myMessage.getChatPartnerID() else {
                        return // if fail exit
                    }
                    
                    //self.allMessagesDict[myMessage.toWriteTo] = myMessage
                    // store the most recent message to or from this user in this dictionary
                    // to be displayed at the top of the ChatTableViewController
                    self.allMessagesDict[chatPartnerID] = myMessage
                    
                    // reconstruct array anytime you change the dictionary
                    // figure out which message to store first in the dictionary by comparing timeSTamps
                    // aka figure out which message is most recent
                    // this is done across all users most recent message,
                    self.allMessages = Array(self.allMessagesDict.values)
                    self.allMessages.sort(by: {  (message1 , message2) -> Bool in
                        //some code
                        return message1.timeSTamp.intValue > message2.timeSTamp.intValue
                        
                    })
                    
                    
                    DispatchQueue.main.async{
                        self.tableView.reloadData()}
                    
                }
                
               
                
                
                
                // **** ****
            }, withCancel: nil)
            
            
            
        }, withCancel: nil)
        
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // figure out how many cells to create
        return allMessages.count
    }
    
    
    func searchForFireUserName(_ theId : String) -> aFirebaseUser?{
        // find a specific firebaseUser based on FireBase ID
        for element in allFireUsersPulled {
            
            
            if element.account_id == theId {
                return element as aFirebaseUser
            }
        }
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a custom cell here instead of putting it in a file
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "messageCellID")
        
            // add a time label
            let timeLabel = UILabel()
            timeLabel.text = "HH:MM:SS"
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // set location of time label in each cell
            // x,y w, h
        
            cell.addSubview(timeLabel)
        
            timeLabel.backgroundColor = UIColor.clear
            timeLabel.textColor = UIColor.darkGray
            timeLabel.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
            timeLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            timeLabel.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
            timeLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
            timeLabel.font = UIFont.systemFont(ofSize: 12)
        
        
        
        
        
        var oneMessage = allMessages[indexPath.row]
        
        //get id of person you are chatting with in this "message cell"
        var chatPartnerId = oneMessage.getChatPartnerID()//String()
        
        // figure out who I can send a message to 
        // since I can click on this message in the ChatTableViewController
        // & open the the CHatLogTableViewCOntroller to bring up all messages in
        // this "message thread"
        let IDMessageGoesTo = chatPartnerId
        
        // based on ID figure out who I am chatting with
        // because when I transistion to the ChatLogTableViewCOntroller I can display
        // that users name as the title
        let tempUserWrittingTo = searchForFireUserName(IDMessageGoesTo!)
        
        
        //converte the firebase time stamp on the message to something more human readable
        // basically the date is originally a number of the seconds from the year 1970 occured
        // so we need to convert that  to hh:mm:ss
        if let seconds = oneMessage.timeSTamp.doubleValue as? Double{
            let convertDate = NSDate(timeIntervalSince1970: seconds)
            
            let myformatedDate = DateFormatter()
            myformatedDate.dateFormat = "hh:mm:ss a"
            timeLabel.text = myformatedDate.string(for: convertDate)
        }
        // finish add a time label
        
        // set the main cell label text to user you are messaging with
        // than set the sub label of the cell to the message
        cell.textLabel?.text = tempUserWrittingTo?.account_nickname
        cell.detailTextLabel?.text = oneMessage.text
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // handles changing to the chatLogTableVC when a cell is tapped
        // aka the message thread between yourself and one other user
        
        // get curent messag from this cell on chatTableViewController
        let currentMessage = allMessages[indexPath.row]
        
        
        // get an id from the message to look up
        guard let chatPartnerId = currentMessage.getChatPartnerID() else {
            return // else exit b/c it failed to get an id
        }
     
        // use the id from the message  to get a user to chat with for this one id
        // currently we only have user ids -> but we want everything from firebase
        // we want user's: email, id, nick_name
        // we get this data from the accounts table
        let ref = FIRDatabase.database().reference().child("accounts").child(chatPartnerId)
        
        // pull user you are chatting with in this cell from firebase accounts table
        ref.observe(.value, with: { (getAllUsers) in
            
            
            
            // converte pulled user data object to dictionary
            guard let allUsersDict = getAllUsers.value as? [String : AnyObject] else{
                return // return is casting to ict fails
            }
            
            // creat the FirebaseUser from the dictionary
            let tempUser = aFirebaseUser()
            tempUser.setValuesForKeys(allUsersDict)
            tempUser.account_id = chatPartnerId
            
            // transition to chatLogTableView with this FirebaseUser pulled from Firebase DB
            let TempChatLogController = self.storyboard?.instantiateViewController(withIdentifier: "chatLogStoryBoardID")  as!ChatLogTableVC
             TempChatLogController.setWhoToWriteTo(tempUser) // set the user for the next controller -> aka ChatLogTableVC
            
            // transition to ChatLogTableVC and display message thread for this user and you
             self.navigationController?.pushViewController(TempChatLogController ,animated: true)

            
            
        }, withCancel: nil)
        
     
        
        
        
    }
    
    
    
    
    
    
    func segueChatToChatLog() { // aka showChatController
        // I don't think this is used anymore
        // but it can tranition from the ChatTableVC to the ChatLogTableVC
    
        let TempChatLogController = storyboard?.instantiateViewController(withIdentifier: "chatLogStoryBoardID")  as!ChatLogTableVC
        TempChatLogController.setWhoToWriteTo(FireBaseUser)
        self.navigationController?.pushViewController(TempChatLogController ,animated: true)

        
        
        
        //self.performSegue(withIdentifier: "chatTableCOntToChatLog", sender: self)
    }
    
    func handleNewMessage() {
        // handles transitioning from the ChatTableVC to NewMessageTableVC
        // when the "pen button" is pressed
        
        //let newMsgController = NewMessageTableVC()
        // done to give the NewMessageTableVC controller access
        // to the CHatTableController when the segue is activated
        //newMsgController.chatController = self
        
        performSegue(withIdentifier: "chatToNewMessage", sender: self)
        
    }


    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setLogedInuser(_ theUser : aUser){
        // don't think this is used anymore
        loggedInUser = theUser
    }

    func setChatControllerTitle (_ theUser: aUser){
        // don't think this is used anymore
        self.title = theUser.account_nickname
    }


}





