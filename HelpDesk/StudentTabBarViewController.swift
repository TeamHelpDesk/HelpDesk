//
//  StudentTabBarViewController.swift
//  HelpDesk
//
//  Created by Michael Madans on 3/29/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit

class StudentTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextView = segue.destinationViewController as? StudentAppointmentsViewController
        nextView!.isTutor = false
    }


}
