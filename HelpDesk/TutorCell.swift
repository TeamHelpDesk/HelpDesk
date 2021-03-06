//
//  TutorCell.swift
//  HelpDesk
//
//  Created by Reis Sirdas on 3/25/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class TutorCell: UITableViewCell {
    
    
    @IBOutlet weak var senderLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var seenLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    var newCount: Int = 0
    
    var user: PFUser! {
        didSet {
            self.senderLabel.text = user.username! as String
            let picObject = user!["profPicture"] as? [PFFile]
            if picObject != nil{
                //print("found pic object")
                if let picFile = picObject?[0] {
                    picFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            self.profileImage.image = UIImage(data:imageData!)
                            self.profileImage.layer.borderWidth = 1
                            self.profileImage.layer.borderColor = UIColor.blueColor().CGColor
                            self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2
                            self.profileImage.clipsToBounds = true
                        }
                        else {
                            print("Error Fetching Profile Pic")
                        }
                    }
                }
            }
            else {
                self.profileImage.image = nil
                print("No profile picture")
            }
        }
    }
    
    var message: PFObject! {
        didSet {
            if message.createdAt != nil {
                let time = NSCalendar.currentCalendar().components([.Month, .Day, .Hour, .Minute], fromDate: message!.createdAt!)
                timeLabel.text = "\(time.month)/\(time.day) \(time.hour):\(time.minute)"
            }
            seenLabel.hidden = true
            self.messageLabel.text = message.valueForKey("text") as? String
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

