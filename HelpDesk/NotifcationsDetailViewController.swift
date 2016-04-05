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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTitleLabel.text = "Tutoring session with \(notification["sender"])"
        timeLabel.text = notification["time"] as? String
        locationLabel.text = notification["location"] as? String
        topicsLabel.text = notification["topics"] as? String
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
        post["sender"] = tutor
        post["recipient"] = student
        post["topics"] = topics
        post["duration"] = duration
        post["subject"] = subject
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
    }
    
    @IBAction func onAccept(sender: AnyObject) {
        postAppointment(notification["time"] as? String, location: notification["location"] as! String!, tutor: notification["sender"] as? String, student: notification["recip?ent"] as? String, topics: notification["topics"] as? String, duration: notification["duration"] as? Int, subject: notification["subject"] as? String) { (success: Bool, error: NSError?) -> Void in
            if success {
                print("success uploading appointment")
            } else {
                print(error?.description)
            }
        }
    }

    @IBAction func onDecline(sender: AnyObject) {
    
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
