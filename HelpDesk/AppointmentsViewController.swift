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
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(AppointmentsViewController.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppointmentsViewController.loadAppointments), name: "RefreshedData", object: nil)

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
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentAppointmentCell", forIndexPath: indexPath) as! AppointmentsTableViewCell
        
        let appointment = appointments![indexPath.row]
        let tutor = appointment["tutor"] as! String
        let student = appointment["student"] as! String
        let time = appointment["time"] as! String
        let index = time.characters.indexOf(",")
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
                
                
            } else {
                print(error?.localizedDescription)
            }
        }


        cell.appLocation = appointment["location"] as? String
        cell.appointment = appointment
        cell.appDate = time.substringToIndex(index!) ?? "<Missing Date>"
        cell.appTime = time.substringFromIndex(index!.advancedBy(2)) ?? "<Missing Time>"
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
    
        return cell
        
        
    }
    
    func loadAppointments(){
        /*let query = PFQuery(className: "Appointment")
        query.limit = 20
        query.orderByDescending("_created_at")
        
        //print("Loading Posts")
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (appointments: [PFObject]?, error: NSError?) -> Void in
            if let appointments = appointments {
                //print("Found \(appointments.count) posts")
                self.appointments = appointments
                self.tableView.reloadData()
            } else {
                print("Error finding posts")
                print(error?.localizedDescription)
            }
        }*/
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
        if(segue.identifier == "makeAppointment"){
            //let nextView = segue.destinationViewController as? AppointmentMakerViewController
            //nextView!.isTutor = self.isTutor
        }
    }


}
