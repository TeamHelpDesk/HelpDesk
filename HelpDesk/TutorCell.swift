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
    //@IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var seenLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var user: PFUser! {
        didSet {
            self.senderLabel.text = user.username! as String
        }
    }
    
    var message: PFObject! {
        didSet {
            if message.createdAt != nil {
                let time = NSCalendar.currentCalendar().components([.Month, .Day, .Hour, .Minute], fromDate: message!.createdAt!)
                timeLabel.text = "\(time.month)/\(time.day) \(time.hour):\(time.minute)"
            }
            //timeLabel.hidden = true
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

