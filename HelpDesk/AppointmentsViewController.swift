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
        

        
        //HelpDeskUser.sharedInstance.refreshData()
        //CourseFunctions().addCourses()
        //CourseFunctions().assignAllCourses()
        TutoringFunctions().makeRandomTutorings()
        
        
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
        let time = appointment["time"] as! String
        let index = time.characters.indexOf(",")
        
        cell.appLocation = appointment["location"] as? String
        cell.appName = "Tutoring with \(tutor)"
       
        cell.appDate = time.substringToIndex(index!) ?? "<Missing Date>"
        cell.appTime = time.substringFromIndex(index!.advancedBy(2)) ?? "<Missing Time>"
        cell.refreshContent()
        return cell
        
        
    }
    
    func loadAppointments(){
        let query = PFQuery(className: "Appointment")
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
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "makeAppointment"){
            let nextView = segue.destinationViewController as? AppointmentMakerViewController
            nextView!.isTutor = self.isTutor
        }
    }


}
