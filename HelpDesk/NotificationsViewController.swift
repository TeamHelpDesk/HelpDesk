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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NotificationsViewController.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        loadNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NotificationsViewController.loadNotifications), name: "RefreshedData", object: nil)

        
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
        
        //let sender = cell.notification["sender"] as! String
        
        //CHANGE THIS
        cell.titleLabel.text = cell.notification["message"] as? String
        
        return cell
    }
    
    func loadNotifications(){
        /*let query = PFQuery(className: "Notifications")
        //query.limit = 20
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
        }*/
        
        print("LOAD NOTIFICATIONS")
        let isStudentQuery = PFQuery(className : "Notifications")
        let isTutorQuery = PFQuery(className : "Notifications")
        let tutorCancelledQuery = PFQuery(className : "Notifications")
        let studentCancelledQuery = PFQuery(className : "Notifications")
        
        //userQuery?.includeKey("username")
        //print(HelpDeskUser.sharedInstance.username)
        isTutorQuery.whereKey("tutor", equalTo: HelpDeskUser.sharedInstance.username )
        isTutorQuery.whereKey("type", equalTo: "appointmentRequest")
        
        studentCancelledQuery.whereKey("tutor", equalTo: HelpDeskUser.sharedInstance.username )
        studentCancelledQuery.whereKey("type", equalTo: "cancelledByStudent")


        isStudentQuery.whereKey("student", equalTo: HelpDeskUser.sharedInstance.username )
        isStudentQuery.whereKey("type", equalTo: "appointmentRequest")

        tutorCancelledQuery.whereKey("student", equalTo: HelpDeskUser.sharedInstance.username )
        tutorCancelledQuery.whereKey("type", equalTo: "cancelledByTutor")

        //userQuery!.limit = 20
        
        let isPersonQuery = PFQuery.orQueryWithSubqueries([isStudentQuery, isTutorQuery, studentCancelledQuery, tutorCancelledQuery])
        
        isPersonQuery.findObjectsInBackgroundWithBlock { (notifications: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.notifications = [PFObject]()
                for notification in notifications! {
                    self.notifications?.append(notification)
                }
                self.tableView.reloadData()
                //self.refreshPeople(tutorings!)
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        HelpDeskUser.sharedInstance.refreshData()
        //loadNotifications()
        refreshControl.endRefreshing()
        
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