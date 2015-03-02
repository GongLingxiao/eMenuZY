//
//  DishDetailViewController.h
//  eMenuZY
//
//  Created by Gong Lingxiao on 15/1/19.
//  Copyright (c) 2015年 宫凌霄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface DishDetailViewController : UIViewController 

@property (nonatomic, retain) DishModel *dishModel;
@property (nonatomic, retain) IBOutlet UILabel *dishName;
@property (nonatomic, retain) IBOutlet UIImageView *dishImage;
@property (nonatomic, retain) IBOutlet UILabel *bigLabel;
@property (nonatomic, retain) IBOutlet UILabel *normalLabel;
@property (nonatomic, retain) IBOutlet UILabel *smallLabel;
@property (nonatomic, retain) IBOutlet UILabel *bigYuan;
@property (nonatomic, retain) IBOutlet UILabel *normalYuan;
@property (nonatomic, retain) IBOutlet UILabel *smallYuan;
@property (nonatomic, retain) IBOutlet UILabel *bigLine;
@property (nonatomic, retain) IBOutlet UILabel *normalLine;
@property (nonatomic, retain) IBOutlet UILabel *smallLine;
@property (nonatomic, retain) IBOutlet UILabel *bigUnit;
@property (nonatomic, retain) IBOutlet UILabel *normalUnit;
@property (nonatomic, retain) IBOutlet UILabel *smallUnit;
@property (nonatomic, retain) IBOutlet UIImageView *bigCutLine;
@property (nonatomic, retain) IBOutlet UIImageView *normalCutLine;
@property (nonatomic, retain) IBOutlet UIImageView *smallCutLine;
@property (nonatomic, retain) IBOutlet UIImageView *descImage;
@property (nonatomic, retain) IBOutlet UIImageView *leftTag;
@property (nonatomic, retain) IBOutlet UIImageView *rightTag;
@property (nonatomic, retain) IBOutlet UITextView *descText;


@end
