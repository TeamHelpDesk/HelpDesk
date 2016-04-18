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
    var student: String!
    var tutor: String!
    var duration: Int!
    var subject: String!
    var mapUsed: Bool!
    var location: String!
    
    override func viewDidLoad() {
        //notification.fetchIfNeededInBackground()
        //print(notification["type"])
        
        self.student = notification["student"] as! String
        self.tutor = notification["tutor"] as! String
        self.duration = notification["duration"] as? Int ?? 69
        self.subject = notification["subject"] as! String
        self.location = notification["location"] as? String ?? "<NO_LOCATION>"
        self.mapUsed = notification?["mapUsed"] as? Bool

        
        let type = notification["type"] as? String
        super.viewDidLoad()
        if(type == "appointmentRequest"){
            eventTitleLabel.text = "Tutoring session with \(student)"
            timeLabel.text = notification["time"] as? String
            locationLabel.text = location
            topicsLabel.text = notification["topics"] as? String
            if(mapUsed == true){
                locationLabel.text = "Click Button to"
            } else {
                location = notification["location"] as? String
                viewMapButton.alpha = 0
            }
        }
        else if(type == "cancelledByStudent"){
            eventTitleLabel.text = "Appointment cancelled by \(student)"
            timeLabel.text = notification["time"] as? String
            locationLabel.text = location
            topicsLabel.text = notification["topics"] as? String
        }
        else if(type == "cancelledByTutor"){
            eventTitleLabel.text = "Appointment cancelled by \(tutor)"
            timeLabel.text = notification["time"] as? String
            locationLabel.text = location
            topicsLabel.text = notification["topics"] as? String
        }
        else if(type == "declinedRequest"){
            eventTitleLabel.text = "Appointment declined by \(tutor)"
            timeLabel.text = notification["time"] as? String
            locationLabel.text = location
            topicsLabel.text = notification["topics"] as? String
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
    
    func postAppointment(time: String?, location: String?, tutor: String?, student: String?, topics: String?, duration: Int?, subject: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Appointment")
        
        // Add relevant fields to the object
        post["time"] =  time
        post["location"] = location // Pointer column type that points to PFUser
        post["tutor"] = tutor
        post["student"] = student
        post["topics"] = topics
        post["duration"] = String(duration)
        post["subject"] = subject
        
        // Save object (following function will save the object in Parse asynchronously)
        
        
        
        
        post.saveInBackgroundWithBlock(completion)
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
    }

    @IBAction func onDecline(sender: AnyObject) {

        notification["type"] = "declinedRequest"
        notification.saveInBackground()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextView = segue.destinationViewController as? NotificationMapViewController
        let cooridnates = CLLocationCoordinate2DMake(notification["latitude"] as! Double, notification["longitude"] as! Double)
        nextView?.coordinate = cooridnates
    }

}
