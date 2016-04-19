//
//  AppointmentTutorPickerViewController.swift
//  HelpDesk
//
//  Created by Zach Glick on 4/9/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

protocol TutorSelectDelegate
{
    func sendValue(value : Int)
}

class AppointmentTutorPickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var tableView : UITableView = UITableView()
    var tutorings : [PFObject]?
    var delegate:TutorSelectDelegate!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect(x: 0,y: 0,width: 200,height: 300), style: UITableViewStyle.Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.registerClass(AppointmentTutorSelectTableViewCell.self, forCellReuseIdentifier: "tutorSelectCell")
        self.view.addSubview(self.tableView)
        let allTutorings = HelpDeskUser.sharedInstance.tutorings
        self.tutorings = [PFObject]()
        for tutoring in allTutorings!  {
            if tutoring["studentname"] as! String == HelpDeskUser.sharedInstance.username {
                self.tutorings?.append(tutoring)
            }
        }
        tableView.reloadData()
        
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
                
        return cell
        
        
    }

    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        
        delegate?.sendValue(indexPath.row)
        self.dismissViewControllerAnimated(true, completion: {})
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
