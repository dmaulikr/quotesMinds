//
//  authorsTableViewController.swift
//  everyday
//
//  Created by thiagoracca on 2/3/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit

class authorsTableViewController: UITableViewController, UISearchBarDelegate,UISearchResultsUpdating,userModel,quotesModel,logHelper {
    
    var logLevel : Int = 3
    
    var authors : Array<AnyObject> = []
    var authorsSearch : Array<AnyObject> = []
    var authorsFiltered : Array<AnyObject> = []
    var slotId : Int!
    var resultSearchController = UISearchController()

    @IBOutlet var searchBar : UISearchBar!
    var shouldShowSearchResults = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add new people"
        self.navigationController!.extendedLayoutIncludesOpaqueBars = true
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.authorsSearch = self.searchAuthorsWithImages(searchController.searchBar.text!)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.showNavigation()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.authors = self.getAuthorsWithImages()
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.active) {
            return  self.authorsSearch.count
        }
        else {
            return self.authors.count
        }
    }
    
    func pressedNormal(sender: UIButton!){
        self.setSlot(sender.tag, slotId: self.slotId, topicId:self.getAuthorTopic(sender.tag))
        self.goBack()
    }
    
    func pressedSelected(sender: UIButton!){
        self.setSlot(sender.tag, slotId: self.slotId, topicId:self.getAuthorTopic(sender.tag))
        self.goBack()
        self.resultSearchController.active = false
        
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "authorsCell"
        let cell : authorsTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? authorsTableViewCell
        
        var cellDict : Dictionary<String,AnyObject>!
            self.println("authorDict \(cellDict)")
        if (self.resultSearchController.active) {
            
            cellDict = self.authorsSearch[indexPath.row] as? Dictionary<String,AnyObject>
            if let authorId = cellDict["id"] as? Int {
                cell.btnSelect.tag = authorId
                cell.btnSelect.addTarget(self, action: "pressedSelected:", forControlEvents: UIControlEvents.TouchUpInside)
                
            }
        }
        else {
            cellDict = self.authors[indexPath.row] as? Dictionary<String,AnyObject>
            if let authorId = cellDict["id"] as? Int {
                cell.btnSelect.tag = authorId
                cell.btnSelect.addTarget(self, action: "pressedNormal:", forControlEvents: UIControlEvents.TouchUpInside)
                
            }
        }
            if let authorName = cellDict["name"] as? String {
                cell.authorImage.image = UIImage(withAuthorThumb: authorName)
                cell.authorImage.roundCorners()
                cell.labelName.text = authorName
            }
       return cell
    }
    
    func goBack(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func close(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
 

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
