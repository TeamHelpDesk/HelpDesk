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
    var strDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func postAppointment(time: String?, location: String?, tutor: PFUser?, student: PFUser?, topics: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Appointment")
        
        // Add relevant fields to the object
        post["time"] =  time
        post["location"] = location // Pointer column type that points to PFUser
        post["tutor"] = tutor!.username as String!
        post["student"] = student!.username as String!
        post["topics"] = topics
            
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
    }

    
    @IBAction func onSubmit(sender: AnyObject) {
        postAppointment(strDate, location: locField.text, tutor: PFUser.currentUser(), student: PFUser.currentUser(), topics: topicsField.text) { (success: Bool, error: NSError?) -> Void in
            if success {
                print("success uploading appointment")
            } else {
                print("Error Uploading image")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
