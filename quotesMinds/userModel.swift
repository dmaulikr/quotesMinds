//
//  userModel.swift
//  everyday
//
//  Created by thiagoracca on 1/25/16.
//  Copyright © 2016 vupe. All rights reserved.
//

protocol userModel {
    func println(str: String);
    func println(str: String, level: Int);
}

extension userModel{
    
    func getAllSlots() -> Array<AnyObject>!{
        let sql0 : String = "SELECT * FROM slots"
        let arr0 : Array<AnyObject> = userDatabaseController.sharedInstance.performQuery(sql0)
        return arr0
    }
    
    func getSelectedSlots() -> Array<AnyObject>!{
        let sql0 : String = "SELECT * FROM slots WHERE author_id != 0"
        let arr0 : Array<AnyObject> = userDatabaseController.sharedInstance.performQuery(sql0)
        return arr0
        
    }

    func getSelectedAuthors() -> Array<AnyObject>!{
        let sql0 : String = "SELECT * FROM slots"
        let arr0 : Array<AnyObject> = userDatabaseController.sharedInstance.performQuery(sql0)
        
        var arrId : Array<String> = []
        for item  in arr0{
            let itemDict : Dictionary<String,Int> = item as! Dictionary<String,Int>
            arrId.append("\(itemDict["author_id"]!)")
        }
        
        let stringToAdd = arrId.joinWithSeparator(",");
        let sql1 : String = "SELECT * FROM authors WHERE id IN (\(stringToAdd))"
        let arr1 : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql1)
        return arr1
        
    }
    
    
    
    func countSelectedAuthors() -> Int{
        
        
        let sql : String = "SELECT count(id) as id FROM slots WHERE author_id != 0"
        let arr : Array<AnyObject> = userDatabaseController.sharedInstance.performQuery(sql)
        
        if (arr.count > 0){
            let arr0 : Dictionary<String,AnyObject> = arr[0] as! Dictionary<String,AnyObject>
            return arr0["id"] as! Int
        }
        else
        {
            return 0
        }
    }
    
    func countFreeSlots() -> Int{
        
        
        let sql : String = "SELECT count(id) as id FROM slots WHERE author_id = 0"
        let arr : Array<AnyObject> = userDatabaseController.sharedInstance.performQuery(sql)
        
        if (arr.count > 0){
            let arr0 : Dictionary<String,AnyObject> = arr[0] as! Dictionary<String,AnyObject>
            return arr0["id"] as! Int
        }
        else
        {
            return 0
        }
    }
    
    func getAvaibleSlots() -> Array<AnyObject>{
        
        
        let sql : String = "SELECT id FROM slots WHERE author_id = 0"
        if let arr : Array<AnyObject> = userDatabaseController.sharedInstance.performQuery(sql) {
            
            return arr
        }
        else
        {
            return []
        }
    }
    
    func getSelectedAuthorsPosts(quantityAuthors : Int, _ quantityPosts : Int) -> Array<AnyObject>{
        
        
        let sql0 : String = "SELECT author_id FROM slots WHERE author_id != 0 ORDER BY RANDOM() LIMIT \(quantityAuthors)"
        let arr0 : Array<AnyObject> = userDatabaseController.sharedInstance.performQuery(sql0)
        
        var arrId : Array<String> = []
        for item  in arr0{
            let itemDict : Dictionary<String,Int> = item as! Dictionary<String,Int>
            arrId.append("\(itemDict["author_id"]!)")
        }
        
        let stringToAdd = arrId.joinWithSeparator(",");
        let sql1 : String = "SELECT posts.id as id,name,text,authors.id as author_id FROM posts JOIN authors ON authors.id = posts.author_id WHERE author_id IN (\(stringToAdd)) ORDER BY RANDOM() LIMIT \(quantityPosts)"
        let arr1 : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql1)
        
        self.println("arr1 \(arr1)")
        return arr1 
        //if let resp : Dictionary<String, String> = arr1[0] as? Dictionary<String, String>{
           
        
        
    }
    
    func createSlots(){
        let sql : String = "DELETE FROM slots"
        userDatabaseController.sharedInstance.performQuery(sql)
        var i = 0
        while(i<6){
            let sql : String = "INSERT INTO slots (id,author_id) VALUES (\(i),0)"
            userDatabaseController.sharedInstance.performQuery(sql)
            i++;
        }
    }
    
 
    
    func selectAuthorsFromSlots() -> Array<AnyObject>{
        let sql0 : String = "SELECT * FROM slots"
        let arr0 : Array<AnyObject> = userDatabaseController.sharedInstance.performQuery(sql0)
        
        return arr0
        
    }
    
    func checkIfAuthorisInSomeSlot(authorId : Int) -> Int{
        let sql : String = "SELECT slots.id as id FROM slots WHERE author_id = \(authorId) LIMIT 1"
        let arr : Array<AnyObject> = userDatabaseController.sharedInstance.performQuery(sql)
        
        if (arr.count > 0){
            let arr0 : Dictionary<String,AnyObject> = arr[0] as! Dictionary<String,AnyObject>
            return arr0["id"] as! Int
        }
        else
        {
            return 0
        }
    }
    
    func getAuthorInSlot(slotId: Int)-> Array<AnyObject>!{
        let sql0 : String = "SELECT author_id FROM slots WHERE id = \(slotId)"
        let arr0 : Array<AnyObject> = userDatabaseController.sharedInstance.performQuery(sql0)
        guard let authorId : Int = arr0[0]["author_id"] as? Int else{return nil}
        let sql1 : String = "SELECT * FROM authors WHERE id = \(authorId)"
        let arr1 : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql1)
        return arr1
    }
   
    
    func setSlot(authorId : Int, slotId: Int, topicId: Int){
        let sql : String = "UPDATE slots SET author_id = \(authorId), topic_id = \(topicId) WHERE id = \(slotId)"
        self.println(sql)
        userDatabaseController.sharedInstance.performQuery(sql)
    }
    
    func eraseSlot(slotId: Int){
        let sql : String = "UPDATE slots SET author_id = 0, topic_id = 0 WHERE id = \(slotId)"
        self.println(sql)
        userDatabaseController.sharedInstance.performQuery(sql)
    }
    
    func eraseAllSlots(){
        let sql : String = "DELETE FROM slots"
        self.println(sql)
        userDatabaseController.sharedInstance.performQuery(sql)
    }
    
    
 
    
    func getLastHistory() -> Array<AnyObject>{
        let sql : String = "SELECT * FROM history WHERE date BETWEEN strftime('%Y-%m-%d 00:00:00', 'now') AND strftime('%Y-%m-%d 23:59:00', 'now') LIMIT 1"
        if let arr : Array<AnyObject> = userDatabaseController.sharedInstance.performQuery(sql) {
            self.println("query test \(arr)")
            return arr
        }
        else
        {
            return []
        }
    }
    
    func insertHistoryQuote(str: String, postId: Int){
            let sql : String = "INSERT INTO history (date,post_id) VALUES ('\(str)',\(postId))"
            userDatabaseController.sharedInstance.performQuery(sql)
            self.println("insert into history \(sql)")
    }
    
    func getLastNotification() -> Dictionary<String,AnyObject>!{
        let sql1 : String = "SELECT date FROM notifications LIMIT 1"
        if let arr : Array<AnyObject> = userDatabaseController.sharedInstance.performQuery(sql1){
            self.println("notificationsResp ::== \(arr)")
            if (arr.count > 0){
                return arr[0] as! Dictionary<String,AnyObject>
            }
        }
        return nil
    }
    
    
    func insertNotification(str: String){
        let sql0 : String = "DELETE FROM notifications"
        userDatabaseController.sharedInstance.performQuery(sql0)
        let sql1 : String = "INSERT INTO notifications (date) VALUES ('\(str)')"
        userDatabaseController.sharedInstance.performQuery(sql1)
        self.println("notifications ::== \(sql1)")
        
    }
    
    
    func setNotificationsOn(){
        let sql0 : String = "DELETE FROM options WHERE name = 'notifications'"
        userDatabaseController.sharedInstance.performQuery(sql0)
        let sql1 : String = "INSERT INTO options (value,name) VALUES ('1','notifications')"
        userDatabaseController.sharedInstance.performQuery(sql1)
    }
    
    func setNotificationsOff(){
        let sql0 : String = "DELETE FROM options WHERE name = 'notifications'"
        userDatabaseController.sharedInstance.performQuery(sql0)
        let sql1 : String = "INSERT INTO options (value,name) VALUES ('0','notifications')"
        userDatabaseController.sharedInstance.performQuery(sql1)
    }
    
    func getNotificationState() -> Bool{
        let sql : String = "SELECT value FROM options WHERE name = 'notifications'"
        if let arr : Array<AnyObject> = userDatabaseController.sharedInstance.performQuery(sql) {
            self.println("query test \(arr)")
            if(arr.count > 0){
                if arr[0]["value"] as? String == "1" {return true}
            }
          
        }
        
        return false
    }
    
    
}