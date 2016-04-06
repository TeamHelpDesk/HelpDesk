//
//  tutorRequestsTableViewCell.swift
//  HelpDesk
//
//  Created by Zach Glick on 4/6/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit

class tutorRequestsTableViewCell: UITableViewCell {

    @IBOutlet weak var studentLabel: UILabel!

    @IBOutlet weak var classLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    var className : String?
    var message : String?
    var studentName : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        refreshContent()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func refreshContent(){
        studentLabel.text = studentName
        classLabel.text = className
        messageLabel.text = message

    }

}
