//
//  MenuListViewController.h
//  eMenuZY
//
//  Created by Gong Lingxiao on 15/1/19.
//  Copyright (c) 2015年 宫凌霄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@protocol MenuListViewDelegate <NSObject>
- (void) showDishDetail:(DishModel *) dishModel;
@end

@interface MenuListViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *topSearchImage;
@property (nonatomic, retain) IBOutlet UILabel *topSearchLabel;
@property (nonatomic, retain) id<MenuListViewDelegate> delegate;
@property (nonatomic) NSUInteger page;
@property (nonatomic, retain) NSArray *dishList;
@property (nonatomic, retain) NSString *searchText;

@end
