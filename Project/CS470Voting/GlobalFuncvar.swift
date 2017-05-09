//
//  GlobalFunc&var.swift
//  CS470Voting
//
//  Created by Joe Mogannam on 5/6/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

let FirebaseRef = FIRDatabase.database().reference(fromURL: "https://cs470chatapp.firebaseio.com/")

var email = "-1"//String()
var password = "-1"// String()
var logedInId = 1;
var chosenCategoryId = -1

var globalPushFunctionMsg = "-1"

var loggedInUser = aUser()
var FireBaseUser = aFirebaseUser()
var allFireUsersPulled = [aFirebaseUser]()


let dbg = true


func gFetchAllFirebaseUsers(selfSender :Any){
    FIRDatabase.database().reference().child("accounts").observe(.childAdded, with: {( UsersPulled) in
        
        
        //print("found some users")
        
        //print (UsersPulled)
        
        if let oneUserAsDict = UsersPulled.value as? [String :AnyObject]{
            var oneFireUser = aFirebaseUser()
            oneFireUser.setValuesForKeys(oneUserAsDict)
            //print("in if, user : " ,oneUserAsDict , "\n")
            
            allFireUsersPulled.append(oneFireUser)
            
            
            // this code runs threaded so must reload table view controller
            // so data exists when this thread ends and not when the main thread ends
            // if you don't do this the table view cwlls will be empty
            /*DispatchQueue.main.async{
                 var tempNewMsgControl = selfSender as! NewMessageTableVC
                tempNewMsgControl.tableView.reloadData() }*/
            
        }
    }, withCancel: nil)
    
    
   
    
    
    
}


func gSaveUserToDatabase(_ fireBaseUID : String?, _ account_nickname: String , _ account_email : String, _ account_password : String){
    // in our register view we also save user to database right after authenticating user
    // TODO: make php script send back user_id from mysql so we can use same id for firebase DB
    
    var values = ["account_nickname" : account_nickname, "account_email" : account_email, "account_password": account_password, "account_id" : -1] as [String : Any]
    
    // firebase uses a tree like structure to save data.
    // FirebaseRef --> is the root node, you can add child nodes to any node to create more "tables" or "records" in a table
    // accountsRefrence --> is a node that represents account table
    // userIdRefrence -> allows you to add a child refrence userId into acounts table before we innsert the data
    guard let userIdRefrence = fireBaseUID else{
        return // if userid look up fail exit register,
    }
    
    values["account_id"] = userIdRefrence
    let accountsRefrence = FirebaseRef.child("accounts").child(userIdRefrence)
    // so node path is root --> accounts -->  a bunch of UserID's --> the data per user ID
  
    
    accountsRefrence.updateChildValues(values) { (savedRecordError, FirebaseRef) in
        if savedRecordError != nil {
            print("Firebase Error saving record",savedRecordError )
            return
        }
        print("Record Succesfully saved to Firebase DB")
        
        
    }
    
    
}



func gSignOut (){
    
    if FIRAuth.auth()?.currentUser != nil {
        do {
            try FIRAuth.auth()?.signOut()
            
            
            mydebugPrint(["Succesfull Firebase Logout"])
            
            
        } catch let error as NSError {
            mydebugPrint(["Firebase SignOut Error ", error.localizedDescription])
        }
    }
    
    
}


func gSignOut (_ theUser: aUser){
    
   // if FIRAuth.auth()?.currentUser != nil {
        do {
            try FIRAuth.auth()?.signOut()
            
            
            mydebugPrint(["Succesfull Firebase Logout"])
            
            
        } catch let error as NSError {
            mydebugPrint(["Firebase SignOut Error ", error.localizedDescription])
        }
    //}
    
    
}

func gUpdateLoginInfo(_ theUser : aUser){
    email = theUser.account_email
    password = theUser.account_password
    logedInId = theUser.account_id
    
    var printme = ("email \(email)  | password  \(password)   id  \(logedInId)")
    
    FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
        
        if error == nil {
            
            //Print into the console if successfully logged in
             mydebugPrint([printme, "You have successfully logged in On Firebase"])
           
            
            
            
        } else {
            
             mydebugPrint(["Error, Firebase signIn Failed: \(error)" ])
            
          
        }
    }


    
    
   
}




func gAuthenticateFirebaseUser (_ emailToUse: String, _ passToUse : String, _ usernameToUse: String){
    
    
    FIRAuth.auth()?.createUser(withEmail: emailToUse, password: passToUse) { (user, error) in
        
        if error == nil {
            mydebugPrint(["You have successfully signed up a Firebase user"])
            //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
            
            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            //self.present(vc!, animated: true, completion: nil)
            
            guard let userIdRefrence = user?.uid else{
                return // if userid look up fail exit register,
            }
            
             gSaveUserToDatabase(userIdRefrence, usernameToUse, emailToUse, passToUse)
            
            
            
            
        } else {
            
            
           mydebugPrint(["Firebase Error user not signed up, ", (error?.localizedDescription)! as String])
            
            
        }
    }
}

func mydebugPrint(_ theString : [String]){
    if dbg == true {
        print("------ Debug Print----- \n ")
        print(theString)
        print("---- End Print ----- \n")
    }
}


func LoginFireBaseUserUpdateChatTitle(_ sendSelf : Any, _ whichViewController : String) {
    
    // ____ FETCH ONE USER FROM FIREBASE DB ________
    
    // .child("accounts") --> fetch from accounts node 1st
    // child(FirebaseUID) --> next node is user id node
    // so result is fetch all data (all nodes) under user id node
    let FirebaseUID = FIRAuth.auth()?.currentUser?.uid
    FIRDatabase.database().reference().child("accounts").child(
        FirebaseUID!).observeSingleEvent(of:.value,
            with: { (aFireBaseUserPulled) in
                
            
            if let userAsDict = aFireBaseUserPulled.value as? [String : AnyObject] {
                print("in LoginFireBaseUserUpdateChatTitle, user pulled is :", userAsDict["account_nickname"])
                //print(userAsDict)
                FireBaseUser.setValuesForKeys(userAsDict)
                
                // this is threaded so calling reload data
                
                DispatchQueue.main.async{
                    if whichViewController == "chat"
                    {// we don't have access to the viewtroller
                        var tempView = sendSelf as! ChatTableVC
                          tempView.navigationItem.title = FireBaseUser.account_nickname
                        tempView.tableView.reloadData()
                        
                    }
                }
                
                
            }
                
                                            
        }, withCancel:  nil)
    
    
    
}



func gCheckFirebaseUserLogin(_ sendSelf: Any, _ whichViewController : String)  {
    if FIRAuth.auth()?.currentUser?.uid == nil{
       // if user not signed in sign out
        gSignOut()
        
        
        let loginPageView =  (sendSelf as AnyObject).storyboard??.instantiateViewController(withIdentifier: "LoginPageStoryBoardID") as! LoginViewController
        (sendSelf as AnyObject).present(loginPageView, animated: true, completion: nil)
        
      
        

    }
    else{
        // the user is signed in from the authentication area
        // but you don't have access to the nick name in the authentication area
        // so thats why we also save the users on the firebase database itself
        // so fetch this one user from firebase Database
        
        
        LoginFireBaseUserUpdateChatTitle(sendSelf, "chat")
        
       
        
        
        
    }
    
}

func gDisplayMSG( myMessage: String,  myTitle: String, sendSelf : Any) {
    let myAlert = UIAlertController(title:myTitle, message: myMessage,
                                    preferredStyle: UIAlertControllerStyle.alert)
    
    let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.default, handler: nil);
    
    
    myAlert.addAction(okAction)
    
    (sendSelf as AnyObject).present(myAlert, animated:true, completion: nil)
    
}

