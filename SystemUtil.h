//
//  SystemUtil.h
//  eMenu
//
//  Created by Gong Lingxiao on 13-5-10.
//  Copyright (c) 2013年 Gong Lingxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "DishModel.h"
#import "DishTypeModel.h"
#import "HotWordModel.h"

@interface SystemUtil : NSObject {
    NSInputStream	*inputStream;
	NSOutputStream	*outputStream;
}

@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;

+ (void) createDishTable;
+ (void) createDishTypeTable;
+ (void) createOrderDishTable;
+ (void) createOrderInfoTable;
+ (void) createHotWordTable;
+ (void) createSearchHistoryTable;
+ (void) deleteHotWord;
+ (void) syncData;
+ (void)deleteAllDish;
+ (void)deleteAllDishType;
+ (void)deleteAllOrderDish;
+ (void)deleteImage;
+ (void)deleteOrderInfo;
+ (NSString *)getDBPath;

@end
