//
//  StudentTutorsViewController.swift
//  HelpDesk
//
//  Created by Zach Glick on 3/25/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

class StudentTutorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tutors : [PFObject]?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadTutors()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tutors?.count ?? 0;
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentTutorCell", forIndexPath: indexPath) as! StudentTutorTableViewCell
        
        let tutor = tutors![indexPath.row]
        
        cell.name = tutor["name"] as! String
        cell.subject = tutor["subject"] as! String

        cell.refreshContent()
        return cell
        
        
    }
    
    func loadTutors(){
        let query = PFQuery(className: "tutor_list")
        query.limit = 20
        //query.orderByDescending("_created_at")
        
        print("Loading Tutors")
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (tutors: [PFObject]?, error: NSError?) -> Void in
            if let tutors = tutors {
                print("Found \(tutors.count) tutors")
                // do something with the array of object returned by the call
                self.tutors = tutors
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    

}
