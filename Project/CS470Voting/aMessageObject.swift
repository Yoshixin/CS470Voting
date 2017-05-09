//
//  aMessageObject.swift
//  CS470Voting
//
//  Created by Joe Mogannam on 5/7/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit
import Firebase

class aMessageObject: NSObject {

    var fromID = String()
    var text = String()
    var timeSTamp = NSNumber()
    var toWriteTo = String()
    
    
    func getChatPartnerID() -> String? {
        var chatPartnerId = String()
        
        if fromID == FIRAuth.auth()?.currentUser?.uid {
            // if the message id is the same as the current user id
            // the message should be sent to the partner
            // send message to someone else not logged in on this device
            chatPartnerId = toWriteTo
            
        }
        else {
            // else the message id != current user id
            // and the message should go to the reciver
            // the messgae should come to the user logged in on this device
            chatPartnerId = fromID
        }
        
        return chatPartnerId

    }
    
}
