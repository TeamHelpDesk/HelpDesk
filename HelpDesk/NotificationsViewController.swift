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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
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
        let notification = self.notifications![indexPath.row]
        let type = notification["type"] as! String
        
        cell.notification = notification
        
        //let sender = cell.notification["sender"] as! String
        
        //CHANGE THIS
        
        if(type == "cancelledByStudent"){
            cell.titleLabel.text = "Appointment cancelled by \(notification["student"])"
            cell.ribbon.backgroundColor = UIColor.redColor()
        }
        else if(type == "cancelledByTutor"){
            cell.titleLabel.text = "Appointment cancelled by \(notification["tutor"])"
            cell.ribbon.backgroundColor = UIColor.redColor()
        }
        else if(type == "appointmentRequest"){
            cell.titleLabel.text = "Appointment request from \(notification["student"])"
            cell.ribbon.backgroundColor = UIColor.blueColor()
        }
        else if(type == "declinedRequest"){
            cell.titleLabel.text = "Appointment declined by \(notification["tutor"])"
            cell.ribbon.backgroundColor = UIColor.yellowColor()
        }
        else if(type == "acceptedRequest"){
            cell.titleLabel.text = "Appointment accepted by \(notification["tutor"])"
            cell.ribbon.backgroundColor = UIColor.greenColor()
        }
        else {
            cell.titleLabel.text = "Type \(notification["type"]) not recognized"
            cell.ribbon.hidden = true
            print("Type \(notification["type"]) not recognized")
        }
        let read = notification["read"] as? Bool ?? false 
        if(read == true){
            cell.unreadImage.hidden = true
        }
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
        //let isStudentQuery = PFQuery(className : "Notifications")
        let isTutorQuery = PFQuery(className : "Notifications")
        let tutorDeclinedQuery = PFQuery(className : "Notifications")
        let tutorCancelledQuery = PFQuery(className : "Notifications")
        let studentCancelledQuery = PFQuery(className : "Notifications")
        let tutorAcceptedQuery = PFQuery(className : "Notifications")
        
        //userQuery?.includeKey("username")
        //print(HelpDeskUser.sharedInstance.username)
        isTutorQuery.whereKey("tutor", equalTo: HelpDeskUser.sharedInstance.username )
        isTutorQuery.whereKey("type", equalTo: "appointmentRequest")
        
        tutorDeclinedQuery.whereKey("student", equalTo: HelpDeskUser.sharedInstance.username )
        tutorDeclinedQuery.whereKey("type", equalTo: "declinedRequest")
        
        studentCancelledQuery.whereKey("tutor", equalTo: HelpDeskUser.sharedInstance.username )
        studentCancelledQuery.whereKey("type", equalTo: "cancelledByStudent")


        //isStudentQuery.whereKey("student", equalTo: HelpDeskUser.sharedInstance.username )
        //isStudentQuery.whereKey("type", equalTo: "appointmentRequest")

        tutorCancelledQuery.whereKey("student", equalTo: HelpDeskUser.sharedInstance.username )
        tutorCancelledQuery.whereKey("type", equalTo: "cancelledByTutor")
        
        tutorAcceptedQuery.whereKey("student", equalTo: HelpDeskUser.sharedInstance.username )
        tutorAcceptedQuery.whereKey("type", equalTo: "acceptedRequest")

        //userQuery!.limit = 20
        
        let isPersonQuery = PFQuery.orQueryWithSubqueries([isTutorQuery, tutorDeclinedQuery, studentCancelledQuery, tutorCancelledQuery, tutorAcceptedQuery])
        
        isPersonQuery.findObjectsInBackgroundWithBlock { (notifications: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.notifications = [PFObject]()
                for notification in notifications! {
                    //print("tutor: \(notification["tutor"])    student: \(notification["student"])    type: \(notification["type"])   username: \(HelpDeskUser.sharedInstance.username)")
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
        nextView?.view.backgroundColor = cell!.ribbon.backgroundColor
    }
}