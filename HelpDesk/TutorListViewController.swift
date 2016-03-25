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
    var message: PFObject?
    
    // construct PFQuery
    var userQuery : PFQuery?
    var query : PFQuery?
    
    var sender : PFUser?
    
    override func viewWillAppear(animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        //        tableView.rowHeight = UITableViewAutomaticDimension
        //        tableView.estimatedRowHeight = 120
        userQuery = PFUser.query()
        userQuery?.whereKey("username", notEqualTo: (PFUser.currentUser()?.username)!)
        userQuery!.limit = 5
        userQuery!.findObjectsInBackgroundWithBlock { (users: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.users = users! as? [PFUser]
                self.tableView.reloadData()
            } else {
                // handle error
                print(error?.localizedDescription)
            }
        }
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
        
        
        //        let predicate1 = NSPredicate(format: "%K = %@", "receiver", PFUser.currentUser()!)
        //        let predicate2 = NSPredicate(format: "%K = %@", "sender", sender!)
        //        let predicate3 = NSPredicate(format: "%K = %@", "receiver", sender!)
        //        let predicate4 = NSPredicate(format: "%K = %@", "sender", PFUser.currentUser()!)
        //        let cPredicate1 = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        //        let cPredicate2 = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate3, predicate4])
        //        let cPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [cPredicate1, cPredicate2])
        //        userQuery?.cancel()
        //        query = PFQuery(className: "Message", predicate: cPredicate)
        //        query!.orderByDescending("createdAt")
        //        query!.limit = 1
        //        query!.getFirstObjectInBackgroundWithBlock { (message: PFObject?, error: NSError?) -> Void in
        //
        //            if error == nil {
        //                self.message = message! as PFObject
        //                self.tableView.reloadData()
        //                cell.message = message
        //
        //            } else {
        //                // handle error
        //                print(error?.localizedDescription)
        //            }
        //        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(rSegue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? UITableViewCell {
            let indexPath = tableView.indexPathForCell(cell)
            self.sender = users![indexPath!.row]
            let chatViewController = rSegue.destinationViewController as! ChatViewController
            chatViewController.receiver = self.sender
        }
        //        statusViewController.text.text = idLabel.text! as String
    }
    
    
}