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
    
    var isTutor: Bool?
    var username: String!
    var tutors: [PFUser]?
    
    var tutorings: [PFObject]?
    var tutoringsCopy: [Tutoring]?
    
    
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
            //self.isTutor = user["isTutor"] as? Bool
            //self.tutoredClasses = user["tutoredClasses"] as? [PFObject]
            refreshTutoringss()
        }
    }
    
    func logout(){
        
        PFUser.logOut()
        refreshData()
        
    }

    
    //FOR DEBUGGING
    func printTutors(){
        if self.tutors != nil{
            for tutor in self.tutors! {
                //print(tutor.objectId!)
                tutor.fetchIfNeededInBackgroundWithBlock {
                    (object: PFObject?, error:NSError?) -> Void in
                    if error == nil {
                        print("TUTOR : \(object!["username"])")
                    }
                }
            }
        }
        else{
            print("no tutors")
        }
    }
    //FOR DEBUGGING
    func printStudents(){
        if self.students != nil{
            for student in self.students! {
                //print(student.objectId!)
                student.fetchIfNeededInBackgroundWithBlock {
                    (object: PFObject?, error:NSError?) -> Void in
                    if error == nil {
                        print("STUDENT : \(object!["username"])")
                    }
                }
            }
        }
        else{
            print("no students")
        }
    }
    
    func postTutoring(tutor : PFUser, student : PFUser, subject : String, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Tutoring")
        
        // Add relevant fields to the object
        post["tutor"] =  tutor
        post["student"] = student
        post["subject"] = subject
        
        tutor.fetchIfNeededInBackgroundWithBlock {
            (object: PFObject?, error:NSError?) -> Void in
            if error == nil {
                post["tutorname"] = object!["username"]
            }
        }
        
        student.fetchIfNeededInBackgroundWithBlock {
            (object: PFObject?, error:NSError?) -> Void in
            if error == nil {
                post["studentname"] = object!["username"]
            }
        }
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
    }
    
    func refreshTutoringss(){
        print("a2")
        //let isStudentQuery = PFQuery(className : "Tutoring")
        //let isTutorQuery = PFQuery(className : "Tutoring")
        print("a4")
        //userQuery?.includeKey("username")
        //isStudentQuery.whereKey("studentname", equalTo: self.username)
        //isTutorQuery.whereKey("tutorname", equalTo: self.username )
        //userQuery!.limit = 20
        print("b")
        /*isStudentQuery.findObjectsInBackgroundWithBlock { (tutorings: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                //let tutoring = tutorings! as? [PFObject]
                for tutoring in tutorings! {
                    print("\(tutoring["tutorname"]) is tutoring \(tutoring["studentname"]) in \(tutoring["subject"])")
                    
                }
                //self.refreshTutors(tutorings!)
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }*/
        print("h")
        /*isTutorQuery.findObjectsInBackgroundWithBlock { (tutorings: [PFObject]?, error: NSError?) -> Void in
            if error == nil {

                //let tutoring = tutorings! as? [PFObject]
                for tutoring in tutorings! {
                    print("\(tutoring["tutorname"]) is tutoring \(tutoring["studentname"]) in \(tutoring["subject"])")
                    
                }
                //self.refreshStudents(tutorings!)
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }*/
        print("n")
        
    }
    
    func refreshTutors(tutorings : [PFObject]){
        self.tutors = [PFUser]()
        
        for tutoring in tutorings {
            self.tutors?.append(tutoring["tutor"] as! PFUser)
        }
        
        //self.printTutors()
    }
    
    
    func refreshStudents(tutorings : [PFObject]){
        self.students = [PFUser]()
        
        for tutoring in tutorings {
            self.students?.append(tutoring["student"] as! PFUser)
        }
        //self.printStudents()
    }
    

    
    
}

