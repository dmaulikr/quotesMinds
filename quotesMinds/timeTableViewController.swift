//
//  timeTableViewController.swift
//  everyday
//
//  Created by thiagoracca on 1/30/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit

class timeTableViewController: UITableViewController, logHelper,userModel {
    
    var logLevel = 0;
    
    @IBOutlet weak var date: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date.addTarget(self, action: "changedAction", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func addNotification(sender: UISwitch) {
        if(sender.on){
            self.setNotificationsOn()
            self.changedAction()
            
        }
        else
        {
            self.setNotificationsOff()
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
    }
    
    func changedAction() {
      if(getNotificationState()){
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.changeNotificationDate(date.date)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.showNavigation()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        if(getNotificationState()){
            if let timeNotification = self.getLastNotification() {
                self.println("lastNotification \(timeNotification)")
                let strTime: String? = timeNotification["date"] as? String
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateTime = formatter.dateFromString(strTime!)
                date.setDate(dateTime!, animated: false)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.eraseNavigation()
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
