//
//  RequestMakerViewController.swift
//  HelpDesk
//
//  Created by Zach Glick on 4/6/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class RequestMakerViewController: UIViewController,
UIPopoverPresentationControllerDelegate, CourseSelectDelegate {

    
    var className = "physics"
    var selectedClassName : String?
    
    @IBOutlet weak var selectedCourse: UILabel!
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
        
        postTutoringRequest(self.className, message: messageField.text) { (success: Bool, error: NSError?) -> Void in
            if success {
                //print("success uploading request")
            } else {
                print(error?.description)
            }
        }
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func postTutoringRequest(className: String?, message: String?, completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        
        let userQuery = PFUser.query()
        //The Request is sent to all users
        //Should be sent to all tutors of the class (who aren't already tutoring the user maybe?)
        userQuery?.whereKey("username", notEqualTo: (PFUser.currentUser()?.username)!)
        userQuery!.limit = 20
        userQuery!.findObjectsInBackgroundWithBlock { (tutors: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                var count = 0

                for tutor in tutors! {
                    
                    let tutoredCourses = tutor["tutoredCourses"] as? [String] ?? [String]()
                    
                    if(self.selectedClassName != nil && tutoredCourses.contains(self.selectedClassName!)) {
                        count += 1
                        
                        let post = PFObject(className: "Tutoring")
                        post["type"] =  "request"
                        post["subject"] =  self.selectedClassName ?? "(No class selected)"
                        post["message"] =  message ?? "(No message)"
                        post["tutor"] =  tutor
                        post["student"] = HelpDeskUser.sharedInstance.user
                        
                        tutor.fetchIfNeededInBackgroundWithBlock {
                            (object: PFObject?, error:NSError?) -> Void in
                            if error == nil {
                                post["tutorname"] = object!["username"]
                            }
                        }
                        
                        
                        post["studentname"] = HelpDeskUser.sharedInstance.username
                        post.saveInBackgroundWithBlock(completion)
                    }
                    
                    
                }
                
                print("sent requests to \(count) tutors for \(self.selectedClassName)")

                
                
                
                
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
        
        // Add relevant fields to the object
        
        //post["studentName"] = sender!.username as String!
        //post["recipient"] = recipient!.username as String!
        
        // Save object (following function will save the object in Parse asynchronously)
        
    }

    @IBAction func onClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    @IBAction func onSelectClass(sender: AnyObject) {
        let menuViewController =  RequestsClassPickerViewController()
        menuViewController.modalPresentationStyle = .Popover
        menuViewController.preferredContentSize = CGSizeMake(200, 300)
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = (self.view as UIView)
        popoverMenuViewController?.sourceRect = CGRect(
            x: UIScreen.mainScreen().bounds.width/2 ,
            y: UIScreen.mainScreen().bounds.height/2 ,
            width: 0,
            height: 0)
        print("\(UIScreen.mainScreen().bounds.width)  \(UIScreen.mainScreen().bounds.height)")
        menuViewController.tableViewWidth = 200
        menuViewController.tableViewHeight = 300
        menuViewController.delegate = self;
        presentViewController(
            menuViewController,
            animated: true,
            completion: nil)
    }
    
    
    func sendValue(value: String) {
        
        selectedClassName = value;
        selectedCourse.text = value;
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
