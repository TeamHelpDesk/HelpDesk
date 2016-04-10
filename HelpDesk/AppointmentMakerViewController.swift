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
    @IBOutlet weak var chosenTutorLabel: UILabel!
    
    var isTutor:Bool!
    var strDate: String?
    var tutoring: PFObject?
    var tutorname: String?
    var subject: String?
    var hasPickedTutor = false

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        datePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)

        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onChooseTutor(sender: AnyObject) {
        
        self.performSegueWithIdentifier("showTutors", sender: sender)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTutors" {
            let vc = segue.destinationViewController as! AppointmentTutorPickerViewController
            vc.onDataAvailable = {[weak self]
                (data) in
                if let weakSelf = self {
                    let tutorings = HelpDeskUser.sharedInstance.tutorings
                    let tutoring = tutorings![data]
                    self!.tutorname = (tutoring["tutorname"] as! String)
                    self!.subject = (tutoring["subject"] as! String)
                    let str = "\(self!.tutorname!) (\(self!.subject!))"
                    self!.chosenTutorLabel.text = str
                    self!.hasPickedTutor = true
                }
            }

        }
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
        let post = PFObject(className: "Notifications")
        
        // Add relevant fields to the object
        post["time"] =  time
        post["location"] = location // Pointer column type that points to PFUser
        post["sender"] = sender!.username as String!
        post["recipient"] = recipient!.username as String!
        post["topics"] = topics
        post["duration"] = "120"
        post["subject"] = self.subject
        post["message"] = "Appointment request from \(sender!.username)"
        post["type"] = "appointment"
            
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
    }

    
    @IBAction func onSubmit(sender: AnyObject) {
        if(hasPickedTutor){
            postAppointmentRequest(strDate, location: locField.text, sender: PFUser.currentUser(), recipient: PFUser.currentUser(), topics: topicsField.text) { (success: Bool, error: NSError?) -> Void in
                if success {
                    print("success uploading appointment request")
                } else {
                    print(error?.description)
                }
            }
        }
    }
    

}
