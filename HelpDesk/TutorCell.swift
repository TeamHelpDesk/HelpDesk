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
    
//    var message: PFObject! {
//        didSet {
//            self.messageLabel.text = message["text"] as? String
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

