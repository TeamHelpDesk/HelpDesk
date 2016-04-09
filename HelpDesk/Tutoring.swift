//
//  Tutoring.swift
//  HelpDesk
//
//  Created by Zach Glick on 4/8/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class Tutoring: NSObject {
    
    var tutor : PFUser?
    var tutorname : String?
    var student : PFUser?
    var studentname : String?
    var subject : String?
    var objectId : String?
    
    init(tutoring : PFObject){
        self.tutor = tutoring["tutor"] as? PFUser
        self.student = tutoring["student"] as? PFUser
        self.studentname = tutoring["studentname"] as? String
        self.tutorname = tutoring["tutorname"] as? String
        self.subject = tutoring["subject"] as? String
        self.objectId = tutoring["_id"] as? String
    }

}
