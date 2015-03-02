//
//  DishModel.h
//  eMenu
//
//  Created by Gong Lingxiao on 13-5-7.
//  Copyright (c) 2013年 Gong Lingxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DishModel : NSObject {
    NSString *dishCode;
    NSString *dishName;
    NSString *dishDesc;
    NSString *dishPrice;
    NSString *dishMemberPrice;
    NSString *isPopular;
    NSString *unit;
    NSString *imageUrl;
    NSString *dishTypeId;
    NSString *dishTypeName;
    NSString *dishCount;
    
    NSString *dishPriceSmall;
    NSString *dishMemberPriceSmall;
    NSString *unitSmall;
    
    NSString *dishPriceBig;
    NSString *dishMemberPriceBig;
    NSString *unitBig;
    NSString *zhuChu;
    NSString *zhaoPai;
    
}

@property (nonatomic, retain) NSString *dishCode;
@property (nonatomic, retain) NSString *dishName;
@property (nonatomic, retain) NSString *dishDesc;
@property (nonatomic, retain) NSString *dishPrice;
@property (nonatomic, retain) NSString *dishMemberPrice;
@property (nonatomic, retain) NSString *isPopular;
@property (nonatomic, retain) NSString *unit;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *dishTypeId;
@property (nonatomic, retain) NSString *dishTypeName;
@property (nonatomic, retain) NSString *dishCount;

@property (nonatomic, retain) NSString *dishPriceSmall;
@property (nonatomic, retain) NSString *dishMemberPriceSmall;
@property (nonatomic, retain) NSString *unitSmall;

@property (nonatomic, retain) NSString *dishPriceBig;
@property (nonatomic, retain) NSString *dishMemberPriceBig;
@property (nonatomic, retain) NSString *unitBig;
@property (nonatomic, retain) NSString *zhuChu;
@property (nonatomic, retain) NSString *zhaoPai;

- (NSString *) downloadImage:(NSString *) imageUrl;
+ (NSMutableArray *) getAllDish;
+ (NSMutableArray *) getDishByType:(NSString *) dishTypeId;
+ (NSMutableArray *) searchDish:(NSString *) searchData;

@end
