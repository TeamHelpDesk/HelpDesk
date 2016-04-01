//
//  HomeViewController.swift
//  HelpDesk
//
//  Created by Zach Glick on 3/25/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOut()
        NSNotificationCenter.defaultCenter().postNotificationName("UserDidLogout", object: nil)
        
    }

    @IBAction func onStudent(sender: AnyObject) {

        
    }
    
    @IBAction func onTutor(sender: AnyObject) {

    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "studentSegue"){
            let vc = storyboard!.instantiateViewControllerWithIdentifier("Appointments") as? StudentAppointmentsViewController
            vc?.isTutor = false
            print("student!")
        }
        if(segue.identifier == "tutorSegue"){
            let vc = storyboard!.instantiateViewControllerWithIdentifier("Appointments") as? StudentAppointmentsViewController
            vc?.isTutor = true
                        print("tutor!")
        }
    }


}
