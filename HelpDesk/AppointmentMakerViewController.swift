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
import MBProgressHUD

class AppointmentMakerViewController: UIViewController, UIPopoverPresentationControllerDelegate,
TutorSelectDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var locField: UITextField!
    @IBOutlet weak var topicsField: UITextView!
    @IBOutlet weak var chosenTutorLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var tutorButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var isTutor:Bool!
    var strDate: String?
    var tutoring: PFObject?
    var tutor: PFUser?
    var tutorname: String?
    var subject: String?
    var hasPickedTutor = false
    var location: String?
    var mapUsed = false
    var lat: Double?
    var long: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locField.text = ""
        datePickerChanged(datePicker)
        datePicker.minuteInterval = 10
        topicsField.layer.cornerRadius = 5
        topicsField.clipsToBounds = true
        mapButton.layer.cornerRadius = 5
        mapButton.clipsToBounds = true
        tutorButton.layer.cornerRadius = 5
        tutorButton.clipsToBounds = true
        submitButton.layer.cornerRadius = 5
        submitButton.clipsToBounds = true
        backButton.layer.cornerRadius = 5
        backButton.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        datePicker.addTarget(self, action: #selector(AppointmentMakerViewController.datePickerChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)

        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onChooseTutor(sender: AnyObject) {
        
        
        let menuViewController =  AppointmentTutorPickerViewController()
        menuViewController.modalPresentationStyle = .Popover
        menuViewController.preferredContentSize = CGSizeMake(200, 300)
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = (self.view as UIView)
        popoverMenuViewController?.sourceRect = CGRect(
            x: UIScreen.mainScreen().bounds.width/2 ,
            y: UIScreen.mainScreen().bounds.height/2 ,
            width: 0,
            height: 0)
        print("\(UIScreen.mainScreen().bounds.width)  \(UIScreen.mainScreen().bounds.height)")
        //menuViewController.tableViewWidth = 200
        //menuViewController.tableViewHeight = 300
        menuViewController.delegate = self;
        presentViewController(
            menuViewController,
            animated: true,
            completion: nil)
        
    }
    

    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
  
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        strDate = dateFormatter.stringFromDate(datePicker.date)
        
        print(strDate)
    }
    
    func postAppointmentRequest(time: String?, location: String?, student: PFUser?, tutor: PFUser?, topics: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Notifications")
        
        // Add relevant fields to the object
        post["time"] =  time
        post["student"] = HelpDeskUser.sharedInstance.username as String!
        post["tutor"] = tutorname as String!
        post["topics"] = topics
        post["subject"] = self.subject
        post["message"] = "Appointment request from \(student!.username!)"
        post["type"] = "appointmentRequest"
        post["mapUsed"] = mapUsed
        post["location"] = locField.text

        if(mapUsed == true){
            post["latitude"] = self.lat
            post["longitude"] = self.long
        }
        // Pointer column type that points to PFUser
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
    }
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        let source = segue.sourceViewController as! AppointmentMakerMapViewController
        self.lat = source.lat
        self.long = source.long
        mapUsed = true
    }
    
    @IBAction func onSubmit(sender: AnyObject) {
        if(hasPickedTutor && locField.text != ""){
            //MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            postAppointmentRequest(strDate, location: self.location, student: PFUser.currentUser(), tutor: tutor, topics: topicsField.text) { (success: Bool, error: NSError?) -> Void in
                if success {
                    print("success uploading appointment request")
                } else {
                    print(error?.description)
                }
               // MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
            self.dismissViewControllerAnimated(true, completion: {})
        }
        else {
            let alert = UIAlertController(title: "Missing Appointment Fields", message: "Please Select a Time, Tutor, and Location!", preferredStyle: .Alert)
           
            let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
                (_)in
            })
            alert.addAction(OkAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func onClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func sendValue(value: Int) {
        let tutorings = HelpDeskUser.sharedInstance.tutorings
        let tutoring = tutorings![value]
        self.tutorname = (tutoring["tutorname"] as! String)
        self.subject = (tutoring["subject"] as! String)
        self.tutor = (tutoring["tutor"] as! PFUser)
        let str = "\(self.tutorname!) (\(self.subject!))"
        self.chosenTutorLabel.text = str
        self.hasPickedTutor = true
        //selectedClassName = value;
        //selectedCourse.text = value;
    }
}
