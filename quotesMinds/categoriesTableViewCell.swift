//
//  categoriesTableViewCell.swift
//  everyday
//
//  Created by thiagoracca on 1/27/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit

class categoriesTableViewCell: UITableViewCell,userModel,logHelper{
    var logLevel = 0;
    
    @IBOutlet var btn : UIButton!
    @IBOutlet var imageBg : UIImageView!
    var tableView : categoriesTableViewController!
    var indexPath : NSIndexPath!
    var dict : Dictionary<String,AnyObject> = Dictionary()
    
    @IBAction func pressName(sender: AnyObject) {
        self.tableView.howManyLeft()
        if (self.tableView.topicSelected[indexPath.row] == 0){
            if(0 != self.tableView.limit){
                self.tableView.topicSelected[indexPath.row] = 1
                self.tableView.limit--
            }
            else
            {
                limitActions()
            }
        }
        else{
      
            self.tableView.topicSelected[indexPath.row] = 0
            self.tableView.limit++
        }
        self.determineButton()
    }
    
    func limitActions(){
        let alert = UIAlertController(title: "Limit", message: "You reached the maximun of categories", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.tableView.presentViewController(alert, animated: true, completion: nil)
    }
    
    func determineButton(){
        self.tableView.howManyLeft()
        self.determineButtonState()
    }
    
    func determineButtonState(){
        if (self.tableView.topicSelected[indexPath.row] == 0){
            btn.roundWhiteBorderCorners()
        }
        else{
            btn.roundSelectedBorderCorners()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func startCell(indexPath : NSIndexPath, tableView: categoriesTableViewController){
        self.indexPath = indexPath
        self.tableView = tableView
        let name : String = dict["name"] as! String;
        let attributedText : NSAttributedString = NSAttributedString(string: name, attributes: nil)
        btn.setAttributedTitle(attributedText, forState: UIControlState.Normal)
        self.determineButton()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

