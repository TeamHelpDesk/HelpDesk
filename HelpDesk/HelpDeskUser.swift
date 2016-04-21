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
    
    var username: String!
    var loggedOut = false
    
    var tutorings: [PFObject]?
    var students: [PFUser]?
    var tutors: [PFUser]?
    var people: [PFUser]?
    
    var tutoredCourses: [String]?
    
    var isTutor: Bool?
    
    //var tutoringsCopy: [Tutoring]?
    
    
    override init() {
        print("Initialized Singleton")
        super.init()
        self.user = PFUser.currentUser()
        loggedOut = false
        refreshData()
    }
    
    
    func postTutoring(tutor : PFUser, student : PFUser, subject : String, withCompletion completion: PFBooleanResultBlock?) {
        
        let post = PFObject(className: "Tutoring")
        
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
    
    func logout(){
        //print("Logged Out")
        loggedOut = true
        PFUser.logOut()
        refreshData()
        
    }
    
    func refreshData(){
        print("Refreshing Data")
        self.user = PFUser.currentUser()
        if let user = user{
            //print("Refreshed User Data!")
            self.username = user["username"] as? String
            //self.isTutor = user["isTutor"] as? Bool
            //self.tutoredClasses = user["tutoredClasses"] as? [PFObject]
            refreshTutorings()
            
        }
        else{
            //print("Removed User Data!")
            self.username = nil
            self.tutorings = nil
            //MAKE EVERYTHING NIL
            
        }
    }
    
    func refreshTutorings(){ //SHOULD I HAVE A BOOLEAN PARAMETER TO MAKE REFRESHING THE LOCAL ARRAYS OPTIONAL?
        let isStudentQuery = PFQuery(className : "Tutoring")
        let isTutorQuery = PFQuery(className : "Tutoring")
        
        //userQuery?.includeKey("username")
        isTutorQuery.whereKey("tutorname", equalTo: self.username )
        isStudentQuery.whereKey("studentname", equalTo: self.username )
        //userQuery!.limit = 20

        
        let isPersonQuery = PFQuery.orQueryWithSubqueries([isStudentQuery, isTutorQuery])
        isPersonQuery.whereKey("type", notEqualTo: "request")
        
        isPersonQuery.findObjectsInBackgroundWithBlock { (tutorings: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.tutorings = [PFObject]()
                for tutoring in tutorings! {
                    //print("\(tutoring["tutorname"]) is tutoring \(tutoring["studentname"]) in \(tutoring["subject"])")
                    self.tutorings?.append(tutoring)
                    
                }
                self.refreshPeople(tutorings!)
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func refreshPeople(tutorings : [PFObject]){
        //print("Refreshing People")
        self.people = [PFUser]()
        self.tutors = [PFUser]()
        self.students = [PFUser]()
        
        for tutoring in tutorings {
            let student = tutoring["studentname"] as! String
            let tutor = tutoring["tutorname"] as! String
            
            if(tutor == self.username){
                self.students?.append(tutoring["student"] as! PFUser)
                self.people?.append(tutoring["student"] as! PFUser)

            }
            else if(student == self.username){
                self.tutors?.append(tutoring["tutor"] as! PFUser)
                self.people?.append(tutoring["tutor"] as! PFUser)

            }
            else {
                print ("Error: Tutoring does not contain HelpDeskUser")
            }
        }
        print("Done Refreshing Data")
        //SEND NSNOTIFICATION HERE?
        NSNotificationCenter.defaultCenter().postNotificationName("RefreshedData", object: nil)
        //self.printStudents()
        //self.printTutors()
        //self.printPeople()
    }

    
    
    
    
    
    
    
    
    //FOR DEBUGGING
    func printTutors(){
        //print("Printing Tutors")
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
        //print("Printing Students")
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
    //FOR DEBUGGING
    func printPeople(){
        //print("Printing Students")
        if self.people != nil{
            for person in self.people! {
                //print(student.objectId!)
                person.fetchIfNeededInBackgroundWithBlock {
                    (object: PFObject?, error:NSError?) -> Void in
                    if error == nil {
                        print("PERSON : \(object!["username"])")
                    }
                }
            }
        }
        else{
            print("no people")
        }
    }
    
}

