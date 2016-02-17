//
//  databaseController.swift
//  everyday
//
//  Created by thiagoracca on 1/23/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit
import SwiftyJSON

class quotesDatabaseController: NSObject,logHelper,databaseHelper {
        var logLevel : Int = 3
    
        var db : PODatabase = PODatabase()
    
    
        static let sharedInstance = quotesDatabaseController()
    
        override init() {
            super.init()
            self.println("database start",level: 1)
            if let fileFolder : String = self.getBundleDirectoryFolder("quotesDatabase.sqlite"){
            self.db = PODatabase(path: fileFolder)
                dbInicialize(fileFolder)
            }
        }
    
    func getQuotesWithImages() -> Array<String>{
        
        var arr : Array<String> = []
        
        if let json : JSON! = (self.readJsonFileFromBundle("authors_with_images.json")){
            for item in json.array! {
                arr.append("\(item)");
            }
        }
        return arr
    }
    
}
