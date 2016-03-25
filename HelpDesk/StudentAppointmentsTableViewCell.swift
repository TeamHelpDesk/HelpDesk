//
//  StudentAppointmentsTableViewCell.swift
//  HelpDesk
//
//  Created by Zach Glick on 3/22/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit

class StudentAppointmentsTableViewCell: UITableViewCell {

    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appDateLabel: UILabel!
    @IBOutlet weak var appTimeLabel: UILabel!
    @IBOutlet weak var appLocationLabel: UILabel!
    
    var appName: String?
    var appDate: String?
    var appTime: String?
    var appLocation: String?
    
    
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
        appNameLabel.text = appName
        appDateLabel.text = appDate
        appTimeLabel.text = appTime
        appLocationLabel.text = appLocation
    }

}
