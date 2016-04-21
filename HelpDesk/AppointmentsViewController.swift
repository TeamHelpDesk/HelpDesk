//
//  StudentAppointmentsViewController.swift
//  HelpDesk
//
//  Created by Zach Glick on 3/22/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class AppointmentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var appointments : [PFObject]?
    var isTutor: Bool!
    var selectedRowIndex = -1
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.backgroundColor = UIColor.blueColor().CGColor
        tableView.backgroundColor = UIColor.blueColor()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(AppointmentsViewController.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppointmentsViewController.loadAppointments), name: "RefreshedData", object: nil)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 115.0
        //Utility Functions (Do not delete)
        //HelpDeskUser.sharedInstance.refreshData()
        //CourseFunctions().addCourses()
        //CourseFunctions().assignAllCourses()
        //TutoringFunctions().makeRandomTutorings()

        loadAppointments()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments?.count ?? 0;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == selectedRowIndex {
            return UITableViewAutomaticDimension
        }
        //change this
        return 100
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
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! AppointmentsTableViewCell
        cell.cancelButton.backgroundColor = UIColor.redColor()
        cell.viewOnMap.backgroundColor = UIColor.blueColor()

        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentAppointmentCell", forIndexPath: indexPath) as! AppointmentsTableViewCell
        
        let appointment = appointments![indexPath.row]
        let tutor = appointment["tutor"] as! String
        let student = appointment["student"] as! String
        let time = appointment["time"] as! String
        let index = time.characters.indexOf(",")
        let subject = appointment["subject"] as! String
        let location = appointment["location"] as! String
        var personname : String!
        var person : PFUser!
        
        let userQuery = PFQuery(className: "_User")
        if(tutor != HelpDeskUser.sharedInstance.username) {
            personname = tutor
        }
        else {
            personname = student
        }
        userQuery.whereKey("username", equalTo: personname)
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
                
                
                //cell.subjectPic.image = UIImage(named: "science")

                
                let image = UIImage(named: subject)
                
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

                
                
                
            } else {
                print(error?.localizedDescription)
            }
        }

        if((appointment["mapUsed"] as? Bool) == false){
            cell.appLocation = appointment["location"] as? String
            cell.mapUsed = false
            cell.viewOnMap.hidden = true
        } else{
            cell.mapUsed = true
            cell.lat = appointment["latitude"] as? Double
            cell.long = appointment["longitude"] as? Double
        }
        cell.appLocation = location
        cell.appointment = appointment
        cell.appDate = time.substringToIndex(index!) ?? "<Missing Date>"
        cell.appTime = time.substringFromIndex(index!.advancedBy(2)) ?? "<Missing Time>"
        cell.appSubject = subject
        cell.appTopics = appointment["topics"] as? String
        if(student == HelpDeskUser.sharedInstance.username) {
            cell.appName = "Getting tutored by \(tutor)"
        }
        else if (tutor == HelpDeskUser.sharedInstance.username) {
            cell.appName = "Tutoring \(student)"
        }
        else {
            print("ERROR: USER IS NOT STUDENT OR TUTOR IN APPOINTMENT")
        }

        cell.refreshContent()
        
        cell.layer.borderWidth = 4
        cell.layer.borderColor = UIColor.blueColor().CGColor
        return cell
    }
    
    func loadAppointments(){

        print("LOAD APPOINTMENTS")
        let isStudentQuery = PFQuery(className : "Notifications")
        let isTutorQuery = PFQuery(className : "Notifications")
        
        //userQuery?.includeKey("username")
        //print(HelpDeskUser.sharedInstance.username)
        isTutorQuery.whereKey("tutor", equalTo: HelpDeskUser.sharedInstance.username )
        isStudentQuery.whereKey("student", equalTo: HelpDeskUser.sharedInstance.username )
        //userQuery!.limit = 20
        
        let isPersonQuery = PFQuery.orQueryWithSubqueries([isStudentQuery, isTutorQuery])
        isPersonQuery.whereKey("type", equalTo: "appointment")
        
        isPersonQuery.findObjectsInBackgroundWithBlock { (appointments: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.appointments = [PFObject]()
                for appointment in appointments! {
                    self.appointments?.append(appointment)
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
        //loadAppointments
        refreshControl.endRefreshing()

    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "viewApptMap"){
            let cell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!) as! AppointmentsTableViewCell
            let nextView = segue.destinationViewController as? NotificationMapViewController
            print(cell.description)
            print(cell.lat!)
            print(cell.long!)
            let cooridnates = CLLocationCoordinate2DMake(cell.lat!, cell.long!)
            nextView?.coordinate = cooridnates
        }
    }


}
