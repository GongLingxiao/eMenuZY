//
//  SearchHistory.h
//  eMenuZY
//
//  Created by 宫凌霄 on 15/2/7.
//  Copyright (c) 2015年 宫凌霄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchHistory : NSObject {
    int *code;
    NSString *searchValue;
}

@property (nonatomic) int *code;
@property (nonatomic, retain) NSString *searchValue;

+ (void) insertSearchHistory:(NSString *) searchValue;

+ (NSMutableArray *) selectSearchHistory;
+ (void) deleteSearchHistory;

@end
