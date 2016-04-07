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
    var messages: [PFObject]?
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    var outgoingCount: Int? = 0
    var incomingCount: Int? = 0
    
    var firstQuery: PFQuery?
    var oCountQuery: PFQuery?
    var iCountQuery: PFQuery?
    
    // construct PFQuery
    var query: PFQuery?
    var contact: PFUser?
    //let user: PFUser = PFUser.currentUser()!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        let predicate1 = NSPredicate(format: "%K = %@", "receiver", PFUser.currentUser()!)
        let predicate2 = NSPredicate(format: "%K = %@", "sender", contact!)
        
        let predicate3 = NSPredicate(format: "%K = %@", "receiver", contact!)
        let predicate4 = NSPredicate(format: "%K = %@", "sender", PFUser.currentUser()!)
        
        let cPredicate1 = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        let cPredicate2 = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate3, predicate4])
        
        let cPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [cPredicate1, cPredicate2])
        
        firstQuery = PFQuery(className: "Message", predicate: cPredicate)
        iCountQuery = PFQuery(className: "Message", predicate: cPredicate1)
        oCountQuery = PFQuery(className: "Message", predicate: cPredicate2)
        
        firstQuery!.includeKey("receiver")
        firstQuery!.orderByAscending("createdAt")
        firstQuery!.limit = 100
        
        iCountQuery!.orderByDescending("createdAt")
        iCountQuery!.limit = 1
        oCountQuery!.orderByDescending("createdAt")
        oCountQuery!.limit = 1
        
//         fetch data asynchronously
        firstQuery!.findObjectsInBackgroundWithBlock { (messages: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if messages!.count != 0 {
                    self.messages = messages! as [PFObject]
                    
//                    let indexPath = NSIndexPath(index: (self.messages?.indexOf(self.messages!.last!))!)
//                    self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
                }
                self.tableView.reloadData()
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
        
        //self.countQuery?.cancel()
        // fetch data asynchronously
        oCountQuery!.findObjectsInBackgroundWithBlock { (messages: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                self.outgoingCount = 1
                if messages!.count != 0 {
                    self.outgoingCount = messages?.first!["count"] as? Int
                    self.outgoingCount = self.outgoingCount! + 1
                }
            } else {
                self.outgoingCount = 1
                // handle error
                print(error?.localizedDescription)
            }
            
        }
        iCountQuery!.findObjectsInBackgroundWithBlock { (messages: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                self.incomingCount = 0
                if messages!.count != 0 {
                    self.incomingCount = messages?.first!["count"] as? Int
                }
            } else {
                self.incomingCount = 0
                // handle error
                print(error?.localizedDescription)
            }
            
        }
        
        //let predicate = NSPredicate(format: "%K > %@", "count", incomingCount!)
        //let cPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [cP1!, predicate])
        query = PFQuery(className: "Message", predicate: cPredicate1)
        //        query?.whereKey("receiver", equalTo: PFUser.currentUser()!)
        //        query?.whereKey("sender", equalTo: receiver!)
        //        query?.whereKey("receiver", equalTo: receiver!)
        //        query?.whereKey("sender", equalTo: PFUser.currentUser()!)
        query!.orderByAscending("createdAt")
        query!.limit = 15
        query!.includeKey("receiver")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        //onTimer()
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onTimer", userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        query?.cancel()
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
        query?.whereKey("count", greaterThan: incomingCount!)
        print(self.incomingCount)
        // fetch data asynchronously
        query!.findObjectsInBackgroundWithBlock { (messages: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if self.messages == nil {
                    self.messages = messages! as [PFObject]
                } else {
                    self.messages!.appendContentsOf(messages! as [PFObject])
                }
                if messages!.count != 0 {
                    self.incomingCount = messages?.last!["count"] as? Int
//                    let indexPath = NSIndexPath(index: (self.messages?.indexOf(self.messages!.last!))!)
//                    self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
                }
                //
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
            let message = Message.saveMessage(textField.text, receiver: contact!, count: outgoingCount!)
            outgoingCount = outgoingCount! + 1
            messages?.append(message)
            self.tableView.reloadData()
            Message.sendMessage(message, withCompletion: nil)
//            let indexPath = NSIndexPath(index: (self.messages?.indexOf(self.messages!.last!))!)
//            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath) as! TextCell
        cell.timeLabel.hidden = false
        if cell.isSeen! && cell.receiver == contact {
            cell.seenLabel.text = "Seen"
        } else if !cell.isSeen! && cell.receiver == contact {
            cell.seenLabel.text = "Delivered"
        }
    
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath) as! TextCell
        cell.message = messages![indexPath.row] as PFObject
        if cell.message["receiver"].username == PFUser.currentUser()!.username {
            cell.backgroundColor = UIColor.clearColor()
            cell.messageLabel.textColor = UIColor.blackColor()
            cell.messageLabel.textAlignment = NSTextAlignment.Left
        } else {
            cell.message["isSeen"] = true
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
