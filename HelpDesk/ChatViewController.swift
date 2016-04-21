//
//  ChatViewController.swift
//  HelpDesk
//
//  Created by Reis Sirdas on 3/25/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    var messages: [PFObject]!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    var query: PFQuery?
    var contact: PFUser?
    var timer1: NSTimer?
    var timer2: NSTimer?
    @IBOutlet weak var navigation: UINavigationBar!
    @IBOutlet weak var fieldParentView: UIView!
    var initialY: CGFloat!
    var offset: CGFloat!

    @IBOutlet weak var profilePic: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        navigation.topItem?.title = contact?.username
//        profilePic.layer.borderWidth = 1
//        profilePic.layer.borderColor = UIColor.blueColor().CGColor
//        profilePic.layer.cornerRadius = profilePic.frame.height/2
//        profilePic.clipsToBounds = true
        let predicate1 = NSPredicate(format: "%K = %@", "receiver", PFUser.currentUser()!)
        let predicate2 = NSPredicate(format: "%K = %@", "sender", contact!)
        let cPredicate1 = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        query = PFQuery(className: "Message", predicate: cPredicate1)
        query!.orderByAscending("createdAt")
        query!.limit = 15
        query!.includeKey("receiver")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onTimer", userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
        initialY = fieldParentView.frame.origin.y

    }
    
    override func viewDidAppear(animated: Bool) {
        let picObject = contact!["profPicture"] as? [PFFile]
        if picObject != nil{
            //print("found pic object")
            if let picFile = picObject?[0] {
                picFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        self.profilePic.image = UIImage(data:imageData!)
                        self.profilePic.layer.borderWidth = 1
                        self.profilePic.layer.borderColor = UIColor.blueColor().CGColor
                        self.profilePic.layer.cornerRadius = self.profilePic.frame.height/2
                        self.profilePic.clipsToBounds = true
                    }
                    else {
                        print("Error Fetching Profile Pic")
                    }
                }
            }
        }
        else {
            self.profilePic.image = nil
            print("No profile picture")
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    func keyboardWillShow(notification: NSNotification!) {
        
        if let userInfo = notification.userInfo {
//            let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//            
//            offset = -frame.origin.y
//            fieldParentView.frame.origin.y = initialY + offset
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrame?.origin.y >= UIScreen.mainScreen().bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 9.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 9.0
            }
            UIView.animateWithDuration(duration,
                                       delay: NSTimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
            
        }
    }
    
    func keyboardWillHide(notification: NSNotification!) {
//        //fieldParentView.frame.origin.y = initialY
//        fieldParentView.frame.origin.y = initialY + offset
    if let userInfo = notification.userInfo {
        //            let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        //
        //            offset = -frame.origin.y
        //            fieldParentView.frame.origin.y = initialY + offset
        let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
        let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
        let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
        if endFrame?.origin.y >= UIScreen.mainScreen().bounds.size.height {
            self.keyboardHeightLayoutConstraint?.constant = 9.0
        } else {
            self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 9.0
        }
        UIView.animateWithDuration(duration,
            delay: NSTimeInterval(0),
            options: animationCurve,
            animations: { self.view.layoutIfNeeded() },
            completion: nil)
        
    }
    }

    func onTimer() {
        self.query?.cancel()
        query?.whereKey("isSeen", equalTo: false)
        // fetch data asynchronously
        query!.findObjectsInBackgroundWithBlock { (messages: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if messages?.count != 0 {
                    if self.messages == nil {
                        self.messages = messages
                    } else {
                        self.messages!.appendContentsOf(messages! as [PFObject])
                    }
                    for message in messages! {
                        message.setValue(true, forKey: "isDelivered")
                        message.saveEventually()
                    }
                    
                }
                self.tableView.reloadData()
                self.query?.cancel()
            } else {
                self.query?.cancel()
                // handle error
                print("\(error?.localizedDescription) something wrong with timer")
            }
            
        }
        // Add code to be run periodically
    }
    
    func onTimer2() {
        if timer2?.valid == true {
            var cell = timer2!.userInfo as! TextCell
            cell.message.fetchInBackground()
            if cell.message.valueForKey("isSeen") as! Bool == true && cell.message.valueForKey("isDelivered") as! Bool == true && cell.message.valueForKey("receiver")!.username == contact!.username {
                cell.seenLabel.text = "Seen"
                timer2!.invalidate()
            } else if cell.message.valueForKey("isSeen") as! Bool == false && cell.message.valueForKey("isDelivered") as! Bool == true && cell.message.valueForKey("receiver")!.username == contact!.username {
                cell.seenLabel.text = "Delivered"
            } else {
                cell.seenLabel.text = "Sent"
            }
            cell.seenLabel.hidden = false
        }
    }
    
    @IBAction func onSend(sender: AnyObject) {
        if textField.text != "" {
            self.query?.cancel()
            let message = Message.saveMessage(textField.text, receiver: contact!)
            if messages == nil {
                messages = [message]
            } else {
                messages?.append(message)
            }
            Message.sendMessage(message, withCompletion: nil)
            print("message sent")
            self.tableView.reloadData()
            textField.text = ""
        }
    }
    
    @IBAction func onExit(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: {})
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages != nil {
            return messages!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TextCell
        cell.message = messages![indexPath.row] as PFObject
        cell.message.fetchInBackground()

        if cell.message.valueForKey("isSeen") as! Bool == true && cell.message.valueForKey("receiver")!.username == contact!.username {
            cell.seenLabel.text = "Seen"
            cell.seenLabel.hidden = false
        } else if cell.message.valueForKey("isSeen") as! Bool == false && cell.message.valueForKey("isDelivered") as! Bool == true && cell.message.valueForKey("receiver")!.username == contact!.username {
            cell.seenLabel.text = "Delivered"
            timer2 = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onTimer2", userInfo: cell, repeats: true)
            cell.seenLabel.hidden = false
        } else if cell.message.valueForKey("isSeen") as! Bool == false && cell.message.valueForKey("isDelivered") as! Bool == false && cell.message.valueForKey("receiver")!.username == contact!.username {
            cell.seenLabel.text = "Sent"
            timer2 = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onTimer2", userInfo: cell, repeats: true)
            cell.seenLabel.hidden = false
        }
        cell.timeLabel.hidden = false
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TextCell
        cell.seenLabel.hidden = true
        cell.timeLabel.hidden = true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath) as! TextCell
        cell.message = messages![indexPath.row] as PFObject
        if PFUser.currentUser() != nil {
            if cell.message.valueForKey("receiver")?.username == PFUser.currentUser()!.username {
                cell.backgroundColor = UIColor.clearColor()
                cell.messageLabel.textColor = UIColor.blackColor()
                if cell.message.valueForKey("isSeen") as! Bool == false {
                    //self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
                    cell.message.setValue(true, forKey: "isSeen")
                    cell.message.saveEventually()
                }
            } else {
                cell.backgroundColor = UIColor.greenColor()
                cell.messageLabel.textColor = UIColor.brownColor()
            }
        }
        return cell
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrame?.origin.y >= UIScreen.mainScreen().bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animateWithDuration(duration,
                                       delay: NSTimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
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