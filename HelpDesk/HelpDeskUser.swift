//
//  User.swift
//  HelpDesk
//
//  Created by Michael Madans on 3/29/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HelpDeskUser: NSObject {
    
    var user: PFUser!
    
    var isTutor: Bool!
    var username: String!
    var tutors: [PFUser]?
    
    var students: [PFUser]?
    var tutoredClasses: [PFObject]?
    
    override init() {
        super.init()
        refreshData()
        
    }
    
    func refreshData(){
        self.user = PFUser.currentUser()
        if let user = user{
            
            self.username = user["username"] as! String
            self.isTutor = user["isTutor"] as! Bool
            self.tutors = user["tutors"] as? [PFUser]
            self.students = user["students"] as? [PFUser]
            self.tutoredClasses = user["tutoredClasses"] as? [PFObject]
        }
        else {
            print("Error in \"User.swift\". Tried to refreshData but no current PFUser")
        }
    }
    
}

