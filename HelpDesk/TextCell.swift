//
//  TextCell.swift
//  HelpDesk
//
//  Created by Reis Sirdas on 3/25/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class TextCell: UITableViewCell {
    
    //var createdAtString: String!
    //var createdAt: NSDate!
    //var isSeen: Bool!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var seenLabel: UILabel!
    var receiver: PFUser!
    
    var message: PFObject! {
        didSet {
            if message.createdAt != nil {
                let time = NSCalendar.currentCalendar().components([.Month, .Day, .Hour, .Minute], fromDate: message!.createdAt!)
                timeLabel.text = "\(time.month)/\(time.day) \(time.hour):\(time.minute)"
            }
            timeLabel.hidden = true
            seenLabel.hidden = true
            self.messageLabel.text = message.valueForKey("text") as? String
            //print(self.isSeen)
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