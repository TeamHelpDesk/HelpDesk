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
    
    // construct PFQuery
    var query : PFQuery?
    var receiver : PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        let predicate1 = NSPredicate(format: "%K = %@", "receiver", PFUser.currentUser()!)
        let predicate2 = NSPredicate(format: "%K = %@", "sender", receiver!)
        let predicate3 = NSPredicate(format: "%K = %@", "receiver", receiver!)
        let predicate4 = NSPredicate(format: "%K = %@", "sender", PFUser.currentUser()!)
        let cPredicate1 = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        let cPredicate2 = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate3, predicate4])
        let cPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [cPredicate1, cPredicate2])
        
        query = PFQuery(className: "Message", predicate: cPredicate)
        //        query?.whereKey("receiver", equalTo: PFUser.currentUser()!)
        //        query?.whereKey("sender", equalTo: receiver!)
        //        query?.whereKey("receiver", equalTo: receiver!)
        //        query?.whereKey("sender", equalTo: PFUser.currentUser()!)
        query!.orderByAscending("createdAt")
        //query!.includeKey("sender")
        query!.limit = 15
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        onTimer()
        
        NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: "onTimer", userInfo: nil, repeats: true)
        
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
        // fetch data asynchronously
        query!.findObjectsInBackgroundWithBlock { (messages: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                self.messages = messages! as [PFObject]
                self.tableView.reloadData()
                
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
        // Add code to be run periodically
    }
    
    @IBAction func onSend(sender: AnyObject) {
        if textField.text != "" {
            Message.sendMessage(textField.text, receiver: receiver!, withCompletion: nil)
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath) as! TextCell
        cell.message = messages![indexPath.row] as PFObject
        
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
