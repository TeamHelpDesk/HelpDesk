//
//  StudentAppointmentsTableViewCell.swift
//  HelpDesk
//
//  Created by Zach Glick on 3/22/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit

class StudentAppointmentsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var appointmentNameLabel: UILabel!
    @IBOutlet weak var appointmentDateLabel: UILabel!
    @IBOutlet weak var appointmentHourLabel: UILabel!
    @IBOutlet weak var appointmentLocationLabel: UILabel!
    
    var name : String?
    var date : String?
    var hour : String?
    var location : String?
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        appointmentNameLabel.text = name
        appointmentDateLabel.text = date
        appointmentHourLabel.text = hour
        appointmentLocationLabel.text = location
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refreshLabels() {
        appointmentNameLabel.text = name
        appointmentDateLabel.text = date
        appointmentHourLabel.text = hour
        appointmentLocationLabel.text = location
    }
    
    
    
    

}
