//
//  LoginViewController.swift
//  HelpDesk
//
//  Created by Michael Madans on 3/22/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
  
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var signup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PFUser.logOut()
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        login.layer.cornerRadius = 6
        login.clipsToBounds = true
        signup.layer.cornerRadius = 6
        signup.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
                // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        
        //print("The username field contains: \(usernameField.text)")
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!){ (user: PFUser?, error: NSError?) -> Void in
            
            if(user != nil){
                if(HelpDeskUser.sharedInstance.loggedOut){
                    //Someone logged out
                    HelpDeskUser.sharedInstance.refreshData()
                }
                else {
                    //First time login
                    _ = HelpDeskUser.sharedInstance
                }
            self.performSegueWithIdentifier("loginSegue", sender: nil)
                print("You logged in with username \(self.usernameField.text)")
            }
                
            
            else{
              print(error?.localizedDescription)
            }
            
        }
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
