//
//  RequestsClassPickerTableViewCell.swift
//  HelpDesk
//
//  Created by Zach Glick on 4/15/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit

class RequestsClassPickerTableViewCell: UITableViewCell {

    var label : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
       
        label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
  

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("in table view cell")
        label.center = CGPointMake(100, 15)
        label.textAlignment = NSTextAlignment.Center
        //label.text = "I'm a test label"
        self.addSubview(label)
        // Configure the view for the selected state
    }

}
