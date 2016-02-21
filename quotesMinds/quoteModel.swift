//
//  quoteModel.swift
//  everyday
//
//  Created by thiagoracca on 1/23/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit

protocol quotesModel {
    func println(str: String);
    func println(str: String, level: Int);
}


extension quotesModel {
    
    func getQuote() -> Dictionary<String, String>!{
        let arrImage : Array<String> = quotesDatabaseController.sharedInstance.getQuotesWithImages();
        let stringToAdd = arrImage.joinWithSeparator(",");
        let sql : String = "SELECT posts.text,authors.name FROM posts JOIN authors ON authors.id = posts.author_id WHERE authors.id IN (\(stringToAdd)) ORDER BY RANDOM() LIMIT 1"
        let arr : Array<AnyObject>! = quotesDatabaseController.sharedInstance.performQuery(sql)
        if(arr.count > 0){
            return arr[0] as! Dictionary<String, String>
        }
        else
        {
        
            return nil
        }
    }
    
  
    
    func getRandomAuthorsWithImage(quantity : Int) -> Array<AnyObject>!{
        let arrImage : Array<String> = quotesDatabaseController.sharedInstance.getQuotesWithImages();
        let stringToAdd = arrImage.joinWithSeparator(",");
        let sql : String = "SELECT * FROM authors WHERE authors.id IN (\(stringToAdd)) ORDER BY RANDOM() LIMIT \(quantity)"
        let arr : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql)
        return arr
    }
    
    func getAuthorsWithImageByLetter(letter: String) -> Array<AnyObject>!{
        let arrImage : Array<String> = quotesDatabaseController.sharedInstance.getQuotesWithImages();
        let stringToAdd = arrImage.joinWithSeparator(",");
        let sql : String = "SELECT * FROM authors WHERE authors.id IN (\(stringToAdd)) AND name LIKE '\(letter)%'"
        let arr : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql)
        return arr
    }
    
    func countAuthorsWithImageByLetter(letter: String) -> Int{
        let arrImage : Array<String> = quotesDatabaseController.sharedInstance.getQuotesWithImages();
        let stringToAdd = arrImage.joinWithSeparator(",");
        let sql : String = "SELECT count(id) as total FROM authors WHERE authors.id IN (\(stringToAdd)) AND name LIKE '\(letter)%'"
        let arr : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql)
        if arr.count > 0 {
            
            if let arrDict : Dictionary<String,AnyObject> = arr[0] as! Dictionary<String,AnyObject> as Dictionary{
                if let intNum : Int = arrDict["total"] as? Int {
                    return intNum
                }
            }
        }
        return 0;
    }
    
    
    func getAuthorsWithImageByLetter(letter: String, withSearch: String) -> Array<AnyObject>!{
        let arrImage : Array<String> = quotesDatabaseController.sharedInstance.getQuotesWithImages();
        let stringToAdd = arrImage.joinWithSeparator(",");
        let sql : String = "SELECT * FROM authors WHERE authors.id IN (\(stringToAdd)) AND name LIKE '\(letter)%' AND authors.name LIKE '%\(withSearch)%' ORDER BY authors.name ASC"
        let arr : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql)
        return arr
    }
    
    func countAuthorsWithImageByLetter(letter: String, withSearch: String) -> Int{
        let arrImage : Array<String> = quotesDatabaseController.sharedInstance.getQuotesWithImages();
        let stringToAdd = arrImage.joinWithSeparator(",");
        let sql : String = "SELECT count(id) as total FROM authors WHERE authors.id IN (\(stringToAdd)) AND authors.name LIKE '\(letter)%' AND authors.name LIKE '%\(withSearch)%'"
        let arr : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql)
        if arr.count > 0 {
            
            if let arrDict : Dictionary<String,AnyObject> = arr[0] as! Dictionary<String,AnyObject> as Dictionary{
                if let intNum : Int = arrDict["total"] as? Int {
                    return intNum
                }
            }
        }
        return 0;
    }
    
    func getAuthorsWithImages() -> Array<AnyObject>!{
        
        let arrImage : Array<String> = quotesDatabaseController.sharedInstance.getQuotesWithImages();
        let stringToAdd = arrImage.joinWithSeparator(",");
        let sql : String = "SELECT * FROM authors WHERE authors.id IN (\(stringToAdd)) ORDER BY authors.name ASC"
        let arr : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql)
        return arr;
    }
    
    func countAuthorsWithImages() -> Int{
        
        let arrImage : Array<String> = quotesDatabaseController.sharedInstance.getQuotesWithImages();
        let stringToAdd = arrImage.joinWithSeparator(",");
        let sql : String = "SELECT count(id) as total FROM authors WHERE authors.id IN (\(stringToAdd))"
        let arr : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql)
        if arr.count > 0 {
            
            if let arrDict : Dictionary<String,AnyObject> = arr[0] as! Dictionary<String,AnyObject> as Dictionary{
                if let intNum : Int = arrDict["total"] as? Int {
                    return intNum
                }
            }
        }
        return 0;
    }
    
    
    func searchAuthorsWithImages(string:String) -> Array<AnyObject>{
        
        var str = string.lowercaseString
        str = str.stringByReplacingOccurrencesOfString(" ", withString: "%", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let arrImage : Array<String> = quotesDatabaseController.sharedInstance.getQuotesWithImages();
        let stringToAdd = arrImage.joinWithSeparator(",");
        let sql : String = "SELECT * FROM authors WHERE authors.id IN (\(stringToAdd)) AND authors.name LIKE '%\(str)%' ORDER BY authors.name ASC"
        let arr : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql)
        return arr
    }
    
    
    
    func countTopics() -> Int{
        

        let sql : String = "SELECT count(id) as total FROM topics"
        let arr : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql)
        
        
        if arr.count > 0 {
        
            if let arrDict : Dictionary<String,AnyObject> = arr[0] as! Dictionary<String,AnyObject> as Dictionary{
                if let intNum : Int = arrDict["total"] as? Int {
                        return intNum
                }
            }
        }
        return 0;
    }
    
    func getTopics() -> Array<AnyObject>!{
        let sql : String = "SELECT * FROM topics ORDER BY topics.name ASC"
        let arr : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql)
        return arr
        
    }
    
    func getTopic(topicId : Int) -> Array<AnyObject>!{
        
        let sql : String = "SELECT * FROM topics WHERE id = \(topicId)"
        let arr : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql)
        return arr
        
    }
    func getAuthor(authorId : Int) -> Array<AnyObject>!{

        let sql : String = "SELECT * FROM authors WHERE id = \(authorId)"
        let arr : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql)
        return arr
        
    }
    
    func getQtdPosts(authorId : Int){
        
        let sql : String = "SELECT count(id) as total FROM posts WHERE author_id = \(authorId) GROUP BY author_id"
        let arr : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql)
        self.println("arr \(arr)")
        
    }
    
    func getAuthorTopic(authorId : Int) -> Int{
        
        
        let sql : String =  "SELECT   topics.id AS id, " +
                            "count(topics.id) AS total_topics " +
                            "FROM     topics" +
                            "         INNER JOIN " +
                            "         (SELECT * " +
                            "           FROM   categories " +
                            "                   INNER JOIN  " +
                            "                   (SELECT categorie_id AS categorie_id," +
                            "                           a.total " +
                            "                    FROM   posts_to_categories " +
                            "                           INNER JOIN " +
                            "                           (SELECT   id AS post_id," +
                            "                                     count(id) AS total" +
                            "                            FROM     posts " +
                            "                            WHERE    author_id = \(authorId) " +
                            "                            GROUP BY id) AS a " +
                            "                           ON posts_to_categories.post_id = a.post_id) AS b " +
                            "                   ON categories.id = b.categorie_id) AS c" +
                            "           ON c.categorie_id = topics.id " +
                            "GROUP BY topics.id " +
                            "ORDER BY total_topics DESC " +
                            "LIMIT 1 "
        let arr : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql)
        
        if(arr.count > 0){
            if let val = arr[0]["id"] as? Int{
                return val
            }
        }
        return 0
        
    }
    
    func getAuthorsWithinTopics(topicId : Int) -> Array<AnyObject>!{
        let arrImage : Array<String> = quotesDatabaseController.sharedInstance.getQuotesWithImages();
        let stringToAdd = arrImage.joinWithSeparator(",");
        let sql : String =  "SELECT * " +
                            "FROM   authors " +
                            "WHERE  id IN (SELECT author_id " +
                            "              FROM   posts " +
                            "              WHERE  id IN (SELECT post_id " +
                            "                            FROM   posts_to_categories " +
                            "                            WHERE  categorie_id IN (SELECT id " +
                            "                                                    FROM   categories " +
                            "                                                    WHERE " +
                            "                                   id IN (SELECT categorie_id " +
                            "                                          FROM   topics_to_categories " +
                            "                                          WHERE  topic_id = \(topicId)))) " +
                            "              GROUP  BY author_id) " +
                            "       AND authors.id IN ( \(stringToAdd) ) " +
                            "ORDER  BY Random() " +
                            "LIMIT 1"
        let arr : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql)
        return arr
        
    }
    
    func getPostAuthorDetails(postId: Int) -> Dictionary<String,AnyObject>!{
        let sql : String = "SELECT posts.id as id,name,text,authors.id as author_id FROM posts JOIN authors ON authors.id = posts.author_id WHERE posts.id = \(postId)"
        let arr : Array<AnyObject> = quotesDatabaseController.sharedInstance.performQuery(sql)
        
   
       if(arr.count > 0){
            
                return arr[0] as! Dictionary<String,AnyObject>
        }
    
        return nil
    
    }
 
    
    
}
