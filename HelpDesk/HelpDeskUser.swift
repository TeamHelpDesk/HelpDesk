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
    
    static let sharedInstance = HelpDeskUser()
    
    var user: PFUser!
    
    var isTutor: Bool!
    var username: String!
    var tutors: [PFUser]?
    
    var students: [PFUser]?
    var tutoredClasses: [PFObject]?
    
    override init() {
        super.init()
        self.user = PFUser.currentUser()
        refreshData()
        
    }
    
    func refreshData(){
        
        self.user = PFUser.currentUser()
        if let user = user{
            self.username = user["username"] as? String
            self.isTutor = user["isTutor"] as? Bool
            self.tutors = user["tutors"] as? [PFUser]
            self.students = user["students"] as? [PFUser]
            self.tutoredClasses = user["tutoredClasses"] as? [PFObject]
        }
        
    }
    
    func logout(){
        
        PFUser.logOut()
        refreshData()
        
    }
    
    
    static var _currentUser: HelpDeskUser?
    static let userDidLogoutNotification = "UserDidLogout"
    
    class var currentUser: HelpDeskUser?{
        get{

            return _currentUser;
        }
        set(helpdeskuser){
            _currentUser = helpdeskuser
        }
    }
    
    
    
}

