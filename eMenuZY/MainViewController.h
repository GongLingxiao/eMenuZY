//
//  MainViewController.h
//  eMenuZY
//
//  Created by 宫凌霄 on 15/1/17.
//  Copyright (c) 2015年 宫凌霄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MBProgressHUD.h"
#import "DishTypeCell.h"
#import "Reachability.h"
#import "MenuListViewController.h"
#import "DishDetailViewController.h"
#import "MenuListViewController.h"
#import "SearchDishViewController.h"

@interface MainViewController : UIViewController<MenuListViewDelegate, SearchDishViewDelegate, MBProgressHUDDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) IBOutlet UIImageView *logoView;
@property (nonatomic, retain) IBOutlet UIImageView *leftBG;
@property (nonatomic, retain) IBOutlet UIImageView *rightBG;
@property (nonatomic, retain) IBOutlet UIScrollView *menuScrollView;
@property (nonatomic, retain) IBOutlet UITableView *dishTypeTableView;
@property (nonatomic, retain) IBOutlet UIPageControl *menuPageControl;
@property (nonatomic, retain) IBOutlet UIButton *returnBtn;
@property (nonatomic, retain) IBOutlet UILabel *nowSearch;
@property (nonatomic, retain) IBOutlet UILabel *noRecord;
@property (nonatomic, retain) IBOutlet UIImageView *searchBG;
@property (nonatomic, retain) UIStoryboard *storyborad;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) NSArray *dishTypeList;
@property (nonatomic, retain) NSArray *dishList;
@property (nonatomic, retain) DishDetailViewController *detailViewController;
@property (nonatomic, retain) SearchDishViewController *searchDishViewController;
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) NSUInteger pageTotalNum;
@property (nonatomic) NSUInteger buttonTag;
@property (nonatomic, retain) NSString *searchDemo;

- (IBAction)clickReturnBtn:(id)sender;
- (IBAction)showSearchMenu;
- (IBAction)goBackHome;

@end
