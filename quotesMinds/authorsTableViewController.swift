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
    var slotId : Int!
    var resultSearchController = UISearchController()

    @IBOutlet var searchBar : UISearchBar!
    var shouldShowSearchResults = false

    
    struct authorObjects {
        var sectionName : String!
        var sectionObjects : [AnyObject]!
    }
    
    var titlesArray = [String]()
    var titleArraySearch = [String]()
    var authorObjectsArray = [authorObjects]()
    var authorObjectsArraySearch = [authorObjects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.authors = self.getAuthorsWithImages()
        self.populateTableViewArray()
        
        self.title = "Add new people"
        self.navigationController!.extendedLayoutIncludesOpaqueBars = true
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            //self.tableView.tableHeaderView = controller.searchBar
            
            //let viewTemp = UIView(frame: CGRectMake(0.0, 0,self.view.frame.width, 44))
            //viewTemp.addSubview(controller.searchBar)
            
            //self.view.addSubview(viewTemp);
            self.navigationItem.titleView = controller.searchBar
            
            return controller
        })()
        
        self.tableView.sectionIndexColor = UIColor.blueColor()
        self.tableView.frame = CGRectMake(0, 44, self.tableView.frame.width, self.tableView.frame.height - 44)
    }
    
    func populateTableViewArray(){
        
        self.authorObjectsArray = [authorObjects]()
        let alphabet = defaultValues().alphabet
        var names = [String]()
        var namesObj = [String:AnyObject]()
        var ids = [Int]()
        for item in self.authors{
            if let itemDict : Dictionary<String, AnyObject> = item as? Dictionary<String, AnyObject> {
                names.append(itemDict["name"] as! String);
                ids.append(itemDict["id"] as! Int);
                namesObj[itemDict["name"] as! String] = item
            }
        }
        
        var result = [String:[AnyObject]]()
        
        for letter in alphabet {
            result[letter] = []
            let matches = names.filter({ $0.hasPrefix(letter) })
            if !matches.isEmpty {
                for word in matches {
                    result[letter]?.append(namesObj[word]!)
                }
            }
        }
        
        let sortedResult = result.sort { $0.0 < $1.0 }
        self.titlesArray = [String]()
        for  itemArr in sortedResult{
            if (itemArr.1 as Array).count > 0 {
                self.titlesArray.append(itemArr.0)
                self.authorObjectsArray.append(authorObjects(sectionName: itemArr.0, sectionObjects: itemArr.1))
            }
        }

    }
    
    func populateSearchTableViewArray(search : String){
        
        self.authorObjectsArraySearch = [authorObjects]()
        let alphabet = defaultValues().alphabet
        var names = [String]()
        var namesObj = [String:AnyObject]()
        var ids = [Int]()
        for item in self.authors{
            if let itemDict : Dictionary<String, AnyObject> = item as? Dictionary<String, AnyObject> {
                if (itemDict["name"] as! String).lowercaseString.rangeOfString(search.lowercaseString) != nil {
                    names.append(itemDict["name"] as! String);
                    ids.append(itemDict["id"] as! Int);
                    namesObj[itemDict["name"] as! String] = item
                }
            }
        }
        var result = [String:[AnyObject]]()
        
        for letter in alphabet {
            result[letter] = []
            let matches = names.filter({ $0.hasPrefix(letter) })
            if !matches.isEmpty {
                for word in matches {
                    result[letter]?.append(namesObj[word]!)
                }
            }
        }
        
        let sortedResult = result.sort { $0.0 < $1.0 }
         self.titleArraySearch = [String]()
        for  itemArr in sortedResult{
            if (itemArr.1 as Array).count > 0 {
                self.titleArraySearch.append(itemArr.0)
                self.authorObjectsArraySearch.append(authorObjects(sectionName: itemArr.0, sectionObjects: itemArr.1))
            }
        }

    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        if searchController.searchBar.text != nil {
            self.populateSearchTableViewArray(searchController.searchBar.text!)
        }
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
        if (self.resultSearchController.active) {
            return  self.authorObjectsArraySearch.count
        }
        else {
            
            return self.authorObjectsArray.count
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.active) {
            return  self.authorObjectsArraySearch[section].sectionObjects.count
        }
        else {
          
            //return self.authors.count
            
            return self.authorObjectsArray[section].sectionObjects.count
        }
    }
    
        /*
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
    }
        */
   
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        if (self.resultSearchController.active) {
            return self.authorObjectsArraySearch[section].sectionName
        }
        else {

            return self.authorObjectsArray[section].sectionName
        }
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        if (self.resultSearchController.active) {
            return self.titleArraySearch
        }
        else {
            
            return self.titlesArray
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
        if (self.resultSearchController.active) {
            
            cellDict = self.authorObjectsArraySearch[indexPath.section].sectionObjects[indexPath.row] as? Dictionary<String,AnyObject>
            if let authorId = cellDict["id"] as? Int {
                cell.btnSelect.tag = authorId
                cell.btnSelect.addTarget(self, action: "pressedSelected:", forControlEvents: UIControlEvents.TouchUpInside)
                
            }
        }
        else {
            cellDict = self.authorObjectsArray[indexPath.section].sectionObjects[indexPath.row] as? Dictionary<String,AnyObject>
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
