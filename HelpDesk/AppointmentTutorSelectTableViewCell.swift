//
//  AppointmentTutorSelectTableViewCell.swift
//  HelpDesk
//
//  Created by Zach Glick on 4/9/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit

class AppointmentTutorSelectTableViewCell: UITableViewCell {

    var tutor : String?
    var subject : String?
    
    @IBOutlet weak var tutorLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refresh() {
        tutorLabel.text = tutor
        subjectLabel.text = subject
    }

}
