//
//  databaseHelper.swift
//  everyday
//
//  Created by thiagoracca on 1/23/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol databaseHelper {
    var db : PODatabase { set get }
    func println(str: String);
    func println(str: String, level: Int);

}

extension databaseHelper{
    
    func dbInicialize(file: String){
      db.initialize(file)
      configureDatabase("UTF-8")
    }
    
    func configureDatabase(str: String){
        db.performQuery("PRAGMA encoding=\"\(str)\"")
    }
    
    func performQuery(str: String) -> Array<AnyObject>{
        if let ret : Array<AnyObject> = (db.performQuery(str)){
            
            return ret
        }
        else
        {
            return Array()
        }
    }
    
    
    func getBundleDirectoryFolder(file: String) -> String!{
        let filePath = NSBundle.mainBundle().pathForResource(file, ofType: nil)
        return filePath
    }
    
    func getDocumentsDirectoryFolder(file : String) -> String{
        let documentURL : NSURL = try! NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true)
        
        var documentsDirectory : String = documentURL.absoluteString
        documentsDirectory = documentsDirectory.stringByReplacingOccurrencesOfString("file://", withString: "")
        
        documentsDirectory = "\(documentsDirectory)\(file)";
        return documentsDirectory
    }
    
    func copyNewFile(file: String){
        
        let originalPath = NSBundle.mainBundle().pathForResource(file, ofType: nil)
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(file);
            let fileMgr = NSFileManager.defaultManager()
            
            self.println("originalPath copyfile : \(originalPath)",level: 1);
            self.println("documentsPath : \(path)",level: 1);
            
            if (originalPath != nil) {
                do{
                    try fileMgr.copyItemAtPath(originalPath!, toPath: path)
                    self.println("copied file",level: 1);
                    
                }
                catch {
                    self.println("error copying file",level: 1);
                }
            }
        }
    }
    
    
    func readJsonFileFromDocuments(file: String) -> JSON{
        
        var json : JSON!
        do{
            if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                let path = dir.stringByAppendingPathComponent(file);
                let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                let data = text.dataUsingEncoding(NSUTF8StringEncoding)
                json = JSON(data: data!)
            }
        }
        catch{
            self.println("error reading json",level: 1);
        }
        
        if(json != nil){
            return json
        }
        else
        {
            return JSON("")
        }
    }
    
    func readJsonFileFromBundle(file: String) -> JSON{
        
        var json : JSON!
        // get the file path for the file "test.json" in the playground bundle
        if let filePath = NSBundle.mainBundle().pathForResource(file, ofType: nil) {
            
            // get the contentData
            let  contentData = NSFileManager.defaultManager().contentsAtPath(filePath)
            
            // get the string
            if (contentData != nil){
                json = JSON(data: contentData!)
            }
        }
        
        
        if(json != nil){
            return json
        }
        else
        {
            return JSON("")
        }
    }
    
    func deleteOriginalFile(file: String){
        //this is the file. we will write to and read from it
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(file);
            let fileMgr = NSFileManager.defaultManager()
            do{
                try fileMgr.removeItemAtPath(path)
                self.println("deleted file : = \(file)", level: 1);
            }
            catch{
                self.println("error deleting the file : = \(file)", level: 1);
            }
        }
    }



}
