//
//  PODatabase.h
//  
//
//  Created by Thiago Racca Da Silva on 31/08/13.
//  Copyright (c) 2013 Thiago Racca Da Silva. All rights reserved.
//

/**
 
 This Controller controls all database Functions.
 
 Such as:
 
 * Encryption
 * Manange users and messages
 * and storage of encrypted files
 

 */


#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface PODatabase : NSObject{
    sqlite3 *database;
}

/** Propriety to store current path of database */
@property (strong,atomic) NSString *path;

/** Propriety to store the return  of the funciotion used some times  */
@property (strong,atomic) NSArray *retorno;



/** Initialize Object with path */
-(id)initWithPath:(NSString *)path;

/** start encrypt mode */
-(void)initialize:(NSString *) path;

-(void)createTable:(NSString *) tableName withFields: (NSMutableArray *) fields;


-(NSArray *)performQuery:(NSString *)query;


@end
