//
//  SearchHistory.m
//  eMenuZY
//
//  Created by 宫凌霄 on 15/2/7.
//  Copyright (c) 2015年 宫凌霄. All rights reserved.
//

#import "SearchHistory.h"

@implementation SearchHistory

@synthesize code;
@synthesize searchValue;

+ (void) insertSearchHistory:(NSString *) searchValue {
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB)==SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO SEARCHHISTORY (SEARCHVALUE)  VALUES(\"%@\")", searchValue];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(eMenuDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(eMenuDB);
    }
}

+ (NSMutableArray *) selectSearchHistory {
    
    NSMutableArray *searchList = [[NSMutableArray alloc] init];
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT * FROM SEARCHHISTORY ORDER BY CODE desc LIMIT 5;";
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                SearchHistory *sh = [[SearchHistory alloc] init];
                // searchValue
                NSString *searchValue = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                sh.searchValue = searchValue;
                
                [searchList addObject:sh];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(eMenuDB);
    }
    return searchList;
}

+ (void) deleteSearchHistory {
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = @"DELETE FROM SEARCHHISTORY;";
        const char *query = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query, -1, &stmt, NULL) != SQLITE_OK) {
            
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(eMenuDB));
        }
    } else {
        NSLog(@"创建/打开数据库失败");
    }
}

@end
