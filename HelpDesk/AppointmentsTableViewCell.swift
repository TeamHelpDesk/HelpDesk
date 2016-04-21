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
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var appSubjectLabel: UILabel!
    @IBOutlet weak var appTopicsLabel: UILabel!
    @IBOutlet weak var subjectPic: UIImageView!
    @IBOutlet weak var viewOnMap: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    
    
    var appName: String?
    var appDate: String?
    var appTime: String?
    var appSubject : String?
    var appTopics : String?
    var appLocation: String?
    var appointment: PFObject?
    var mapUsed: Bool?
    var lat: Double?
    var long: Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if(mapUsed == false){
            viewOnMap.alpha = 0
        }
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.None

        profilePic.layer.borderWidth = 1
        profilePic.layer.borderColor = UIColor.blueColor().CGColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        subjectPic.layer.borderWidth = 1
        subjectPic.layer.borderColor = UIColor.blueColor().CGColor
        subjectPic.layer.cornerRadius = profilePic.frame.height/2
        subjectPic.clipsToBounds = true
        
        viewOnMap.layer.cornerRadius = 5
        viewOnMap.clipsToBounds = true
        cancelButton.layer.cornerRadius = 5
        cancelButton.clipsToBounds = true
        
        refreshContent()
        
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        postNotif("cancel", message: "\(HelpDeskUser.sharedInstance.username!) cancelled their appointment" ) { (success: Bool, error: NSError?) -> Void in
            if success {
                //print("success cancelling appointment")
            } else {
                print(error?.description)
            }
        }
    }
    
    
    func postNotif(type: String?, message: String?, withCompletion completion: PFBooleanResultBlock?) {
        
        //let post = PFObject(className: "Notifications")
        //post["message"] = message
        //post["type"] = type
        //post.saveInBackgroundWithBlock(completion)

        
        if(appointment!["tutor"] as! String == HelpDeskUser.sharedInstance.username){
            appointment!["type"] = "cancelledByTutor"
        }
        else if (appointment!["student"] as! String == HelpDeskUser.sharedInstance.username) {
            appointment!["type"] = "cancelledByStudent"
        }
        else {
            print("ERROR NO TUTOR/STUDENT")
        }
        
        appointment?.saveInBackgroundWithBlock(completion)
        
        // Save object (following function will save the object in Parse asynchronously)
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
        appSubjectLabel.text = appSubject
        appTopicsLabel.text = appTopics
    }
    

}
