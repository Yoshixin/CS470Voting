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

    override func viewDidLoad() {
         gCheckFirebaseUserLogin(self, "chat")
        
        super.viewDidLoad()
        
        
        allFireUsersPulled = [aFirebaseUser]()
        gFetchAllFirebaseUsers(selfSender: self)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // reset the array to empty b/c each time we transition between the chat table view cntroller
        // to the new message view controller it will populate this array with duplicate data
        //allFireUsersPulled = [aFirebaseUser]()
        
        
        
        let penImage = UIImage(named: "compose-nav-button.png")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: penImage, style: .plain, target: self, action: #selector(handleNewMessage))
        
        let myRectangle = CGRect(x: 0, y: 0, width: 50, height: 50)
        let myChatLogButtonCentered = UIButton(frame: myRectangle)
         myChatLogButtonCentered.alpha = 1
        myChatLogButtonCentered.addTarget(self, action: #selector(segueChatToChatLog), for: .touchUpInside)
        myChatLogButtonCentered.backgroundColor = UIColor.blue
 
        
        //self.navigationItem.titleView = myChatLogButtonCentered
        
      
      
        self.navigationItem.title = FireBaseUser.account_nickname
        
        //observeMessages() no longer used b/c we fixed a bug that showed the wrong messages for the wrong user
        
        observeOneUsersMessages()
        
        
        
    }
    
    // grab only newwest mesage for per 1 user i wrote to
    var allMessages = [aMessageObject]()
    // grab only one message to be displayed on chatTableViewController
    var allMessagesDict = [String: aMessageObject]() // will hold just one message
    
    func observeOneUsersMessages(){ // called observeUserMessages in tutorial
        
        guard let currFireUserId = FIRAuth.auth()?.currentUser?.uid else {
            //if fails the function is exited
            return
        }
        
        
        
     
        let ref = FIRDatabase.database().reference().child("user-messages").child(currFireUserId)
        
        ref.observe(.childAdded, with: { (allMsgsPulled) in
            //
            
            let messageIDPulled = allMsgsPulled.key
            
            let messagesRefrence = FIRDatabase.database().reference().child("messages").child(messageIDPulled)
            
            messagesRefrence.observe(.value, with: {(oneUsersMsgs) in
               
                // ***** code from old function observeMessages ****
                
                
                
                if let myMessageDict = oneUsersMsgs.value as? [String: AnyObject]{
                   
                    let myMessage = aMessageObject()
                    
                    myMessage.setValuesForKeys(myMessageDict)
                    //self.allMessages.append(myMessage)
                    
                    guard let chatPartnerID = myMessage.getChatPartnerID() else {
                        return // if fail exit
                    }
                    
                    //self.allMessagesDict[myMessage.toWriteTo] = myMessage
                    self.allMessagesDict[chatPartnerID] = myMessage
                    
                    // reconstruct array anytime you change the dictionary
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
    
        return allMessages.count
    }
    
    
    func searchForFireUserName(_ theId : String) -> aFirebaseUser?{
        for element in allFireUsersPulled {
            
            
            if element.account_id == theId {
                return element as aFirebaseUser
            }
        }
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        
        
        var chatPartnerId = oneMessage.getChatPartnerID()//String()
        
        /*if oneMessage.fromID == FIRAuth.auth()?.currentUser?.uid {
            // if the message id is the same as the current user id
            // the message should be sent to the partner
            // send message to someone else not logged in on this device
            chatPartnerId = oneMessage.toWriteTo
            
        }
        else {
            // else the message id != current user id
            // and the message should go to the reciver
            // the messgae should come to the user logged in on this device
            chatPartnerId = oneMessage.fromID
        }*/
        
        let IDMessageGoesTo = chatPartnerId
        
        
        let tempUserWrittingTo = searchForFireUserName(IDMessageGoesTo!)
        
        
        if let seconds = oneMessage.timeSTamp.doubleValue as? Double{
            let convertDate = NSDate(timeIntervalSince1970: seconds)
            
            
            let myformatedDate = DateFormatter()
            myformatedDate.dateFormat = "hh:mm:ss a"
            timeLabel.text = myformatedDate.string(for: convertDate)
        }
        // finish add a time label
        
        
        cell.textLabel?.text = tempUserWrittingTo?.account_nickname
        cell.detailTextLabel?.text = oneMessage.text
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // get curent messagfrom cell
        let currentMessage = allMessages[indexPath.row]
        
        
        
        
        
        // get an id from the message to look up
        guard let chatPartnerId = currentMessage.getChatPartnerID() else {
            return // else exit b/c it failed to get an id
        }
     
        // use the id from the message  to get all user data for this one id
        // currently we only have user ids
        let ref = FIRDatabase.database().reference().child("accounts").child(chatPartnerId)
        
        // pull users from firebase
        ref.observe(.value, with: { (getAllUsers) in
            
            //print(getAllUsers.value)
            
            // converte pulled user data object to dictionary
            guard let allUsersDict = getAllUsers.value as? [String : AnyObject] else{
                return // return is casting to ict fails
            }
            
            // creat the user from the dictionary
            let tempUser = aFirebaseUser()
            tempUser.setValuesForKeys(allUsersDict)
            tempUser.account_id = chatPartnerId
            
            // transition to chatLogTableView with this user pulled from Firebase DB
            let TempChatLogController = self.storyboard?.instantiateViewController(withIdentifier: "chatLogStoryBoardID")  as!ChatLogTableVC
             TempChatLogController.setWhoToWriteTo(tempUser)
             self.navigationController?.pushViewController(TempChatLogController ,animated: true)

            
            
        }, withCancel: nil)
        
     
        
        
        
    }
    
    
    
    
    
    
    func segueChatToChatLog() { // aka showChatController
       /* let chatLogController = ChatLogTableVC(collectionViewLayout: UICollectionViewFlowLayout())
        //navigationController?.pushViewController(chatLogController, animated: true)
        navigationController?.show(chatLogController, sender: self)*/
        

        let TempChatLogController = storyboard?.instantiateViewController(withIdentifier: "chatLogStoryBoardID")  as!ChatLogTableVC
        TempChatLogController.setWhoToWriteTo(FireBaseUser)
        self.navigationController?.pushViewController(TempChatLogController ,animated: true)

        
        
        
        //self.performSegue(withIdentifier: "chatTableCOntToChatLog", sender: self)
    }
    
    func handleNewMessage() {
        
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
        
        loggedInUser = theUser
    }

    func setChatControllerTitle (_ theUser: aUser){
        self.title = theUser.account_nickname
    }


}


// old method maybe not needed b/c we fixed a bug described above

/*
 
 
 func observeMessages(){
 let messgaeRefrence = FIRDatabase.database().reference().child("messages")
 
 messgaeRefrence.observe(.childAdded, with: { (amessagePulled) in
 
 if let myMessageDict = amessagePulled.value as? [String: AnyObject]{
 
 let myMessage = aMessageObject()
 
 myMessage.setValuesForKeys(myMessageDict)
 //self.allMessages.append(myMessage)
 self.allMessagesDict[myMessage.toWriteTo] = myMessage
 
 // reconstruct array anytime you change the dictionary
 self.allMessages = Array(self.allMessagesDict.values)
 self.allMessages.sort(by: {  (message1 , message2) -> Bool in
 //some code
 return message1.timeSTamp.intValue > message2.timeSTamp.intValue
 
 })
 
 
 //print("observing a message ", myMessage.text)
 
 DispatchQueue.main.async{
 self.tableView.reloadData()}
 
 }
 
 }, withCancel: nil)
 
 }
 
 
 
 
 
 }

 
 */




