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
    var notification: PFObject!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
