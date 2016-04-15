//
//  RequestsClassPickerViewController.swift
//  HelpDesk
//
//  Created by Zach Glick on 4/15/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit

class RequestsClassPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView : UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.blueColor()
        // Do any additional setup after loading the view.
        tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
        //tableView.delegate      =   self
        //tableView.dataSource    =   self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:RequestsClassPickerTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! RequestsClassPickerTableViewCell
        
        //cell.textLabel.text = "Hello World"
        
        return cell
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
