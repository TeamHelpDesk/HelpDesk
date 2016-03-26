//
//  StudentTutorTableViewCell.swift
//  HelpDesk
//
//  Created by Zach Glick on 3/25/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class StudentTutorTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    
    var tutor : PFObject?
    var name : String?
    var subject : String?
    var profileImage : UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func refreshContent(){
        nameLabel.text = name
        subjectLabel.text = subject
    }

}
