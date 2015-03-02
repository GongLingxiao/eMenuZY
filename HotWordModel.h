//
//  HotWordModel.h
//  eMenuZY
//
//  Created by 宫凌霄 on 15/2/12.
//  Copyright (c) 2015年 宫凌霄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotWordModel : NSObject {
    NSString *code;
    NSString *hot;
}

@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *hot;

+ (NSMutableArray *) getAllHotWord;

@end
