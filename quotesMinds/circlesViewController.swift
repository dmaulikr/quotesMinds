//
//  circlesViewController.swift
//  everyday
//
//  Created by thiagoracca on 1/24/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit

class circlesViewController: UIViewController,logHelper,quotesModel,userModel {
    var logLevel : Int = 3
    
    @IBOutlet var bg : UIImageView?
    
    @IBOutlet var slot0 : UIImageView?
    @IBOutlet var slot1 : UIImageView?
    @IBOutlet var slot2 : UIImageView?
    @IBOutlet var slot3 : UIImageView?
    @IBOutlet var slot4 : UIImageView?
    @IBOutlet var slot5 : UIImageView?
    @IBOutlet var label0 : UILabel?
    @IBOutlet var label1 : UILabel?
    @IBOutlet var label2 : UILabel?
    @IBOutlet var label3 : UILabel?
    @IBOutlet var label4 : UILabel?
    @IBOutlet var label5 : UILabel?
    @IBOutlet var btn0 : authorButton?
    @IBOutlet var btn1 : authorButton?
    @IBOutlet var btn2 : authorButton?
    @IBOutlet var btn3 : authorButton?
    @IBOutlet var btn4 : authorButton?
    @IBOutlet var btn5 : authorButton?
    @IBOutlet var xbtn0 : UIButton?
    @IBOutlet var xbtn1 : UIButton?
    @IBOutlet var xbtn2 : UIButton?
    @IBOutlet var xbtn3 : UIButton?
    @IBOutlet var xbtn4 : UIButton?
    @IBOutlet var xbtn5 : UIButton?
    @IBOutlet var buttonCounter : UIButton!
    
    var coverViews : Array<UIView> = []
    var arrButtons : Array<authorButton> = []
    var arrXButtons : Array<UIButton> = []
    var arrSlots : Array<UIImageView> = []
    var arrLabels : Array<UILabel> = []
    var colorBackgrounds : Array<UIColor>?
    var selectedId : Int = 0;
    var imageBg : UIImage!
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showWiki() {
        guard let arr : Array<AnyObject> = self.getAuthorInSlot(self.selectedId) else {return}
        guard let authorName : String = arr[0]["name"] as? String else {return}
        let author = authorName.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let svc = customSafariViewController(URL: NSURL(string: "https://en.wikipedia.org/wiki/\(author)")!)
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
    func putEditButton(){
        self.navigationItem.titleView = nil
        let b = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "startEditing")
        self.navigationItem.setRightBarButtonItems([b], animated: true)
    }
    
    func putDoneButton(){
        let b = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "finishEditing")
        let d = UIBarButtonItem(title: "Reset", style: .Plain, target: self, action: "reset")
        self.navigationItem.setRightBarButtonItems([b,d], animated: true)
    }
    
    func startEditing(){
        self.putDoneButton()
        self.putNamesOfTopics()
        let slotsArr : Array = self.getAllSlots()
        for item in arrSlots{
            visualObject().startToShake(item)
        
        }
        var i = 0;
        for item in self.arrXButtons {
            UIView.animateWithDuration(0.3, animations: {
                if let itemAuthor = slotsArr[i]["author_id"] as? Int{
                    if(itemAuthor != 0){
                        item.userInteractionEnabled = true
                        item.alpha = 1.0
                    }
                }
            })
            i++;
           
        }
    }
    
    func finishEditing(){
        self.putEditButton()
        self.putNamesOfAuthors()
        for item in arrSlots{
            visualObject().stopToShake(item)
          
        }
        for item in self.arrXButtons {
            
            item.userInteractionEnabled = false
            UIView.animateWithDuration(0.3, animations: {
               
                item.alpha = 0
            })
            
        }
    }
    
    func reset(){
        let alert = UIAlertController(title: "Confirm", message: "all your authors will be unselected", preferredStyle: UIAlertControllerStyle.Alert)
        let erase = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action: UIAlertAction) -> Void in
            self.eraseAllSlots()
            self.dismissViewControllerAnimated(true, completion: nil)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(erase)
        alert.addAction(cancel)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageDict : Dictionary = getQuote()
        if let imageName : String = imageDict["name"]! as String{
            bg!.image = UIImage(withAuthor: imageName)
            bg!.addDarkBlur()
        }
        
        self.arrSlots = [self.slot0!,self.slot1!,self.slot2!,self.slot3!,self.slot4!,self.slot5!]
        self.arrXButtons = [self.xbtn0!,self.xbtn1!,self.xbtn2!,self.xbtn3!,self.xbtn4!,self.xbtn5!]
        self.arrButtons = [self.btn0!,self.btn1!,self.btn2!,self.btn3!,self.btn4!,self.btn5!]
        self.coverViews = [UIView(),UIView(),UIView(),UIView(),UIView(),UIView()]
        self.arrLabels = [self.label0!,self.label1!,self.label2!,self.label3!,self.label4!,self.label5!]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.eraseNavigation()
     
        var iTag = 0;
        for item in self.arrXButtons {
            item.roundCorners()
            item.userInteractionEnabled = false
            item.alpha = 0
            item.addTarget(self, action: "deleteAction:", forControlEvents: UIControlEvents.TouchUpInside)
            item.tag = iTag
            iTag++;
        }
        self.putEditButton()
        for item in coverViews{
            item.removeFromSuperview()
        }
        let authorsArr : Array = self.getAllSlots()
        var i = 0;
        for item in authorsArr{
             if let authorId : Int = item["author_id"] as? Int{
                if(authorId != 0){
                let authorDetails = self.getAuthor(authorId)
                    if let imageName : String = authorDetails[0]["name"] as? String{
                        arrSlots[i].image = UIImage(withAuthor: imageName)
                        arrSlots[i].roundCorners()
                        arrLabels[i].text = imageName;
                        arrLabels[i].ajustsSize();
                        coverViews[i].removeFromSuperview()
                        coverViews[i] = (UIView(frame: arrSlots[i].bounds))
                        coverViews[i].removeFromSuperview()
                        arrSlots[i].addSubview(coverViews[i]);
                        coverViews[i].backgroundColor = defaultValues().colors[i]
                        arrButtons[i].setImage(UIImage(), forState: UIControlState.Normal)
                        arrButtons[i].userInteractionEnabled = true
                        arrButtons[i].backgroundColor = UIColor.clearColor()
                        arrButtons[i].tag = i
                        arrButtons[i].stateVal = true
                        arrSlots[i].userInteractionEnabled = true
                    }
                }
                else
                {
                    arrSlots[i].roundCorners()
                    arrXButtons[i].alpha = 0
                    arrXButtons[i].userInteractionEnabled = false
                    arrButtons[i].alpha = 1
                    arrButtons[i].userInteractionEnabled = true
                    arrButtons[i].backgroundColor = UIColor.clearColor()
                    arrButtons[i].tag = i
                    arrButtons[i].stateVal = false
                    coverViews[i].backgroundColor = UIColor.clearColor()
                    arrLabels[i].adjustsFontSizeToFitWidth=true;
                    arrLabels[i].minimumScaleFactor = 0.5
                    arrLabels[i].text = ""
                }
            }
            i++;
        }
        self.checkSelectedAuthor()
    }
    
    func putNamesOfTopics(){
        let topicArr : Array = self.getAllSlots()
        var i = 0;
        self.println("topicArr \(topicArr)")
        for item in topicArr{
            if let topicId : Int = item["topic_id"] as? Int{
                if(topicId != 0){
                    let topicDetails = self.getTopic(topicId)
                    if let topicName : String = topicDetails[0]["name"] as? String{
                         self.changeTextAnimated(arrLabels[i], text: topicName)
                    }
                }
                else
                {
                    self.changeTextAnimated(arrLabels[i], text: "")
                }
            }
            i++;
        }
    }
    
    func putNamesOfAuthors(){
        let authorsArr : Array = self.getAllSlots()
        var i = 0;
        for item in authorsArr{
            if let authorId : Int = item["author_id"] as? Int{
                if(authorId != 0){
                    let authorDetails = self.getAuthor(authorId)
                    if let imageName : String = authorDetails[0]["name"] as? String{
                        
                       self.changeTextAnimated(arrLabels[i], text: imageName)
                    }
                }
                else
                {
                    self.changeTextAnimated(arrLabels[i], text: "")
                }
            }
            i++;
        }
    }
    
    func changeTextAnimated( label : UILabel, text : String){
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            label.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                label.text = text
                UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    label.alpha = 1.0
                    }, completion: nil)
        })
    }
    
    func checkSelectedAuthor(){
        let missing : Int = 6 - self.countSelectedAuthors()
        if(missing > 0){
            self.buttonCounter.setTitle("select \(missing) categories", forState: UIControlState.Normal)
            self.buttonCounter.alpha = 1
            self.buttonCounter.userInteractionEnabled = true
        }
        else
        {
            self.buttonCounter.alpha = 0
            self.buttonCounter.userInteractionEnabled = false
        }
    }
    
    @IBAction func addAction(sender: authorButton){
        self.selectedId = sender.tag
        if(sender.stateVal){
            self.showWiki()
        }
        else
        {
            self.performSegueWithIdentifier("showAuthors", sender: self)
        }
    }
    
    func deleteAction(sender : UIButton!){
        let alert = UIAlertController(title: "Confirm", message: "this author will be unselected", preferredStyle: UIAlertControllerStyle.Alert)
        let erase = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action: UIAlertAction) -> Void in
            self.arrButtons[sender.tag].stateVal = false
            self.arrXButtons[sender.tag].userInteractionEnabled = false
            UIView.animateWithDuration(0.3, animations: {
                self.arrXButtons[sender.tag].alpha = 0
                self.arrSlots[sender.tag].image = nil
                self.arrXButtons[sender.tag].userInteractionEnabled = false
                self.arrButtons[sender.tag].setImage(UIImage(named: "icon_addNew"), forState: UIControlState.Normal)
                self.coverViews[sender.tag].backgroundColor = UIColor.clearColor()
                self.arrLabels[sender.tag].text = ""
            })
            self.eraseSlot(sender.tag)
            self.checkSelectedAuthor()
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(erase)
        alert.addAction(cancel)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        self.println("segue .indetifier \(segue!.identifier)")
        
        if segue!.identifier == "showAuthors" {
            let navigationController : UINavigationController = segue!.destinationViewController as! UINavigationController
            let viewController : authorsTableViewController = navigationController.viewControllers.first as! authorsTableViewController
            viewController.slotId = self.selectedId
        }
        else if segue!.identifier == "selectCategories" {
            let navigationController : UINavigationController = segue!.destinationViewController as! UINavigationController
            let viewController : categoriesTableViewController = navigationController.viewControllers.first as! categoriesTableViewController
            viewController.putClose = true
        }
    }
}