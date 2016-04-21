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
    var selectedRowIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(tutorRequestsViewController.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(tutorRequestsViewController.loadRequests), name: "RefreshedData", object: nil)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300.0
        
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
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        print(indexPath.row)
        

        
        if indexPath.row == selectedRowIndex {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? tutorRequestsTableViewCell {
                //cell.bottomConstrainL.active = true
                // cell.bottomConstraintR.active = true
            }
            return UITableViewAutomaticDimension
        }
        else{
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? tutorRequestsTableViewCell {
                //cell.bottomConstrainL.active = false
                //cell.bottomConstraintR.active = false
            }
            return 103
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.selectedRowIndex != -1 {
            //self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: self.selectedRowIndex, inSection: 0))?.backgroundColor = UIColor.whiteColor()
        }
        
        if selectedRowIndex != indexPath.row {
            //table.thereIsCellTapped = true
            self.selectedRowIndex = indexPath.row
            
        }
        else {
            // there is no cell selected anymore
            //self.thereIsCellTapped = false
            self.selectedRowIndex = -1
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! tutorRequestsTableViewCell
        //cell.cancelButton.backgroundColor = UIColor.redColor()
        //cell.viewOnMap.backgroundColor = UIColor.blueColor()
        
        tableView.beginUpdates()
        tableView.endUpdates()
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
        var person : PFUser!
        let userQuery = PFQuery(className: "_User")
       
        userQuery.whereKey("username", equalTo: studentName)
        userQuery.getFirstObjectInBackgroundWithBlock { (user: PFObject?, error: NSError?) -> Void in
            if error == nil {
                person = user as! PFUser
                let picObject = person["profPicture"] as? [PFFile]
                    
                if picObject != nil{
                    //print("found pic object")
                    if let picFile = picObject?[0] {
                        picFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                            if (error == nil) {
                                cell.profilePic.image = UIImage(data:imageData!)
                            }
                            else {
                                print("Error Fetching Profile Pic")
                            }
                        }
                    }
                }
                    
                    
            } else {
                print(error?.localizedDescription)
            }
        }
            
            
        let image = UIImage(named: className)
            
            //print("\(image?.size.height) \(image?.size.width)")
        let size = CGSizeApplyAffineTransform(image!.size, CGAffineTransformMakeScale(0.35, 0.35))
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
            
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image!.drawInRect(CGRect(origin: CGPointZero, size: size))
            
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
            
        cell.subjectPic.contentMode = UIViewContentMode.Center
        cell.subjectPic.image = scaledImage
        cell.subjectPic.backgroundColor = UIColor.grayColor()
            
            
            
            
        cell.className = className
        cell.message = message
        cell.studentName = "\(studentName) requested a tutor"
 
        cell.refreshContent()
            
        cell.acceptButton.tag = indexPath.row
        cell.acceptButton.addTarget(self, action: #selector(tutorRequestsViewController.onAccept(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
        cell.declineButton.tag = indexPath.row
            
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
            
            
        return cell
        
    }
    
    @IBAction func onAccept(sender: AnyObject) {
        //Uncomment if the cell is needed
        //let cell : tutorRequestsTableViewCell?
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if (superview.superview as? tutorRequestsTableViewCell != nil){
                    //cell = superview.superview as? tutorRequestsTableViewCell

                    //Update Parse
                    let request = requests![sender.tag]
                    request["type"] = NSNull()
                    request["message"] = NSNull()
                    request.saveInBackground()
                    
                    //Update Table View
                    requests?.removeAtIndex(sender.tag)
                    tableView.reloadData()
                    
                    //Add a Notification?
                }
            }
        }
        
    }
    
    @IBAction func onDecline(sender: AnyObject) {
        //Uncomment if the cell is needed
        //let cell : tutorRequestsTableViewCell?
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if (superview.superview as? tutorRequestsTableViewCell != nil){
                    //cell = superview.superview as? tutorRequestsTableViewCell

                    //Update Parse
                    let request = requests![sender.tag]
                    request.deleteInBackground()
                    
                    //Update Table View
                    requests?.removeAtIndex(sender.tag)
                    tableView.reloadData()
                 
                    //Add a Notificaiton?
                }
            }
        }
    }
    func loadRequests(){
        print("LOAD REQUESTS")

        let query = PFQuery(className: "Tutoring")
        query.whereKey("type", equalTo: "request")
        //Why does this code call init()
        query.whereKey("tutorname", equalTo: HelpDeskUser.sharedInstance.username)
        query.limit = 20
        query.orderByDescending("_created_at")
        
        //print("Loading Requests")
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (requests: [PFObject]?, error: NSError?) -> Void in
            if let requests = requests {
                //print("Found \(requests.count) Requests")
                // do something with the array of object returned by the call
                self.requests = requests
                self.tableView.reloadData()
                
                
            } else {
                print("Error finding requests")
                print(error?.localizedDescription)
            }
            
            
        }
        
    }
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        HelpDeskUser.sharedInstance.refreshData()
        //loadRequests()
        refreshControl.endRefreshing()
        
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
