//
//  TutorListViewController.swift
//  HelpDesk
//
//  Created by Reis Sirdas on 3/25/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class TutorListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var users : [PFUser]?
    var messages: [PFObject]?
    var firstQuery: PFQuery?
    var userQuery : PFQuery?
    var query : PFQuery?
    var contact : PFUser?
    var timer1: NSTimer?
    var timer2: NSTimer?
    
    override func viewWillAppear(animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        let p1 = NSPredicate(format: "%K = %@", "receiver", PFUser.currentUser()!)
        let p2 = NSPredicate(format: "%K = %@", "sender", PFUser.currentUser()!)
        let cP1 = NSCompoundPredicate(orPredicateWithSubpredicates: [p1, p2])
        userQuery = PFUser.query()
        userQuery?.whereKey("username", notEqualTo: (PFUser.currentUser()?.username)!)
        userQuery!.limit = 20
        userQuery!.findObjectsInBackgroundWithBlock { (users: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.users = users! as? [PFUser]
                self.tableView.reloadData()
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
        firstQuery = PFQuery(className: "Message", predicate: cP1)
        firstQuery!.includeKey("receiver")
        firstQuery!.includeKey("sender")
        firstQuery?.whereKey("isDelivered", equalTo: true)
        firstQuery!.orderByAscending("createdAt")
        firstQuery!.limit = 100
        //         fetch data asynchronously
        firstQuery!.findObjectsInBackgroundWithBlock { (messages: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if messages != nil {
                    self.messages = messages! as [PFObject]
                }
                self.tableView.reloadData()
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
        query = PFQuery(className: "Message", predicate: p1)
        query!.orderByAscending("createdAt")
        query!.limit = 100
        query!.includeKey("receiver")
        query!.includeKey("sender")
        timer1 = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onTimer", userInfo: nil, repeats: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        //query?.cancel()
        userQuery?.cancel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users != nil {
            return users!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TutorCell", forIndexPath: indexPath) as! TutorCell
        cell.user = users![indexPath.row] as PFUser
        cell.seenLabel.hidden = true
        cell.timeLabel.hidden = true
        cell.messageLabel.text = "No messages."
        if messages != nil {
            for message in messages! {
                if message.valueForKey("sender")?.username == PFUser.currentUser()!.username && message.valueForKey("receiver")!.username == cell.user.username {
                    cell.message = message
                    if cell.message.valueForKey("isSeen") as! Bool == true {
                        cell.seenLabel.text = "Seen"
                    } else {
                        cell.seenLabel.text = "Delivered"
                        timer2 = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onTimer2", userInfo: cell, repeats: true)
                    }
                    cell.timeLabel.hidden = false
                    cell.seenLabel.hidden = false
                } else if message.valueForKey("sender")!.username == cell.user.username && message.valueForKey("receiver")!.username == PFUser.currentUser()!.username {
                    cell.message = message
                    cell.timeLabel.hidden = false
                    if message.valueForKey("isSeen") as! Bool == false {
                        cell.newCount += 1
                        if cell.newCount != 0 {
                            print("new count")
                            var notification = UILocalNotification()
                            notification.alertBody = "You have received \(cell.newCount) messages from \(cell.user.username)" // text that will be displayed in the notification
                            notification.fireDate = nil
                            notification.alertAction = "open"
                            notification.applicationIconBadgeNumber = cell.newCount
                            notification.soundName = UILocalNotificationDefaultSoundName // play default sound
                            UIApplication.sharedApplication().scheduleLocalNotification(notification)
                        }
                    }
                }
            }
            cell.newCount = 0
        }
        return cell
    }
    
    func onTimer() {
        self.query?.cancel()
        query?.whereKey("isSeen", equalTo: false)
        query?.whereKey("isDelivered", equalTo: false)
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
            var cell = timer2!.userInfo as! TutorCell
            
            cell.message.fetchInBackground()
            if cell.message.valueForKey("isSeen") as! Bool == true && cell.message.valueForKey("receiver")!.username == contact!.username {
                cell.seenLabel.text = "Seen"
                timer2!.invalidate()
            } else if cell.message.valueForKey("isSeen") as! Bool == false && cell.message.valueForKey("receiver")!.username == contact!.username {
                cell.seenLabel.text = "Delivered"
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(rSegue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? TutorCell {
            let indexPath = tableView.indexPathForCell(cell)
            self.contact = users![indexPath!.row]
            let chatViewController = rSegue.destinationViewController as! ChatViewController
            chatViewController.contact = self.contact
            for message in messages! {
                if ((message.valueForKey("sender")?.username == PFUser.currentUser()!.username && message.valueForKey("receiver")!.username == chatViewController.contact!.username) || (message.valueForKey("sender")!.username == chatViewController.contact!.username && message.valueForKey("receiver")!.username == PFUser.currentUser()!.username)) {
                    if chatViewController.messages == nil {
                        chatViewController.messages = [message]
                    } else {
                        chatViewController.messages.append(message)
                    }
                }
            }
        }
    }
}