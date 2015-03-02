//
//  HotWordModel.m
//  eMenuZY
//
//  Created by 宫凌霄 on 15/2/12.
//  Copyright (c) 2015年 宫凌霄. All rights reserved.
//

#import "HotWordModel.h"

@implementation HotWordModel

@synthesize code;
@synthesize hot;

+ (NSMutableArray *) getAllHotWord {
    NSMutableArray *hotWordList = [[NSMutableArray alloc] init];
    NSString *databasePath = [SystemUtil getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT * FROM HOTWORD;";
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(eMenuDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                HotWordModel *hotWordModel = [[HotWordModel alloc] init];
                // code
                NSString *codeField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                hotWordModel.code = codeField;
                // hot
                NSString *hotField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                hotWordModel.hot = hotField;
                [hotWordList addObject:hotWordModel];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(eMenuDB);
    }
    return hotWordList;
}

@end
