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

// a link to the database on firebase, so we know where to push data to and pull from
let FirebaseRef = FIRDatabase.database().reference(fromURL: "https://cs470chatapp.firebaseio.com/")

// global variables to hold the credentials of the user logged in
var email = "-1"//String()
var password = "-1"// String()
var logedInId = 1;

// a global var to hold the category choice a user clicks on
var chosenCategoryId = -1

// do't think this is used anymore
var globalPushFunctionMsg = "-1"

// an instance of a user that we pull/push to our mysql database
var loggedInUser = aUser()
// an instance of a user pulled/pushed from Firbase database
var FireBaseUser = aFirebaseUser()
// an array used by the chat application to hold all potential users we can chat with
var allFireUsersPulled = [aFirebaseUser]()

let dbg = true

func gFetchAllFirebaseUsers(selfSender :Any){
    // fetch all firebase users from the accounts table
    FIRDatabase.database().reference().child("accounts").observe(.childAdded, with: {( UsersPulled) in
        
        
        //print("found some users")
        
        //print (UsersPulled)
        
        if let oneUserAsDict = UsersPulled.value as? [String :AnyObject]{
            var oneFireUser = aFirebaseUser()
            oneFireUser.setValuesForKeys(oneUserAsDict)
            //print("in if, user : " ,oneUserAsDict , "\n")
            
            allFireUsersPulled.append(oneFireUser)
            
        }
    }, withCancel: nil)
    
}


func gSaveUserToDatabase(_ fireBaseUID : String?, _ account_nickname: String , _ account_email : String, _ account_password : String){
    // takes data from the Authentication proccess
    // save the firebase user credentials to our accounts table
    // save userID, username(aka nickname), userEmail, & password to accounts table
    
    // in our register view we also save user to database right after authenticating user
    
    // make a dictionary that firebase can parse
    var values = ["account_nickname" : account_nickname, "account_email" : account_email, "account_password": account_password, "account_id" : -1] as [String : Any]
    
    // firebase uses a tree like structure to save data.
    // FirebaseRef --> is the root node, you can add child nodes to any node to create more "tables" or "records" in a table
    // accountsRefrence --> is a node that represents account table
    // userIdRefrence -> allows you to add a child refrence userId into acounts table before we innsert the data
    
    // make sure the user id is not nil
    guard let userIdRefrence = fireBaseUID else{
        return // if userid look up fail exit register,
    }
    // if user id is not nil you can push data to accounts table
    values["account_id"] = userIdRefrence
    // storage structure in node tree : root node -> accounts node -> userID node -> store user data at this node
    let accountsRefrence = FirebaseRef.child("accounts").child(userIdRefrence)
    // so node path is root --> accounts -->  a bunch of UserID's --> the data per user ID
  
    // actually call the code to push data to database
    accountsRefrence.updateChildValues(values) { (savedRecordError, FirebaseRef) in
        if savedRecordError != nil {
            print("Firebase Error saving record",savedRecordError )
            return
        }
        print("Record Succesfully saved to Firebase DB")
        
        
    }
    
    
}



func gSignOut (){
    // sign out of firebase account using firebase credentials
    // make sure we have a valid user signed in b/c you can't sign out
    // if you are not signed in
    if FIRAuth.auth()?.currentUser != nil {
        do { // try to sign out
            try FIRAuth.auth()?.signOut()
            
            
            mydebugPrint(["Succesfull Firebase Logout"])
            
            
        } catch let error as NSError {
            mydebugPrint(["Firebase SignOut Error ", error.localizedDescription])
        }
    }
    
    
}


func gSignOut (_ theUser: aUser){
    // sign out of firebase using our mysql credentials for the user
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
    // will log in the user on firebase api so chat apllication works
    
    // set the user info to some global credentials so we know who is logged in  across entire aplication
    email = theUser.account_email
    password = theUser.account_password
    logedInId = theUser.account_id
    
    var printme = ("email \(email)  | password  \(password)   id  \(logedInId)")
    
    // code to sign in user on firebase
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
    // a function that creates a new user account in the firebase authentication table
    // aka signs up the user so they can push/pull data
    FIRAuth.auth()?.createUser(withEmail: emailToUse, password: passToUse) { (user, error) in
        // what is created is a email, password, & use id, and that is it
        // that is not that descriptive, b/c we also want a nickname 
        // so we also store the credentials in the database under the accounts table
        if error == nil {
            mydebugPrint(["You have successfully signed up a Firebase user"])
            //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
            
            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            //self.present(vc!, animated: true, completion: nil)
            
            // get the auto generated user id created by firebase
            guard let userIdRefrence = user?.uid else{
                return // if userid look up fail exit register,
            }
            
            // save the firebase user credentials to our accounts table
            // save userID, username(aka nickname), userEmail, & password to accounts table
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
    // try to fetch the logged in user from database
    // also updates that ChatTableViewCOntroller title
    
    // ____ FETCH ONE USER FROM FIREBASE DB ________
    
    // .child("accounts") --> fetch from accounts node 1st
    // child(FirebaseUID) --> next node is user id node
    // so result is fetch all data (all nodes) under user id node
    
    // check if user logged in on device is a valid firebase user to pull data for
    let FirebaseUID = FIRAuth.auth()?.currentUser?.uid
    // pull data for one user from accounts table so we have access to nickname
    // uses the userID to search the accounts table
    FIRDatabase.database().reference().child("accounts").child(
        FirebaseUID!).observeSingleEvent(of:.value,
            with: { (aFireBaseUserPulled) in
                
            // parse the record pulled from firebase into a dictionary
            if let userAsDict = aFireBaseUserPulled.value as? [String : AnyObject] {
                //print("in LoginFireBaseUserUpdateChatTitle, user pulled is :", userAsDict["account_nickname"])
                //print(userAsDict)
                
                // set the global var that represents the current user logged in 
                // to these credentials so we have access to the nick name
                FireBaseUser.setValuesForKeys(userAsDict)
                
                // this is threaded so calling reload data
                // update the chatTableViewCOntroller title to the user nickname
                DispatchQueue.main.async{
                    if whichViewController == "chat"
                    {// we don't have access to the viewtroller
                        // so se get it as a parameter
                        // but we still need to cast the generic view controller to a ChatTableVC
                        var tempView = sendSelf as! ChatTableVC
                          tempView.navigationItem.title = FireBaseUser.account_nickname
                        tempView.tableView.reloadData()
                        
                    }
                }
                
                
            }
                
                                            
        }, withCancel:  nil)
    
    
}



func gCheckFirebaseUserLogin(_ sendSelf: Any, _ whichViewController : String)  {
    // used to prevent errors when pushing/ pulling data 
    // checks is a user has permissions to push/pull data from firebase
    // if a valid user dosent exist we fore a logout
    
    // if user dosent have permissions sign them out
    if FIRAuth.auth()?.currentUser?.uid == nil{
       // if user not signed in sign out
        // log them out
        gSignOut()
        
        // force the log in page to come up, so that the bad user credentials can't be used
        let loginPageView =  (sendSelf as AnyObject).storyboard??.instantiateViewController(withIdentifier: "LoginPageStoryBoardID") as! LoginViewController
        (sendSelf as AnyObject).present(loginPageView, animated: true, completion: nil)
        
      
        

    }
    else{
        // the user is signed in from the authentication area
        // but you don't have access to the nick name in the authentication area
        // so thats why we also save the users on the firebase database itself
        // so fetch this one user from firebase Database
        
        // else allow the user to continue & update logged in user fireBase credentials
        LoginFireBaseUserUpdateChatTitle(sendSelf, "chat")
        
       
        
        
        
    }
    
}

// a generic function that can send alert message out from any view controller
func gDisplayMSG( myMessage: String,  myTitle: String, sendSelf : Any) {
    // takes two string and a instance of a ViewController casted as its actual type
    
    // so if you have a chatTableVC and want to call this function, do so as follows
    // gDisplayMSG( "a message to the user", "a title for the UIAlertController ", self as! chatTableVC)
    
    let myAlert = UIAlertController(title:myTitle, message: myMessage,
                                    preferredStyle: UIAlertControllerStyle.alert)
    
    let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.default, handler: nil);
    
    
    myAlert.addAction(okAction)
    
    (sendSelf as AnyObject).present(myAlert, animated:true, completion: nil)
    
}

