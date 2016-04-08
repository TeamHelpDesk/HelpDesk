//
//  StudentTabBarViewController.swift
//  HelpDesk
//
//  Created by Michael Madans on 3/29/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit

class UserTabBarViewController: UITabBarController {

    //var isTutor : Bool
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabItems = self.tabBar.items! as [UITabBarItem]
        let tabItem0 = tabItems[0] as UITabBarItem
        let tabItem1 = tabItems[1] as UITabBarItem
        let tabItem2 = tabItems[2] as UITabBarItem
        let tabItem3 = tabItems[3] as UITabBarItem
        let tabItem4 = tabItems[4] as UITabBarItem
        tabItem0.title = "Appointments"
        tabItem1.title = "Messages"
        tabItem2.title = "Notifications"
        tabItem3.title = "Request"
        tabItem4.title = "Profile"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let nextView = segue.destinationViewController as? StudentAppointmentsViewController
        //nextView!.isTutor = false
    }


}
