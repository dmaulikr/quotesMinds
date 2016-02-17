//
//  loadingViewController.swift
//  everyday
//
//  Created by thiagoracca on 1/31/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit

class loadingViewController: UIViewController,userModel,quotesModel,logHelper {
    var logLevel : Int = 3
    
    var selectedArray : Array<AnyObject>!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var updateArray : Array<Int> = []
        var updateTopicArray : Array<Int> = []
        for item in self.selectedArray{
            if let itemDict : Dictionary<String,AnyObject> = item as? Dictionary<String,AnyObject>{
                if let topicId : Int = itemDict["id"] as? Int{
                    for author in self.getAuthorsWithinTopics(topicId){
                        let authorDict : Dictionary<String,AnyObject> = author as! Dictionary<String, AnyObject>
                        let authorInt : Int = authorDict["id"] as! Int
                        updateArray.append(authorInt)
                        updateTopicArray.append(topicId)
                    }
                }
            }
        }
        var avaibleSlots : Array<Int> = []
        let arrSlots = self.getAvaibleSlots()
        for item  in arrSlots{
            if let itemDict : Dictionary<String,AnyObject> = item as? Dictionary<String,AnyObject>{
                let slotInt : Int = itemDict["id"] as! Int
                avaibleSlots.append(slotInt)
            }
        }
        var i = 0;
        while(i < avaibleSlots.count){
            self.setSlot(updateArray[i], slotId: avaibleSlots[i], topicId: updateTopicArray[i])
            i++;
        }
        if(getNotificationState() == false){
            let dateInic : NSDate = NSDate()
            let df = NSDateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let datebeginString = df.stringFromDate(dateInic)
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let finalDate = formatter.dateFromString("\(datebeginString) 17:00:00")
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.changeNotificationDate(finalDate)
            self.setNotificationsOn()
        }
        sleep(3)
        self.close()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
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
