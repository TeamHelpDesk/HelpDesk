//
//  NotifcationsDetailViewController.swift
//  HelpDesk
//
//  Created by Michael Madans on 3/31/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class NotifcationsDetailViewController: UIViewController {

    var notification: PFObject!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var topicsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAccept(sender: AnyObject) {
    
    }

    @IBAction func onDecline(sender: AnyObject) {
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
