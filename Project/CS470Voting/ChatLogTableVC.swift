//
//  ChatLogTableVC.swift
//  CS470Voting
//
//  Created by Joe Mogannam on 5/7/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit
import Firebase

class ChatLogTableVC: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {

    var whoAmIChattingWith = aFirebaseUser()
    let cellId = "chatLogCellId"
    
  
    
    
    
    // THIS IS NOT A  TableViewController B?C YOU CAN't pin sub View to the bottom of
    // a table view controller
    // So instead u need to use a UICollectionViewController and simulate a table view controller
    // by adding a TableViewController into this view & pin the button view (aka collectionView in code)
    // at bottom of UICollectionViewController
    
    
    // this function acts like a constructor to creat a custom textField
    // the handleSendButton function
    // this format of code is called a class property
    // also lazy var --> gives you acces to self when you dont have it
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message here ....."
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // alow enter button to send text
        textField.delegate = self
        

        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // make is so 1st buble message dosent go up right against top of nav bar
        // && make it so message don't go below send button bar
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 68, right: 0)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true// allows scrolling up/down
        
        // add custom text labe cell from file ChatMessageCollectionCell to collectionview cells
        collectionView?.register(ChatMessageCollectionCell.self, forCellWithReuseIdentifier: cellId)
        
        setupInputComponents()
        
        
        
        if whoAmIChattingWith.account_nickname != nil {
             navigationItem.title = whoAmIChattingWith.account_nickname
        }
        else{
            navigationItem.title = "Chat Log Controller"
        }
        
        // get one users messages for this chat log controller
        observeAllUsersMsgs()
        
        
    
    }
    
    var allMessages = [aMessageObject]()
    
    func observeAllUsersMsgs() {
        
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid else {
            return // else no user id existesd exit
        }
        
        
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(currentUserId)
        
        
        // first grab all ids in user-messages in amessagePulled, one at a time
        userMessagesRef.observe(.childAdded, with: { (amessageIdsPulled) in
            
            // next pull all messages for a specific message id
            let currentMessageId = amessageIdsPulled.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(currentMessageId)
            
            
            messagesRef.observeSingleEvent(of: .value, with: { (aMessage) in
                
                
                guard let aMessageDict = aMessage.value as? [String : AnyObject] else {
                    return
                }
                
                let message = aMessageObject()
                
                // will crash if keys in aMessageDict don't match keys of aMessageObject
                message.setValuesForKeys(aMessageDict)
                
                
                    //if message.fromID == FIRAuth.auth()?.currentUser?.uid
                    //&& message.toWriteTo == self.whoAmIChattingWith.account_id
                
                // MESSAGE SCREENING 1
                if (message.fromID == FIRAuth.auth()?.currentUser?.uid // if from me and chatting with right user
                    && message.toWriteTo == self.whoAmIChattingWith.account_id) ||
                    (message.toWriteTo  == FIRAuth.auth()?.currentUser?.uid && // if to me and from  right person
                         message.fromID == self.whoAmIChattingWith.account_id)
                     {
                    // only append the message if the message is from me and
                    // the message is to this specific user for my chatLog
                    
                    self.allMessages.append(message)
                
                    DispatchQueue.main.async{
                        self.collectionView?.reloadData()}
                    
                }
                
                
            }, withCancel: nil)
            
            
            
        }, withCancel: nil)
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMessages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //downcast a cell to our custom ChatMessageCollectionCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath ) as! ChatMessageCollectionCell
        //cell.backgroundColor = UIColor.blue
        
        //since we use a custom ChatMessageCollectionCell our viewCollectionCells now
        // contain a cell with a text label
        
        
        let message = allMessages[indexPath.row]
        cell.textView.text = message.text
        
        
       
     
        setUpCellColor(cell, message )
       
      
        
        //lets modify the bubleview width
        //modify buble width efficently so it takes up minimu amount of space base on text size
        let tempconstant = estimateFrameOrTextHeight(message.text).width
         cell.bubleWIdthAnchor = cell.bubbleView.widthAnchor.constraint(equalToConstant: tempconstant)
        
        
        return cell
    }
    
    func setUpCellColor(_ cell : ChatMessageCollectionCell, _ message: aMessageObject) {
        
        
        //sendSelf.collectionView?.rightAnchor
        
        // deactivate old constraints so next cell can use its own
       
        
        if message.fromID == (FIRAuth.auth()?.currentUser?.uid)! {
            // outgoing message are blue
            
            
            
            cell.bubbleView.backgroundColor = ChatMessageCollectionCell.blueColor
            cell.textView.textColor = UIColor.white
            
            
           
           
            
        }
        else {
            // incoming grey message
           
           
            
            cell.bubbleView.backgroundColor =  ChatMessageCollectionCell.grayColor
            //cell.bubbleView.leftAnchor.constraint(equalTo:  cell.leftAnchor).isActive = true
            cell.textView.textColor = UIColor.black
            
            
        }
        
        
        
        
    }
    
    
    
    // size of cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var TempHeight: CGFloat = 80
        //estimate text height
        if let text = allMessages[indexPath.row].text as? String {
            TempHeight = estimateFrameOrTextHeight(text).height + 20
        }
        
        
        return CGSize(width: view.frame.width, height: TempHeight)
        
    
    }
    
    func estimateFrameOrTextHeight(_ text : String) -> CGRect{
        let size = CGSize(width: 200 , height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        
        let cgfloat = CGFloat(16)
        let fontsize = UIFont.systemFont(ofSize: cgfloat)
        let attributes = [NSFontAttributeName: fontsize]as [String: Any]
        
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes , context: nil)
    }
    
    
    
    func handleSendButton(){ // my handleSend function name equivelent to tutorial
        
        // send message to database
        let messageRefrence = FIRDatabase.database().reference().child("messages")
        
        // create a list child node --> this can be used to store all messages of a user in a list on firebase DB
        // .childByAutoId() --> used to generate a unique node for a list
        // format of "Tress" below:
        // root --> user-message node --> a userId node --> a bunch messages in a list fanned out
        
        // creates a refrence node with an autogenerated id
        let ChildRefList = messageRefrence.childByAutoId()
        
        //get the id Of User We are righting to
        var idToWriteTo = whoAmIChattingWith.account_id
        
        // or we can use fromID = FIRAuth.auth()?.currentUser?.uid
        var fromID = FIRAuth.auth()?.currentUser?.uid//FireBaseUser.account_id
        
        let timeStamp: Int = Int(NSNumber(value: NSDate.timeIntervalSinceReferenceDate ))
        
        
        
        let values = ["text": inputTextField.text,
                      "toWriteTo" : idToWriteTo, "fromID": fromID ,
                      "timeSTamp": timeStamp] as [String : Any]
        
        
        
        // below is a method of what firebase calls fanning out
        // so we fan out a list of messages from the user id who owns the message
        //ChildRefList.updateChildValues(values)
        ChildRefList.updateChildValues(values) { (error, refSentBack) in
            if error != nil {
                print("Firebase Error")
                return
            }
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromID!)
            
            // saves the message for the sender
            let messageId = ChildRefList.key //get the auto generated message id from above
            userMessagesRef.updateChildValues([messageId : 1])
            
            
            // saves the message sent for the reciever
            let recipentUserMessegaesRef = FIRDatabase.database().reference().child("user-messages").child(idToWriteTo)
            recipentUserMessegaesRef.updateChildValues([messageId : 1])
            
        }
        
        // clear old text for more input
        self.inputTextField.text = nil
        
    }
    
    
    
    // create bottom part of view with textfield & send button
    func setupInputComponents() { // will be equivent to setupNavBarWithUser
        let containerView = UIView()
        //containerView.backgroundColor = UIColor.red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        // ios 9 constrains needed & x,y,w,h constraints need to place on screen
        // anchor left corner of subview to exact location of parent left anchor
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        // anchor bttom of subview to same location as parent bottom sub view
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        // make subview as wide as parent view
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        // make subview 50 pixel high
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        // append some buttons to this subview
        let sendButton = UIButton(type: .system)// using type .sytem allows the button
                            // to be clickable on push down for actions
        
        sendButton.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton) // append send button to containerView
        
        // pin send button to its location: x,y,w,h
        // pin the send button righ corner to anchor of right corner of its parent view
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        // center send button in the center of its parent view
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        // make button as tall as the contraitsView height
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
       
        
        // add text field so user can send "textmessage"
        /*let inputTextField = UITextField()
        inputTextField.placeholder = "Enter message here ....."
        inputTextField.translatesAutoresizingMaskIntoConstraints = false*/
        
        //gets declared at top by class property format
        containerView.addSubview(inputTextField)
        
        // set x,y,w,h of textfield
        // left corner is at its parents left corner --> the constant : 8 pushes the left corner right 8 pixels
        // b/c the text would appear off screen right on the edge otherwise
        inputTextField.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 8).isActive = true
        
        // center the textfield into its parent view
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        // text field width or right side/right corner should stop at left of send button
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        // should be as tall as its parent view
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        
        // add a simple line to seperate what user types in from chat log area
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor.black
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLineView)
    
        // place, x,y,w,h
        seperatorLineView.leftAnchor.constraint(equalTo:containerView.leftAnchor).isActive = true
        seperatorLineView.topAnchor.constraint(equalTo:containerView.topAnchor).isActive = true
        seperatorLineView.widthAnchor.constraint(equalTo:containerView.widthAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // whenever enter is tapped execute this function
        
        // so hit enter activates our lazy var function
        handleSendButton()
        return true
    }
    
    func setWhoToWriteTo(_ aUser: aFirebaseUser){
       
        self.whoAmIChattingWith = aUser
        
        
    }
    

    
}
