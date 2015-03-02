//
//  SearchDishViewController.m
//  eMenuZY
//
//  Created by 宫凌霄 on 15/2/4.
//  Copyright (c) 2015年 宫凌霄. All rights reserved.
//

#import "SearchDishViewController.h"

@interface SearchDishViewController ()

@end

@implementation SearchDishViewController

@synthesize searchText;
@synthesize searchList;
@synthesize btnOne;
@synthesize btnThree;
@synthesize btnFive;
@synthesize btnFour;
@synthesize btnSix;
@synthesize btnTwo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    for (int i = 0; i < 6; i ++) {
        [self.view viewWithTag:(130 + i)].hidden = YES;
    }
    
    NSArray *hotList = [NSArray arrayWithArray:[HotWordModel getAllHotWord]];
    
    for (int i = 0; i < [hotList count]; i ++) {
        HotWordModel *hotModel = [hotList objectAtIndex:i];
        UIButton *button = (UIButton *) [self.view viewWithTag:(130 + i)];
        button.hidden = NO;
        [button setTitle:hotModel.hot forState:UIControlStateNormal];
        [button addTarget:self action:@selector(doSearchHotWord:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    searchList = [NSArray arrayWithArray:[SearchHistory selectSearchHistory]];
}

- (void)keyboardHide:(UITapGestureRecognizer *) tap {
    [searchText resignFirstResponder];
}

- (IBAction)doSearch:(id)sender {
    if (![searchText.text isEqual: @""]) {
        [SearchHistory insertSearchHistory:searchText.text];
        [self.delegate showDishSearchResult:searchText.text];
    }
}

- (void)doSearchCell:(NSString *) condition {
    if (![condition isEqualToString:@""]) {
        [self.delegate showDishSearchResult:condition];
    }
}

- (void)doSearchHotWord:(id)sender {
    UIButton *button = sender;
    NSString *condition = button.titleLabel.text;
    if (![condition isEqualToString:@""]) {
        [self.delegate showDishSearchResult:condition];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([searchList count] > 0) {
        return [searchList count] + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchDishCell";
    SearchDishCell *searchDishCell = (SearchDishCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.row == [searchList count]) {
        searchDishCell.lblDishName.hidden = YES;
        searchDishCell.dishImage.hidden = YES;
        searchDishCell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        SearchHistory *searchHistory = [searchList objectAtIndex:indexPath.row];
        searchDishCell.lblDishName.text = searchHistory.searchValue;
        searchDishCell.lblDishCode.hidden = YES;
    }
    return searchDishCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [searchList count]) {
        [SearchHistory deleteSearchHistory];
        searchList = nil;
        [tableView reloadData];
    } else {
        SearchHistory *searchHistory = [searchList objectAtIndex:indexPath.row];
        [self doSearchCell:searchHistory.searchValue];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
