//
//  NotifcationsDetailViewController.swift
//  HelpDesk
//
//  Created by Michael Madans on 3/31/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class NotifcationsDetailViewController: UIViewController {

    var notification: PFObject!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var topicsLabel: UILabel!
    @IBOutlet weak var viewMapButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    var student: String!
    var tutor: String!
    var duration: Int!
    var subject: String!
    var mapUsed: Bool!
    var location: String!
    var read: Bool!
    
    override func viewDidLoad() {
        //notification.fetchIfNeededInBackground()
        //print(notification["type"])
        
        self.student = notification["student"] as! String
        self.tutor = notification["tutor"] as! String
        self.duration = notification["duration"] as? Int ?? 69
        self.subject = notification["subject"] as! String
        self.location = notification["location"] as? String ?? "<NO_LOCATION>"
        self.mapUsed = notification["mapUsed"] as? Bool
        self.read = notification["read"] as? Bool ?? false
        
        if(mapUsed == false){
            viewMapButton.hidden = true
        }
        
        if(read == true){
            
        }
        
        let type = notification["type"] as? String
        super.viewDidLoad()
        if(type == "appointmentRequest"){
            eventTitleLabel.text = "Tutoring session with \(student)"
            timeLabel.text = notification["time"] as? String
            locationLabel.text = location
            topicsLabel.text = notification["topics"] as? String
            dismissButton.hidden = true
            deleteButton.hidden = true
        }
        else if(type == "cancelledByStudent"){
            eventTitleLabel.text = "Appointment cancelled by \(student)"
            timeLabel.text = notification["time"] as? String
            locationLabel.text = location
            topicsLabel.text = notification["topics"] as? String
            acceptButton.hidden = true
            declineButton.hidden = true
        }
        else if(type == "cancelledByTutor"){
            eventTitleLabel.text = "Appointment cancelled by \(tutor)"
            timeLabel.text = notification["time"] as? String
            locationLabel.text = location
            topicsLabel.text = notification["topics"] as? String
            acceptButton.hidden = true
            declineButton.hidden = true
        }
        else if(type == "declinedRequest"){
            eventTitleLabel.text = "Appointment declined by \(tutor)"
            timeLabel.text = notification["time"] as? String
            locationLabel.text = location
            topicsLabel.text = notification["topics"] as? String
            acceptButton.hidden = true
            declineButton.hidden = true
        }
        else if(type == "acceptedRequest"){
            eventTitleLabel.text = "Appointment accepted by \(tutor)"
            timeLabel.text = notification["time"] as? String
            locationLabel.text = location
            acceptButton.hidden = true
            declineButton.hidden = true
        }
        else{
            print("type not recognized: \(type)")
            eventTitleLabel.text = notification["message"] as? String
            timeLabel.text = "???"
            locationLabel.text = "???"
            topicsLabel.text = "???"
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func postStudentNotification(notification : PFObject) {
        // Create Parse object PFObject
        let post = PFObject(className: "Notifications")
        
        for key in notification.allKeys {
            post[key] = notification[key]
        }
        post["type"] = "acceptedRequest"
        post.saveInBackground()
    }
    
    @IBAction func onClose(sender: AnyObject) {
        notification["read"] = true
        notification.saveInBackground()
        self.dismissViewControllerAnimated(true, completion: {})
    }

    @IBAction func onAccept(sender: AnyObject) {
        /*postAppointment(timeLabel.text, location: locationLabel.text, tutor: self.tutor, student: self.student, topics: self.tutor, duration: self.duration, subject: self.subject) { (success: Bool, error: NSError?) -> Void in
            if success {
                print("success uploading appointment")
            } else {
                print(error?.description)
            }
        }*/
        notification["type"] = "appointment"
        notification.saveInBackground()
        postStudentNotification(notification)
        self.dismissViewControllerAnimated(true, completion: {})
    }

    @IBAction func onDelete(sender: AnyObject) {
        //delete notification
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func onDecline(sender: AnyObject) {
        notification["type"] = "declinedRequest"
        notification.saveInBackground()
        self.dismissViewControllerAnimated(true, completion: {})
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextView = segue.destinationViewController as? NotificationMapViewController
        let cooridnates = CLLocationCoordinate2DMake(notification["latitude"] as! Double, notification["longitude"] as! Double)
        nextView?.coordinate = cooridnates
    }

}
