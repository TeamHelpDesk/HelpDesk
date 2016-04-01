//
//  NotificationsViewController.swift
//  HelpDesk
//
//  Created by Michael Madans on 3/31/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var notifications: [PFObject]?
    var isTutor: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadNotifications()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications?.count ?? 0;
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notification", forIndexPath: indexPath) as! NotifcationsTableViewCell
        
        cell.notification = self.notifications![indexPath.row]
        
        let sender = cell.notification["sender"] as! String
        
        cell.titleLabel.text = "Appointment request from \(sender)"
        
        return cell
    }
    
    func loadNotifications(){
        let query = PFQuery(className: "AppointmentRequests")
        query.limit = 20
        query.orderByDescending("_created_at")
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (notifications: [PFObject]?, error: NSError?) -> Void in
            if let notifications = notifications {
                self.notifications = notifications
                self.tableView.reloadData()
            } else {
                print("Error finding posts")
                print(error?.localizedDescription)
            }
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as? NotifcationsTableViewCell
        let notification = cell?.notification
        
        let nextView = segue.destinationViewController as? NotifcationsDetailViewController
        nextView?.notification = notification
    }
}