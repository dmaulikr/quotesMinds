//
//  dabateseUserController.swift
//  everyday
//
//  Created by thiagoracca on 1/23/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit

class userDatabaseController: NSObject,databaseHelper,logHelper {
    var logLevel : Int = 3
        var db : PODatabase = PODatabase()
    
        static let sharedInstance = userDatabaseController()
    
        override init() {
            super.init()
            
            //** if there is need to delete the original database
            //self.deleteOriginalFile("userDatabase.sqlite")
            self.copyNewFile("userDatabase.sqlite")
            
            if let fileFolder : String = self.getDocumentsDirectoryFolder("userDatabase.sqlite"){
                self.println("fileFolder \(fileFolder)")
                self.db = PODatabase(path: fileFolder)
                dbInicialize(fileFolder)
            }
            
            self.updateVersion()
        }
    
    
    func updateVersion(){
     var version = "0.0";
     let arr = self.db.performQuery("SELECT value FROM options WHERE name = 'version'")
       
        if(arr.count == 0){
            
            version = "0.0";
        }
        else
        {
            version = "0.1";
            if let val : String = arr[0]["value"] as? String{
                version = val
            }
        }
        
        
        if(version == "0.0"){
            self.db.performQuery("DELETE FROM options WHERE name = 'version'")
            self.db.performQuery("INSERT INTO options (name,value) VALUES ('version','1.0')")
            self.db.performQuery("ALTER TABLE slots ADD COLUMN topic_id INTEGER")
            self.db.performQuery("UPDATE slots SET topic_id = 0")
            version = "1.0"
            self.println("version 1.0")
      
        }

    
    }
}
