//
//  MainViewController.m
//  eMenuZY
//
//  Created by 宫凌霄 on 15/1/17.
//  Copyright (c) 2015年 宫凌霄. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize storyborad;
@synthesize viewControllers;
@synthesize dishTypeList;
@synthesize currentPage;
@synthesize pageTotalNum;
@synthesize dishTypeTableView;
@synthesize menuScrollView;
@synthesize buttonTag;
@synthesize returnBtn;
@synthesize detailViewController;
@synthesize searchDishViewController;
@synthesize leftBG;
@synthesize rightBG;
@synthesize menuPageControl;
@synthesize logoView;
@synthesize searchDemo;
@synthesize noRecord;
@synthesize nowSearch;
@synthesize searchBG;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dishTypeTableView.backgroundColor = [UIColor clearColor];
    self.dishTypeTableView.rowHeight = 70.0f;
    
    leftBG.layer.shadowColor = [UIColor blackColor].CGColor;
    leftBG.layer.shadowOffset = CGSizeMake(1, 0);
    leftBG.layer.shadowOpacity = YES;
    
    rightBG.layer.shadowColor = [UIColor blackColor].CGColor;
    rightBG.layer.shadowOffset = CGSizeMake(-1, 0);
    rightBG.layer.shadowOpacity = YES;
    
    returnBtn.hidden = YES;
    nowSearch.hidden = YES;
    noRecord.hidden = YES;
    searchBG.hidden = YES;
    
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapPress:)];
    tapAction.numberOfTouchesRequired = 3;
    tapAction.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:tapAction];
    
    NSArray *dishList = [DishModel getAllDish];
    NSUInteger count = [dishList count];
    if (count > 0) {
        [self initPage];
    } else {
        //[self syncData];
        menuPageControl.hidden = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无菜品数据，请先同步数据" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)initPage {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"初始化";
    [HUD show:YES];
    menuPageControl.hidden = NO;
    
    buttonTag = 100;
    // 获取菜品分类
    self.dishTypeList = [NSArray arrayWithArray:[DishTypeModel getAllDishType]];
    [self.dishTypeTableView reloadData];
    [self showDishView:0];
    
    [HUD hide:YES];
}

- (void) showDishDetail:(DishModel *) dishModel {
    returnBtn.hidden = NO;
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(260, 0, self.view.bounds.size.width - 340.0, self.view.bounds.size.height)];
    darkView.alpha = 1.0;
    darkView.backgroundColor = [UIColor clearColor];
    darkView.tag = 9;
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DishDetailViewController *dishDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"DishDetailViewController"];
    dishDetailViewController.dishModel = dishModel;
    
    [dishDetailViewController.view setFrame:CGRectMake(8, 0, 660, 768)];
    detailViewController = dishDetailViewController;
    
    [darkView addSubview:detailViewController.view];
    
    [self.view addSubview:darkView];
    
}

- (void) showDishSearchResult: (NSString *) searchText {
    self.searchDemo = searchText;
    returnBtn.hidden = YES;
    nowSearch.text = [NSString stringWithFormat:@"当前搜索：%@", searchText];
    [searchDishViewController.view removeFromSuperview];
    [[self.view viewWithTag:9] removeFromSuperview];
    [self showDishView:0];
    self.searchDemo = nil;
}

- (void) showSearchMenu {
    [detailViewController.view removeFromSuperview];
    [[self.view viewWithTag:9] removeFromSuperview];
    returnBtn.hidden = NO;
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(260, 0, self.view.bounds.size.width - 340.0, self.view.bounds.size.height)];
    darkView.alpha = 1.0;
    darkView.backgroundColor = [UIColor clearColor];
    darkView.tag = 9;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchDishViewController *dishSearchDishViewController = [storyboard instantiateViewControllerWithIdentifier:@"SearchDishViewController"];
    [dishSearchDishViewController.view setFrame:CGRectMake(8, 0, 660, 768)];
    searchDishViewController = dishSearchDishViewController;
    searchDishViewController.delegate = self;
    
    [darkView addSubview:searchDishViewController.view];
    
    [self.view addSubview:darkView];
    
}

- (void)handleTapPress:(UITapGestureRecognizer *)gestureRecognizer {
    [self syncData];
}

- (IBAction)clickReturnBtn:(id)sender {
    returnBtn.hidden = YES;
    [[self.view viewWithTag:9] removeFromSuperview];
    [detailViewController.view removeFromSuperview];
    [searchDishViewController.view removeFromSuperview];
}

- (void)showDishView:(NSUInteger) index {
    // 检索菜品数据
    if (searchDemo) {
        self.dishList = [NSArray arrayWithArray:[DishModel searchDish:searchDemo]];
        UIButton *lastButton = (UIButton *)[self.view viewWithTag:buttonTag];
        UIColor *unCheckColor = [UIColor colorWithRed:196/255.0 green:156/255.0 blue:70/255.0 alpha:1];
        [lastButton setTitleColor:unCheckColor forState:UIControlStateNormal];
        [lastButton setBackgroundImage:[UIImage imageNamed:@"left-menu-unchecked" ] forState:UIControlStateNormal];
        buttonTag = -1;
        if ([self.dishList count] == 0) {
            noRecord.hidden = NO;
        } else {
            noRecord.hidden = YES;
        }
        if (searchDemo) {
            nowSearch.hidden = NO;
            searchBG.hidden = NO;
        }
    } else {
        if ([self.dishTypeList count] > 0) {
            NSString *typeId = ((DishTypeModel *)[self.dishTypeList objectAtIndex:index]).typeId;
            self.dishList = [NSArray arrayWithArray:[DishModel getDishByType:typeId]];
            if ([self.dishList count] == 0) {
                noRecord.hidden = NO;
            } else {
                noRecord.hidden = YES;
            }
        }
    }
    
    NSUInteger numberPages = [self getTotalPage:self.dishList];
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    self.menuPageControl.numberOfPages = numberPages;
    self.menuPageControl.userInteractionEnabled = NO;
    [[self.menuScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.menuScrollView.pagingEnabled = YES;
    self.menuScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.menuScrollView.frame) * numberPages, CGRectGetHeight(self.menuScrollView.frame));
    self.menuScrollView.showsHorizontalScrollIndicator = NO;
    self.menuScrollView.showsVerticalScrollIndicator = NO;
    self.menuScrollView.scrollsToTop = NO;
    self.menuScrollView.delegate = self;
    [self.menuScrollView setContentOffset:CGPointMake(0.0, 0.0)];
    self.menuPageControl.numberOfPages = numberPages;
    self.menuPageControl.currentPage = 0;
        
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    [self loadScrollViewWithPage:2];
}

- (void)syncData {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"同步数据将花费一定时间，请确保设备处于网络良好状态" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"开始", nil];
    alertView.tag = 10;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view.superview addSubview:HUD];
    [self.view bringSubviewToFront:HUD];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    //[HUD show:YES];
    if (alertView.tag == 10) {
        if (buttonIndex == 0) {
            return;
        }
        Reachability *r = [Reachability reachabilityWithHostName:WEBSERVICE_ADDRESS];
        //NSLog(@"%d", [r currentReachabilityStatus]);
        if ([r currentReachabilityStatus] != NotReachable) {
            //if ([r currentReachabilityStatus] == ) {
            HUD.labelText = @"连接中";
            HUD.minSize = CGSizeMake(135.f, 135.f);
            [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法连接网络" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
}

- (void) myProgressTask {
    sleep(2);
    // Switch to determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = @"获取数据";
    
    float progress = 0.0f;
    while (progress < 1.0f)
    {
        progress += 0.01f;
        HUD.progress = progress;
        usleep(20000);
    }
    
    // Back to indeterminate mode
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"导入数据";
    
    [SystemUtil syncData];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"完成";
    sleep(1);
    [self performSelectorOnMainThread:@selector(initPage) withObject:nil waitUntilDone:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSMutableArray *) listForPage:(int) pageNum {
    NSMutableArray *pageList = [[NSMutableArray alloc] init];
    int start = pageNum * PAGE_ITEM;
    int end = (pageNum + 1) * PAGE_ITEM;
    for (int i = start; i < end; i ++) {
        if (i <= ([self.dishList count] - 1))
            [pageList addObject:[self.dishList objectAtIndex:i]];
    }
    return pageList;
}

- (NSUInteger) getTotalPage:(NSArray *) listData {
    NSUInteger numberPages = listData.count;
    NSUInteger retNum = 0;
    
    float fltNum = numberPages / 4.0;
    int intNum = numberPages / PAGE_ITEM;
    if (fltNum > intNum) {
        retNum = intNum + 1;
    } else {
        retNum = intNum;
    }
    self.pageTotalNum = retNum;
    return retNum;
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
    return [self.dishTypeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DishTypeCell";
    DishTypeCell *cell = (DishTypeCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.dishTypeBtn.tag = indexPath.row + 100;
    cell.dishTypeBtn.titleLabel.font = [UIFont fontWithName:@"FZCuHuoYi-M25S" size:25];
    
    DishTypeModel *dishTypeModle = [self.dishTypeList objectAtIndex:indexPath.row];
    
    [cell.dishTypeBtn setTitle:dishTypeModle.typeName forState:UIControlStateNormal];
    
    if (cell.dishTypeBtn.tag == buttonTag) {
        UIColor *checkColor = [UIColor colorWithRed:96/255.0 green:38/255.0 blue:109/255.0 alpha:1];
        [cell.dishTypeBtn setTitleColor:checkColor forState:UIControlStateNormal];
        [cell.dishTypeBtn setBackgroundImage:[UIImage imageNamed:@"left-menu-checked" ] forState:UIControlStateNormal];
    } else {
        UIColor *unCheckColor = [UIColor colorWithRed:196/255.0 green:156/255.0 blue:70/255.0 alpha:1];
        [cell.dishTypeBtn setTitleColor:unCheckColor forState:UIControlStateNormal];
        [cell.dishTypeBtn setBackgroundImage:[UIImage imageNamed:@"left-menu-unchecked" ] forState:UIControlStateNormal];
    }
    [cell.dishTypeBtn addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
    [self clickReturnBtn:sender];
    nowSearch.hidden = YES;
    noRecord.hidden = YES;
    searchBG.hidden = YES;
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.dishTypeTableView];
    static NSString *CellIdentifier = @"DishTypeCell";
    NSIndexPath *indexPath = [self.dishTypeTableView indexPathForRowAtPoint: currentTouchPosition];

    if (indexPath != nil)
    {
        UIColor *checkColor = [UIColor colorWithRed:96/255.0 green:38/255.0 blue:109/255.0 alpha:1];
        DishTypeCell *cell = [self.dishTypeTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        
        
        UIButton *cellButton = (UIButton *)sender;
        if (buttonTag != cellButton.tag) {
            //SystemSoundID soundID;
            //AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"pop" ofType:@"wav" inDirectory:@"/"]]
            //                                 , &soundID);
            //AudioServicesPlaySystemSound (soundID);
            
            [cellButton setTitleColor:checkColor forState:UIControlStateNormal];
            [cellButton setBackgroundImage:[UIImage imageNamed:@"left-menu-checked" ] forState:UIControlStateNormal];
        
            UIButton *lastButton = (UIButton *)[self.view viewWithTag:buttonTag];
            UIColor *unCheckColor = [UIColor colorWithRed:196/255.0 green:156/255.0 blue:70/255.0 alpha:1];
            [lastButton setTitleColor:unCheckColor forState:UIControlStateNormal];
            [lastButton setBackgroundImage:[UIImage imageNamed:@"left-menu-unchecked" ] forState:UIControlStateNormal];
            buttonTag = cellButton.tag;
            
            [self showDishView:indexPath.row];
        }
    }
    [self.dishTypeTableView reloadData];
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= pageTotalNum)
        return;
    
    // replace the placeholder if necessary
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MenuListViewController *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        MenuListViewController *menuListViewController = [storyboard instantiateViewControllerWithIdentifier:@"MenuListViewController"];
        menuListViewController.page = page;
        controller = menuListViewController;
        controller.delegate = self;
        controller.dishList = [self listForPage:page];
        controller.searchText = self.searchDemo;
        
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.menuScrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self addChildViewController:controller];
        [self.menuScrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
    }
    
}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    NSUInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.menuPageControl.currentPage = page;
    self.currentPage = page;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // remove all the subviews from our scrollview
    for (UIView *view in self.menuScrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSUInteger numPages = self.dishList.count;
    
    // adjust the contentSize (larger or smaller) depending on the orientation
    self.menuScrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.menuScrollView.frame) * numPages, CGRectGetHeight(self.menuScrollView.frame));
    
    // clear out and reload our pages
    self.viewControllers = nil;
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numPages; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    [self loadScrollViewWithPage:self.menuPageControl.currentPage - 1];
    [self loadScrollViewWithPage:self.menuPageControl.currentPage];
    [self loadScrollViewWithPage:self.menuPageControl.currentPage + 1];
    [self gotoPage:NO]; // remain at the same page (don't animate)
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.menuPageControl.currentPage;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // update the scroll view to the appropriate page
    CGRect bounds = self.menuScrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.menuScrollView scrollRectToVisible:bounds animated:animated];
}

- (IBAction)goBackHome {
    [self viewDidLoad];
}

@end
