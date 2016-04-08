//
//  StudentAppointmentsTableViewCell.swift
//  HelpDesk
//
//  Created by Zach Glick on 3/22/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class AppointmentsTableViewCell: UITableViewCell {

    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appDateLabel: UILabel!
    @IBOutlet weak var appTimeLabel: UILabel!
    @IBOutlet weak var appLocationLabel: UILabel!
    
    var appName: String?
    var appDate: String?
    var appTime: String?
    var appLocation: String?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        refreshContent()
        
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        postNotif("cancel", message: "\(PFUser.currentUser()?.username!) cancelled their appointment" ) { (success: Bool, error: NSError?) -> Void in
            if success {
                print("success sending late")
            } else {
                print(error?.description)
            }
        }
    }
    
    
    func postNotif(type: String?, message: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Notifications")
        
        // Add relevant fields to the object
        post["message"] = message
        post["type"] = type
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refreshContent(){
        appNameLabel.text = appName
        appDateLabel.text = appDate
        appTimeLabel.text = appTime
        appLocationLabel.text = appLocation
    }

}
