//
//  RequestMakerViewController.swift
//  HelpDesk
//
//  Created by Zach Glick on 4/6/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class RequestMakerViewController: UIViewController {

    
    var className : String?
    
    @IBOutlet weak var messageField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSubmit(sender: AnyObject) {
        
        postAppointmentRequest(self.className, message: messageField.text, sender: PFUser.currentUser(), recipient: PFUser.currentUser()) { (success: Bool, error: NSError?) -> Void in
            if success {
                print("success uploading request")
            } else {
                print(error?.description)
            }
        }
    }
    
    func postAppointmentRequest(className: String?, message: String?, sender: PFUser?, recipient: PFUser?, completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "TutorRequests")
        
        // Add relevant fields to the object
        post["className"] =  className ?? "(No class selected)"
        post["message"] =  message ?? "(No message)"
        post["studentName"] = sender!.username as String!
        post["recipient"] = recipient!.username as String!
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
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
