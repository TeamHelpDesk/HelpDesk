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

class User: NSObject {
    
    var user = PFUser.currentUser()
    var isTutor: Bool!
    var userName: String!
    
}
