//
//  SearchDishViewController.h
//  eMenuZY
//
//  Created by 宫凌霄 on 15/2/4.
//  Copyright (c) 2015年 宫凌霄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchHistory.h"
#import "SearchDishCell.h"
#import "HotWordModel.h"

@protocol SearchDishViewDelegate <NSObject>
- (void) showDishSearchResult: (NSString *) searchText;
@end

@interface SearchDishViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UIButton *btnOne;
@property (nonatomic, retain) IBOutlet UIButton *btnTwo;
@property (nonatomic, retain) IBOutlet UIButton *btnThree;
@property (nonatomic, retain) IBOutlet UIButton *btnFour;
@property (nonatomic, retain) IBOutlet UIButton *btnFive;
@property (nonatomic, retain) IBOutlet UIButton *btnSix;
@property (nonatomic, retain) IBOutlet UITextField *searchText;
@property (nonatomic, retain) id<SearchDishViewDelegate> delegate;
@property (nonatomic, retain) NSArray *searchList;

- (IBAction)doSearch:(id)sender;

@end
