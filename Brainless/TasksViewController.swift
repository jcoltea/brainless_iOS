//
//  TasksViewController.swift
//  Brainless
//
//  Created by Julian Coltea on 5/25/15.
//  Copyright (c) 2015 JulianColtea. All rights reserved.
//

import UIKit

class TasksViewController: UITableViewController {
    
    var theTasks: [String] = [];
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn");
        if (isUserLoggedIn)
        {
            println("user is logged in")
            self.populateTasks();
            tableView.reloadData()
        }
        else
        {
            println("User not logged in")
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "taskCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        let myTask = theTasks[indexPath.row] as String
        cell!.textLabel?.text = myTask
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theTasks.count
    }
    
    
    func populateTasks() {
        let myUrl = NSURL(string: "http://67.175.161.233:8888/tasks");
        let request = NSMutableURLRequest(URL: myUrl!);
        request.HTTPMethod = "GET";
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, err) in
            
            if (err != nil)
            {
                println("error=\(err)");
                return;
            }
            self.theTasks = []
            var jsonError: NSError?
            let myJSONData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as! NSArray

            for myTask in myJSONData {
                let myUserName = NSUserDefaults.standardUserDefaults().objectForKey("userName") as? String;
                let myOtherUser = myTask.objectForKey("userName") as? String;
                if (myUserName != nil && myOtherUser != nil)
                {
                    if (myUserName! == myOtherUser!)
                    {
                        let title = myTask.objectForKey("description") as? String;
                        if (title != nil)
                        {
                            self.theTasks.append(title!);
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        populateTasks()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    
}
