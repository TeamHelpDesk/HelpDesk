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
    
    var createdAtString: String?
    var createdAt: NSDate?
    var isSeen: Bool?
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var seenLabel: UILabel!
    var receiver: PFUser?
    
    var message: PFObject! {
        
        didSet {
            self.messageLabel.text = message["text"] as? String
            //createdAtString = message.createdAt as? String
            print(message.createdAt)
            //let formatter = NSDateFormatter()
            //formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
            //createdAt = formatter.dat(createdAtString!)
            let time = NSCalendar.currentCalendar().components([.Month, .Day, .Hour, .Minute], fromDate: message.createdAt!)
            timeLabel.text = "\(time.month)/\(time.day) \(time.hour):\(time.minute)"
            timeLabel.hidden = true
            isSeen = message["isSeen"] as! Bool
            receiver = message["receiver"] as! PFUser
            seenLabel.hidden = true
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
