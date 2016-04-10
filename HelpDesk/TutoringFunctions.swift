//
//  TutoringFunctions.swift
//  HelpDesk
//
//  Created by Zach Glick on 4/9/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class TutoringFunctions: NSObject {

    func makeRandomTutorings(){
    
        let userQuery = PFUser.query()
        userQuery?.whereKey("username", notEqualTo: HelpDeskUser.sharedInstance.username)
        //userQuery!.limit = 20
        userQuery!.findObjectsInBackgroundWithBlock { (users: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for userobject in users!  {
                    let user = userobject as! PFUser
                    let random = Int(arc4random_uniform(2))
                    if random == 0 {
                        HelpDeskUser.sharedInstance.postTutoring(user,student: HelpDeskUser.sharedInstance.user, subject: "physics"){ (success: Bool, error: NSError?) -> Void in
                            if success {
                                //print("success uploading request")
                            } else {
                                print(error?.description)
                            }
                        }
                    }
                    else if random == 1 {
                        HelpDeskUser.sharedInstance.postTutoring(HelpDeskUser.sharedInstance.user,student: user, subject: "physics"){ (success: Bool, error: NSError?) -> Void in
                            if success {
                                //print("success uploading request")
                            } else {
                                print(error?.description)
                            }
                        }
                    }
                    else {
                        print("Zach apparently doesn't know how to generate random numbers in swift")
                    }
                }
                
                
            } else {
                print(error?.localizedDescription)
            }
        }
        
        
    }
    
}
