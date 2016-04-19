//
//  RequestsClassPickerViewController.swift
//  HelpDesk
//
//  Created by Zach Glick on 4/15/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse

protocol CourseSelectDelegate
{
    func sendValue(value : String)
}

class RequestsClassPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView = UITableView()
    var tableViewWidth : Int?
    var tableViewHeight : Int?
    var courses : [String]?
    var delegate:CourseSelectDelegate!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.blueColor()
        // Do any additional setup after loading the view.
        tableView = UITableView(frame: CGRect(x: 0,y: 0,width: tableViewWidth!,height: tableViewHeight!), style: UITableViewStyle.Plain)
        self.tableView.delegate      =   self
        self.tableView.dataSource    =   self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
        loadCourses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses?.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {


        let cell = RequestsClassPickerTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        cell.label.text = courses![indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        delegate?.sendValue(courses![indexPath.row])
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func loadCourses() {
        print("LOAD ClASSES")
        let classQuery = PFQuery(className : "Course")
        
        classQuery.findObjectsInBackgroundWithBlock { (courses: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.courses = [String]()
                for course in courses! {
                    self.courses!.append(course["coursename"] as! String)
                }
                print("RELOADED DATA")
                print("courses count \(self.courses!.count)")
                self.tableView.reloadData()
                //self.refreshPeople(tutorings!)
            } else {
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
