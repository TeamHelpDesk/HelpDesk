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
    
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var declineButton: UIButton!
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var subjectPic: UIImageView!
    @IBOutlet weak var bottomConstrainL: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraintR: NSLayoutConstraint!
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
        
        profilePic.layer.borderWidth = 1
        profilePic.layer.borderColor = UIColor.blueColor().CGColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        subjectPic.layer.borderWidth = 1
        subjectPic.layer.borderColor = UIColor.blueColor().CGColor
        subjectPic.layer.cornerRadius = profilePic.frame.height/2
        subjectPic.clipsToBounds = true

    }

}
