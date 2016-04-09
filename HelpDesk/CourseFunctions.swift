//
//  MakeClasses.swift
//  HelpDesk
//
//  Created by Zach Glick on 4/9/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class CourseFunctions: NSObject {
    
    

    func addCourses(){
        let courses = ["physics","compsci","calculus"]
        
        for courseName in courses {
            let post = PFObject(className: "Course")
            post["coursename"] = courseName
            post.saveInBackground()
            
        }
    }
    
    func assignAllCourses(){
        let courseQuery = PFQuery(className: "Course")
        var courses = [String]()
        courseQuery.findObjectsInBackgroundWithBlock { (allCourses: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for course in allCourses! {
                    courses.append(course["coursename"] as! String)
                    print(course["coursename"] as! String)
                }
                
                let user = PFUser.currentUser()
                user!["tutoredCourses"] = courses
                user?.saveInBackground()
                
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
        
    }
    
    func unassignAllCourses(){
        
            let user = PFUser.currentUser()
            user!["tutoredCourses"] = NSNull()
            user?.saveInBackground()
        
    }
    
    
    //Code to test the the HelpDeskUser Object (Delete when it works for sure)
    //let helpdeskuser = HelpDeskUser()
    //print(helpdeskuser.username)
    //print(HelpDeskUser.sharedInstance.username)
    
    /*
     var userQuery : PFQuery?
     userQuery = PFUser.query()
     userQuery?.includeKey("username")
     userQuery?.whereKey("username", notEqualTo: (HelpDeskUser.sharedInstance.username)!)
     userQuery!.limit = 20
     userQuery!.findObjectsInBackgroundWithBlock { (users: [PFObject]?, error: NSError?) -> Void in
     if error == nil {
     let users = users! as? [PFUser]
     for user in users! {
     
     HelpDeskUser.sharedInstance.addTutor(user)
     }
     } else {
     // handle error
     print(error?.localizedDescription)
     }
     }
     */
    
    
    /* var userQuery : PFQuery?
     userQuery = PFUser.query()
     userQuery?.whereKey("username", equalTo: "Username")
     userQuery!.findObjectsInBackgroundWithBlock { (users: [PFObject]?, error: NSError?) -> Void in
     if error == nil {
     let users = users! as? [PFUser]
     for user in users! {
     HelpDeskUser.sharedInstance.postTutoring(user,student: HelpDeskUser.sharedInstance.user, subject: "physics"){ (success: Bool, error: NSError?) -> Void in
     if success {
     print("success uploading request")
     } else {
     print(error?.description)
     }
     }
     HelpDeskUser.sharedInstance.postTutoring(user,student: HelpDeskUser.sharedInstance.user, subject: "physics"){ (success: Bool, error: NSError?) -> Void in
     if success {
     print("success uploading request")
     } else {
     print(error?.description)
     }
     }
     HelpDeskUser.sharedInstance.postTutoring(HelpDeskUser.sharedInstance.user, student : user, subject: "physics"){ (success: Bool, error: NSError?) -> Void in
     if success {
     print("success uploading request")
     } else {
     print(error?.description)
     }
     }
     }
     } else {
     // handle error
     print(error?.localizedDescription)
     }
     }
     */
    
}
