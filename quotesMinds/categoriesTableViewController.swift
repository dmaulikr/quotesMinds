//
//  categoriesTableViewController.swift
//  everyday
//
//  Created by thiagoracca on 1/24/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit

class categoriesTableViewController: UITableViewController,quotesModel,userModel,logHelper {
    
    var logLevel : Int = 3
    
    
    var topics : Array<AnyObject> = Array()
    var topicSelected : Array<Int> = Array()
    var limit : Int = 6
    
    var putClose : Bool = false

    
    func getTopicSelected(index: Int) -> Int{
        return topicSelected[index]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        self.topics = self.getTopics()
        for _ in self.topics{
           self.topicSelected.append(0)
        }
        self.limit = self.countFreeSlots()
        self.howManyLeft()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.println("putClose State");
        if(self.putClose){
           self.putBtnClose()
        }
        
        /*
        ** Pre Selects all Selected Slots
        
        guard let arr : Array<AnyObject> = self.getSelectedSlots() else {return}
      
        for item in arr{
            guard let itemDict : Dictionary<String,AnyObject> = item as? Dictionary<String,AnyObject> else {return}
            guard let topicId : Int = itemDict["topic_id"] as? Int else {return}
            if topicId-1 < topicSelected.count {
                topicSelected[topicId-1] = 1
            }
        }
        */
        
    }
    
    func putBtnClose(){
        self.navigationItem.titleView = nil
        let b = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "close:")
        self.navigationItem.setLeftBarButtonItems([b], animated: false)
    }
    
    func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewWillDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.countTopics()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dictDetails : Dictionary<String,AnyObject> = self.topics[indexPath.row] as! Dictionary<String, AnyObject>
        let identifier = "categoryCell"
        let cell : categoriesTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? categoriesTableViewCell
        cell.dict = dictDetails
        cell.startCell(indexPath, tableView: self)
        if indexPath.row < defaultValues().imagesBg.count {
            cell.imageBg.image = UIImage(namedClean: defaultValues().imagesBg[indexPath.row])
        }
        cell.clipsToBounds = true;
        return cell!
    }
    
    
    /*
    /Overrideo support conditional editing of the table view.
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
    
    func howManyLeft(){
        if(self.limit > 0){
        let title : String = "select \(self.limit) categories";
            self.navigationItem.title = title
            self.navigationItem.setRightBarButtonItem(nil, animated: true)
        }
        else
        {
            self.navigationItem.title = ""
            let b = UIBarButtonItem(title: "Continue", style: .Plain, target: self, action: "justContinue:")
            self.navigationItem.setRightBarButtonItem(b, animated: true)
        }
    }
    
    func getSelectedTopics() -> Array<AnyObject>{
        var array : Array<AnyObject> = []
        var i = 0;
        for item in self.topics{
            if (self.topicSelected[i] == 1){
                array.append(item)
            }
            i++;
        }
        return array
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        if segue!.identifier == "showLoading" {
            let viewController : loadingViewController = segue!.destinationViewController as! loadingViewController
            viewController.selectedArray = self.getSelectedTopics()
        }
    }
    
    func justContinue(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showLoading", sender: self)
    }
}
