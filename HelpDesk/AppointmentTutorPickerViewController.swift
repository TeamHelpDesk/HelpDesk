//
//  AppointmentTutorPickerViewController.swift
//  HelpDesk
//
//  Created by Zach Glick on 4/9/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class AppointmentTutorPickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var tutorings : [PFObject]?
    var onDataAvailable : ((data: Int) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tutorings = HelpDeskUser.sharedInstance.tutorings
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tutorings?.count ?? 0;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tutorSelectCell", forIndexPath: indexPath) as! AppointmentTutorSelectTableViewCell
        
        let tutoring = tutorings![indexPath.row]
    
        cell.tutor = (tutoring["tutorname"] as! String)
        cell.subject = (tutoring["subject"] as! String)
        
        cell.refresh()
        
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
                self.tutorings = appointments
                self.tableView.reloadData()
            } else {
                print("Error finding posts")
                print(error?.localizedDescription)
            }
        }
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        
        sendData(indexPath.row)
        self.dismissViewControllerAnimated(true, completion: {})
    }

    func sendData(data: Int) {
        // Whenever you want to send data back to viewController1, check
        // if the closure is implemented and then call it if it is
        self.onDataAvailable?(data: data)
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
