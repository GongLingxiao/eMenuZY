//
//  SystemUtil.m
//  eMenu
//
//  Created by Gong Lingxiao on 13-5-10.
//  Copyright (c) 2013年 Gong Lingxiao. All rights reserved.
//

#import "SystemUtil.h"
#import "GDataXMLNode.h"

@implementation SystemUtil

@synthesize inputStream;
@synthesize outputStream;

+ (void) syncData {
    [self deleteImage];
    [self deleteAllDish];
    [self deleteAllDishType];
    [self deleteAllOrderDish];
    [self deleteHotWord];
    [self syncDishData];
    [self syncDishTypeData];
    [self syncHotWord];
}

+ (void)deleteImage {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    
    NSString *extension = @"jpg";
    while ((filename = [e nextObject])) {
        if ([[filename pathExtension] isEqualToString:extension]) {
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

+ (void) syncDishData {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"SyncMenu.asmx/SyncDish"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setRequestMethod:@"POST"];
//    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
//    [request buildPostBody];
//    [request setDelegate:self];
//    [request startSynchronous];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:@"1000" forKey:@"shopid"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    
    NSLog(@"%d", request.responseStatusCode);
    if(request.responseStatusCode == 200)
    {
        NSData *responseData = [request responseData];
        [self loadDish:responseData];
    }
}

+ (void) loadDish:(NSData *) responseData {
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
    GDataXMLElement *root = [doc rootElement];
    NSData *data = [[root stringValue] dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
    //NSLog(@"%@", [root stringValue]);
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", error);
    } else {
        for(NSDictionary *item in jsonArray) {
            DishModel *dishModel = [[DishModel alloc] init];
            dishModel.dishCode = [item objectForKey:@"DishCode"];
            dishModel.dishName = [item objectForKey:@"DishName"];
            dishModel.dishDesc = [item objectForKey:@"DishDesc"];
            dishModel.dishMemberPrice = [item objectForKey:@"DishMemberPrice"];
            dishModel.isPopular = [item objectForKey:@"IsPopular"];
            dishModel.unit = [item objectForKey:@"DishUnit"];
            dishModel.dishPrice = [item objectForKey:@"DishPrice"];
            
            dishModel.dishPriceSmall = [item objectForKey:@"DishPrice1"];
            dishModel.dishMemberPriceSmall = [item objectForKey:@"DishMemberPrice1"];
            dishModel.unitSmall = [item objectForKey:@"DishUnit1"];
            dishModel.dishPriceBig = [item objectForKey:@"DishPrice2"];
            dishModel.dishMemberPriceBig = [item objectForKey:@"DishMemberPrice2"];
            dishModel.unitBig = [item objectForKey:@"DishUnit2"];
            dishModel.zhuChu = [item objectForKey:@"Zhuchu"];
            dishModel.zhaoPai = [item objectForKey:@"Zhaopai"];
            
            NSString *imageUrl = [item objectForKey:@"ImageUrl"];
            if (imageUrl) {
                imageUrl = [dishModel downloadImage:imageUrl];
                dishModel.imageUrl = imageUrl;
            }
            dishModel.dishTypeId = [item objectForKey:@"DishTypeId"];
            [self insertDish:dishModel];
        }
    }
}

+ (void) syncDishTypeData {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"SyncMenu.asmx/SyncDishType"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setRequestMethod:@"POST"];
//    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
//    [request buildPostBody];
//    [request setDelegate:self];
//    [request startSynchronous];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:@"1000" forKey:@"shopid"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    if(request.responseStatusCode == 200)
    {
        NSData *responseData = [request responseData];
        [self loadDishType:responseData];
    }
}

+ (void) loadDishType:(NSData *) responseData {
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
    GDataXMLElement *root = [doc rootElement];
    NSData *data = [[root stringValue] dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
    //NSLog(@"%@", [root stringValue]);
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", error);
    } else {
        for(NSDictionary *item in jsonArray) {
            DishTypeModel *dishTypeModel = [[DishTypeModel alloc] init];
            dishTypeModel.typeId = [item objectForKey:@"DishTypeId"];
            dishTypeModel.typeName = [item objectForKey:@"DishTypeName"];
            [self insertDishType:dishTypeModel];
        }
    }
}

+ (void) syncHotWord {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"SyncMenu.asmx/SyncTags"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setRequestMethod:@"POST"];
//    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
//    [request buildPostBody];
//    [request setDelegate:self];
//    [request startSynchronous];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:@"1000" forKey:@"shopid"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    NSLog(@"%d", request.responseStatusCode);
    if(request.responseStatusCode == 200)
    {
        NSData *responseData = [request responseData];
        [self loadHotWord:responseData];
    }
}

+ (void) loadHotWord:(NSData *) responseData {
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
    GDataXMLElement *root = [doc rootElement];
    NSData *data = [[root stringValue] dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
    //NSLog(@"%@", [root stringValue]);
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", error);
    } else {
        for(NSDictionary *item in jsonArray) {
            HotWordModel *hotWordModel = [[HotWordModel alloc] init];
            hotWordModel.code = [item objectForKey:@"KID"];
            hotWordModel.hot = [item objectForKey:@"Word"];
            [self insertHotWord:hotWordModel];
        }
    }
}

+ (NSString *)getDBPath {
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    // Build the path to the database file
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"eMenu.db"]];
    return databasePath;
}

+ (void)insertDish:(DishModel *) dishModel
{
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &eMenuDB)==SQLITE_OK) {
        NSString *dishCode = dishModel.dishCode;
        NSString *dishName = dishModel.dishName;
        NSString *dishDesc = dishModel.dishDesc;
        NSString *dishPrice = dishModel.dishPrice;
        NSString *dishMemberPrice = dishModel.dishMemberPrice;
        NSString *isPopular = dishModel.isPopular;
        NSString *unit = dishModel.unit;
        NSString *imageUrl = dishModel.imageUrl;
        NSString *dishPriceSmall = dishModel.dishPriceSmall;
        NSString *dishMemberPriceSmall = dishModel.dishMemberPriceSmall;
        NSString *unitSmall = dishModel.unitSmall;
        NSString *dishPriceBig = dishModel.dishPriceBig;
        NSString *dishMemberPriceBig = dishModel.dishMemberPriceBig;
        NSString *unitBig = dishModel.unitBig;
        NSString *zhuChu = dishModel.zhuChu;
        NSString *zhaoPai = dishModel.zhaoPai;
        NSString *dishTypeId = dishModel.dishTypeId;
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO DISH VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")", dishCode, dishName, dishDesc, dishPrice, dishMemberPrice, isPopular, unit, imageUrl, dishPriceSmall, dishMemberPriceSmall, unitSmall, dishPriceBig, dishMemberPriceBig, unitBig, zhuChu, zhaoPai, dishTypeId];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(eMenuDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(eMenuDB);
    }
}

+ (void)insertDishType:(DishTypeModel *) dishTypeModel
{
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &eMenuDB)==SQLITE_OK) {
        NSString *typeId = dishTypeModel.typeId;
        NSString *typeName = dishTypeModel.typeName;
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO DISHTYPE VALUES(\"%@\",\"%@\")", typeId, typeName];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(eMenuDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(eMenuDB);
    }
}

+ (void)insertHotWord:(HotWordModel *) hotWordModel
{
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &eMenuDB)==SQLITE_OK) {
        NSString *code = hotWordModel.code;
        NSString *hot = hotWordModel.hot;
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO HOTWORD VALUES(\"%@\",\"%@\")", code, hot];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(eMenuDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(eMenuDB);
    }
}

+ (void) createDishTable {
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &eMenuDB)==SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS DISH(DISHCODE VARCHAR(50) PRIMARY KEY, DISHNAME TEXT, DISHDESC TEXT, DISHPRICE TEXT, DISHMEMBERPRICE TEXT, ISPOPULAR VARCHAR(10), DISHUNIT VARCHAR(20), IMAGEURL TEXT, DISHPRICESMALL TEXT, DISHMEMBERPRICESMALL TEXT, UNITSMALL VARCHAR(20), DISHPRICEBIG TEXT, DISHMEMBERPRICEBIG TEXT, UNITBIG VARCHAR(20), ZHUCHU VARCHAR(10), ZHAOPAI VARCHAR(10), DISHTYPEID VARCHAR(50));";
        if (sqlite3_exec(eMenuDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"create failed!\n");
        }
    }
    else
    {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void) createDishTypeTable {
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &eMenuDB)==SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS DISHTYPE(TYPEID VARCHAR(50) PRIMARY KEY, TYPENAME TEXT);";
        if (sqlite3_exec(eMenuDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"create failed!\n");
        }
    }
    else
    {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void) createOrderDishTable {
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &eMenuDB)==SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS ORDERDISH(DISHCODE VARCHAR(50) PRIMARY KEY, DISHCOUNT VARCHAR(50), ISADD VARCHAR(10), DISHTYPEID VARCHAR(50), DISHTYPENAME TEXT);";
        if (sqlite3_exec(eMenuDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"create failed!\n");
        }
    }
    else
    {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void) createOrderInfoTable {
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &eMenuDB)==SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS ORDERINFO(ORDERCODE VARCHAR(50) PRIMARY KEY;";
        if (sqlite3_exec(eMenuDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"create failed!\n");
        }
    }
    else
    {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void) createHotWordTable {
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &eMenuDB)==SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS HOTWORD(CODE VARCHAR(50) PRIMARY KEY, HOT TEXT);";
        if (sqlite3_exec(eMenuDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"create failed!\n");
        }
    }
    else
    {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void) createSearchHistoryTable {
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &eMenuDB)==SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS SEARCHHISTORY(CODE INTEGER PRIMARY KEY AUTOINCREMENT, SEARCHVALUE TEXT);";
        if (sqlite3_exec(eMenuDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"create failed!\n");
        }
    }
    else
    {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void)deleteOrderInfo
{
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = @"DELETE FROM ORDERINFO;";
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

+ (void)deleteAllDish
{
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = @"DELETE FROM DISH;";
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

+ (void)deleteAllDishType
{
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = @"DELETE FROM DISHTYPE;";
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

+ (void)deleteAllOrderDish
{
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = @"DELETE FROM ORDERDISH;";
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

+ (void)deleteHotWord
{
    NSString *databasePath = [self getDBPath];
    sqlite3 *eMenuDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &eMenuDB) == SQLITE_OK)
    {
        NSString *querySQL = @"DELETE FROM HOTWORD;";
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
