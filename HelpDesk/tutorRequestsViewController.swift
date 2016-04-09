//
//  tutorRequestsViewController.swift
//  HelpDesk
//
//  Created by Zach Glick on 4/6/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class tutorRequestsViewController: UIViewController, UITableViewDelegate,
UITableViewDataSource{

    var requests : [PFObject]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadRequests()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests?.count ?? 0;
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
        
        UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tutorRequestCell", forIndexPath: indexPath) as! tutorRequestsTableViewCell
        
 
        let request = requests![indexPath.row]
            
        let className = request["subject"] as! String
        let message = request["message"] as! String
        let studentName = request["studentname"] as! String

            
        cell.className = className
        cell.message = message
        cell.studentName = studentName
 
        cell.refreshContent()
        
            
        return cell
        
        
    }
    
    
    func loadRequests(){
        let query = PFQuery(className: "Tutoring")
        query.whereKey("type", equalTo: "request")
        query.whereKey("tutorname", equalTo: HelpDeskUser.sharedInstance.username)
        query.limit = 20
        query.orderByDescending("_created_at")
        
        print("Loading Requests")
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (requests: [PFObject]?, error: NSError?) -> Void in
            if let requests = requests {
                print("Found \(requests.count) Requests")
                // do something with the array of object returned by the call
                self.requests = requests
                self.tableView.reloadData()
                
                
            } else {
                print("Error finding requests")
                print(error?.localizedDescription)
            }
            
            
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
