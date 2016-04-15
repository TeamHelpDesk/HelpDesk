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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        let predicate1 = NSPredicate(format: "%K = %@", "receiver", PFUser.currentUser()!)
        let predicate2 = NSPredicate(format: "%K = %@", "sender", contact!)
        
        //let predicate3 = NSPredicate(format: "%K = %@", "receiver", contact!)
        //let predicate4 = NSPredicate(format: "%K = %@", "sender", PFUser.currentUser()!)
        
        let cPredicate1 = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        //let cPredicate2 = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate3, predicate4])
        
        //let cPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [cPredicate1, cPredicate2])
        
        
        
        query = PFQuery(className: "Message", predicate: cPredicate1)
        query!.orderByAscending("createdAt")
        query!.limit = 15
        query!.includeKey("receiver")

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        //onTimer()
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onTimer", userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    @IBAction func onSignOut() {
        PFUser.logOut()
        //let vc = s.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
        //window?.rootViewController = vc
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
        cell.timeLabel.hidden = false
        if cell.message.valueForKey("isSeen") as! Bool == true && cell.message.valueForKey("receiver")!.username == contact!.username {
            cell.seenLabel.text = "Seen"
            cell.seenLabel.hidden = false
        } else if cell.message.valueForKey("isSeen") as! Bool == false && cell.message.valueForKey("receiver")!.username == contact!.username {
            cell.seenLabel.text = "Delivered"
            cell.seenLabel.hidden = false
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TextCell
        cell.seenLabel.hidden = true
        cell.timeLabel.hidden = true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath) as! TextCell
        cell.message = messages![indexPath.row] as PFObject
        if cell.message.valueForKey("receiver")?.username == PFUser.currentUser()!.username {
            cell.backgroundColor = UIColor.clearColor()
            cell.messageLabel.textColor = UIColor.blackColor()
            cell.messageLabel.textAlignment = NSTextAlignment.Left
            if cell.message.valueForKey("isSeen") as! Bool == false {
                //self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
                cell.message.setValue(true, forKey: "isSeen")
                //cell.message["isSeen"] = true
                cell.message.saveEventually()
            }
            
        } else {
            cell.backgroundColor = UIColor.greenColor()
            cell.messageLabel.textColor = UIColor.brownColor()
            cell.messageLabel.textAlignment = NSTextAlignment.Right
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