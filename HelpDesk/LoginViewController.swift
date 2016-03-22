//
//  LoginViewController.swift
//  HelpDesk
//
//  Created by Michael Madans on 3/22/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UILabel!
    @IBOutlet weak var passwordField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!){ (user: PFUser?, error: NSError?) -> Void in
            if(user != nil){
                //self.performSegueWithIdentifier("loginSegue", sender: nil)
                print("Login Successful!")
            }
            
        }
    }

    @IBAction func onSignup(sender: AnyObject) {
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                //self.performSegueWithIdentifier("loginSegue", sender: nil)
                print("Sign up successful!")
            } else {
                print(error?.localizedDescription)
                if error?.code == 202{
                    print("Username is Taken")
                }
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
