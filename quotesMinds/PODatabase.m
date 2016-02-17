//
//  PODatabase.m
//  
//
//  Created by Thiago Racca Da Silva on 31/08/13.
//  Copyright (c) 2013 Thiago Racca Da Silva. All rights reserved.
//

#import "PODatabase.h"



@implementation PODatabase





-(PODatabase *)initWithPath:(NSString *)path {
    if (self = [super init]) {
        sqlite3 *dbConnection;
        if (sqlite3_open([path UTF8String], &dbConnection) != SQLITE_OK) {
            
            NSLog(@"[SQLITE] Unable to open database!");
            return nil; // if it fails, return nil obj
        }
        database = dbConnection;
    }
    return self;
}



-(void)initialize:(NSString *) path {
    self.path = path;
    sqlite3 *db = database;
    if (sqlite3_open([path UTF8String], &db) == SQLITE_OK) {

        if (sqlite3_exec(db, (const char*) "SELECT count(*) FROM sqlite_master;", NULL, NULL, NULL) == SQLITE_OK) {
           
            database = db;


            
        }else
            {
                NSLog(@"checking if it is the same");
                            };
            
            
        } else {
  
            NSLog(@"nao foi encript");
        }

    
}

-(void)createTable:(NSString *) tableName withFields: (NSMutableArray*) fields{

   
    NSDictionary * table = [[NSDictionary alloc] init];
    

    table = [NSDictionary dictionaryWithObjects:@[tableName,
                                                  fields
                                                  ]
                                        forKeys:@[@"tableName",
                                                  @"fields"]
             ];
    
    [self addTable:[self formatTable:table]];
}

-(NSString *)formatTable:(NSDictionary *) table{
    NSString * firstBlock = [NSString stringWithFormat:@"CREATE TABLE \"%@\"",[table objectForKey:@"tableName"]];
    NSArray * objectBlock = [table objectForKey:@"fields"];
    NSMutableArray * fieldsStringBlock = [[NSMutableArray alloc] init];
    for(NSArray * item in objectBlock){
        
        [fieldsStringBlock addObject:[NSString stringWithFormat:@"\"%@\" %@",[item objectAtIndex:0],[item objectAtIndex:1]]];
    }
    NSString * secondBlock = [fieldsStringBlock componentsJoinedByString:@","];
    NSString * finalBlock = [NSString stringWithFormat:@"%@(%@);",firstBlock,secondBlock];
    return finalBlock;
}

-(void)addTable:(NSString *) formatedTable{
    sqlite3 *db = database;
    if (sqlite3_open([self.path UTF8String], &db) == SQLITE_OK) {
    const char* statement = [formatedTable UTF8String];
    //sqlite3_key(db, key, strlen(key));
    if (sqlite3_exec(db, (const char*) "SELECT count(*) FROM sqlite_master;", NULL, NULL, NULL) == SQLITE_OK) {
        // password is correct, or, database has been initialized
        
        NSArray * tableObjects = [formatedTable componentsSeparatedByString:@"\""];
        if(!sqlite3_exec(db, (const char*) statement, NULL, NULL, NULL)){
            
             NSLog(@"created %@",[tableObjects objectAtIndex:1]);
        }
        else
        {
            NSLog(@"table %@ already exists",[tableObjects objectAtIndex:1]);
        };
        
        
    }
    }
    
}







-(NSArray *)performQuery:(NSString *)query {

    sqlite3_stmt *statement = nil;
    const char *sql = [query UTF8String];
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"[SQLITE] Error when preparing query!");
        NSLog(@"[SQLITE] query %@!",[NSString stringWithUTF8String:sql]);
    } else {
        NSMutableArray *result = [NSMutableArray array];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
            for (int i=0; i<sqlite3_column_count(statement); i++) {
                int colType = sqlite3_column_type(statement, i);
                id value;
                if (colType == SQLITE_TEXT) {
                    const unsigned char *col = sqlite3_column_text(statement, i);
                    const char *colSigned = (char *)col;
                    NSString *correctString = [[NSString alloc] initWithUTF8String: colSigned];
                    value = correctString;
                } else if (colType == SQLITE_INTEGER) {
                    int col = sqlite3_column_int(statement, i);
                    value = [NSNumber numberWithInt:col];
                } else if (colType == SQLITE_FLOAT) {
                    double col = sqlite3_column_double(statement, i);
                    value = [NSNumber numberWithDouble:col];
                } else if (colType == SQLITE_NULL) {
                    value = [NSNull null];
                } else {
                    NSLog(@"[SQLITE] UNKNOWN DATATYPE");
                }
                const char *colName = sqlite3_column_name(statement, i);
                [row setObject:value forKey:[NSString stringWithFormat:@"%s",colName]];
             
            }
            [result addObject:row];
        }
        return result;
    }
    return nil;
    
    
    
}







@end
