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
    
    var tutorLabel : UILabel
    var subjectLabel : UILabel
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("selected \(tutor) \(subject)")
        tutorLabel.text = tutor
        subjectLabel.text = subject
        tutorLabel.center = CGPointMake(50, 15)
        tutorLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(tutorLabel)
        subjectLabel.center = CGPointMake(150, 15)
        subjectLabel.textAlignment = NSTextAlignment.Center
        //label.text = "I'm a test label"
        self.addSubview(subjectLabel)


        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        tutorLabel = UILabel(frame: CGRectMake(0, 0, 200, 21))
        subjectLabel = UILabel(frame: CGRectMake(0, 0, 200, 21))
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        tutorLabel = UILabel(frame: CGRectMake(0, 0, 200, 21))
        subjectLabel = UILabel(frame: CGRectMake(0, 0, 200, 21))
        super.init(coder: aDecoder)
    }
    
    
    func refresh() {

    }

}
