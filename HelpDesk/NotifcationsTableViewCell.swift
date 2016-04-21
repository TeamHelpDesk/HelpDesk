//
//  NotifcationsTableViewCell.swift
//  HelpDesk
//
//  Created by Michael Madans on 3/31/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class NotifcationsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ribbon: UIView!
    @IBOutlet weak var unreadImage: UIImageView!
    var read: Bool?
    var notification: PFObject!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.None

        ribbon.layer.cornerRadius = 7
        ribbon.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
