//
//  Message.swift
//  HelpDesk
//
//  Created by Reis Sirdas on 3/25/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class Message: NSObject {
    
    //    //var user: User?
    //    var text: String?
    //    var createdAtString: String?
    //    var createdAt: NSDate?
    //
    //    init(dictionary: NSDictionary) {
    //        //user = User(dictionary: dictionary["user"] as! NSDictionary)
    //        text = dictionary["text"] as? String
    //        createdAtString = dictionary["created_at"] as? String
    //        let formatter = NSDateFormatter()
    //        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
    //        createdAt = formatter.dateFromString(createdAtString!)
    //    }
    
    class func sendMessage(text: String?, receiver: PFUser, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let message = PFObject(className: "Message")
        
        // Add relevant fields to the object
        message["text"] = text
        message["sender"] = PFUser.currentUser()
        message["receiver"] = receiver
        
        // Save object (following function will save the object in Parse asynchronously)
        message.saveEventually(completion)
    }
}

