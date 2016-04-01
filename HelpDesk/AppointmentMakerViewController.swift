//
//  AppointmentMakerViewController.swift
//  HelpDesk
//
//  Created by Michael Madans on 3/24/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class AppointmentMakerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var locField: UITextField!
    @IBOutlet weak var topicsField: UITextView!
    var isTutor:Bool!
    var strDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       /* if (isTutor == true){
            print("I'm a tutor")
        } else {
            print("I'm a student")
        }*/
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        datePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)

        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseStudent(sender: AnyObject) {
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        strDate = dateFormatter.stringFromDate(datePicker.date)
        
        print(strDate)
    }
    
    func postAppointmentRequest(time: String?, location: String?, sender: PFUser?, recipient: PFUser?, topics: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "AppointmentRequests")
        
        // Add relevant fields to the object
        post["time"] =  time
        post["location"] = location // Pointer column type that points to PFUser
        post["sender"] = sender!.username as String!
        post["recipient"] = recipient!.username as String!
        post["topics"] = topics
        post["duration"] = "120"
        post["subject"] = "physics"
            
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
    }

    
    @IBAction func onSubmit(sender: AnyObject) {
        postAppointmentRequest(strDate, location: locField.text, sender: PFUser.currentUser(), recipient: PFUser.currentUser(), topics: topicsField.text) { (success: Bool, error: NSError?) -> Void in
            if success {
                print("success uploading appointment")
            } else {
                print(error?.description)
            }
        }
    }
    

}
