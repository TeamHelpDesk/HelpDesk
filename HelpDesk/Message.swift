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
    
    //var createdAtString: String?
    //var createdAt: NSDate?
    
//    init(text: String?, receiver: PFUser) {
//        // Create Parse object PFObject
//        let message = PFObject(className: "Message") as PFObject
//        
//        // Add relevant fields to the object
//        message["text"] = text
//        message["sender"] = PFUser.currentUser()
//        message["receiver"] = receiver
//        
//        
//            //user = User(dictionary: dictionary["user"] as! NSDictionary)
//            //text = dictionary["text"] as? String
//            //createdAtString = dictionary["created_at"] as? String
//            //let formatter = NSDateFormatter()
//            //formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
//            //createdAt = formatter.dateFromString(createdAtString!)
//        }
    
    class func saveMessage(text: String?, receiver: PFUser, count: Int) -> PFObject {
        // Create Parse object PFObject
        let message = PFObject(className: "Message") as PFObject
        
        // Add relevant fields to the object
        message["text"] = text
        message["sender"] = PFUser.currentUser()
        message["receiver"] = receiver
        message["count"] = count
        
        return message
        //user = User(dictionary: dictionary["user"] as! NSDictionary)
        //text = dictionary["text"] as? String
        //createdAtString = dictionary["created_at"] as? String
        //let formatter = NSDateFormatter()
        //formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        //createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func sendMessage(message: PFObject, withCompletion completion: PFBooleanResultBlock?) {
        // Save object (following function will save the object in Parse asynchronously)
        message.saveEventually(completion)
    }
}
