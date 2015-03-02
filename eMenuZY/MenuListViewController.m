//
//  MenuListViewController.m
//  eMenuZY
//
//  Created by Gong Lingxiao on 15/1/19.
//  Copyright (c) 2015年 宫凌霄. All rights reserved.
//

#import "MenuListViewController.h"

@interface MenuListViewController ()

@end

@implementation MenuListViewController

@synthesize page;
@synthesize dishList;
@synthesize searchText;
@synthesize topSearchImage;
@synthesize topSearchLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (!searchText) {
        topSearchImage.hidden = YES;
        topSearchLabel.hidden = YES;
    } else {
        topSearchLabel.text = [NSString stringWithFormat:@"当前搜索:%@", searchText];
    }
    
    for (int i = 0; i < dishList.count; i++) {
        [self.view addSubview:[self createImage:i]];
        [self.view addSubview:[self createBoardImage:i]];
    }
    
}

- (UIImageView *)createImage:(int) index {
    int k = index % 2;
    int i = 1;
    if (index < 2)
        i = 0;
    
    DishModel *dishModel = [self.dishList objectAtIndex:index];
    NSString *imageSmall = [dishModel.imageUrl stringByAppendingString:@"_s.jpg"];
    NSLog(@"%@", imageSmall);
    UIImageView *dishImageView = [[UIImageView alloc] initWithFrame:CGRectMake(45 + k * 335, 81 + i * 358, 257, 231)];
    [dishImageView sd_setImageWithURL:[NSURL fileURLWithPath:imageSmall] placeholderImage:[UIImage imageNamed:@""]];
    dishImageView.layer.masksToBounds = YES; //没这句话它圆不起来
    dishImageView.layer.cornerRadius = 8.0; //设置图片圆角的尺度
    
    
    dishImageView.userInteractionEnabled = YES;
    dishImageView.tag = 1000 + index;
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPhoto:)];
    [dishImageView addGestureRecognizer:tapAction];

    return dishImageView;
}

- (UIImageView *)createBoardImage:(int) index {
    int k = index % 2;
    int i = 1;
    if (index < 2)
        i = 0;
    
    DishModel *dishModel = [self.dishList objectAtIndex:index];
    NSString *dishPriceValue = dishModel.dishPrice;
    NSString *dishNameValue = dishModel.dishName;
    NSString *dishPriceBigValue = dishModel.dishPriceBig;
    NSString *dishPriceSmallValue = dishModel.dishPriceSmall;
    NSString *unitValue = dishModel.unit;
    
    UILabel *dishName = [[UILabel alloc]initWithFrame:CGRectMake(68, 297, 180, 22)];
    UILabel *dishGuding = [[UILabel alloc]initWithFrame:CGRectMake(160, 261, 20, 22)];
    UITextView *dishPrice = [[UITextView alloc]initWithFrame:CGRectMake(100, 228, 67, 29)];
    UILabel *dishYen = [[UILabel alloc]initWithFrame:CGRectMake(150, 240, 27, 22)];
    UILabel *downAsk = nil;
    UILabel *dishUnit = nil;
    if (unitValue.length == 2) {
        downAsk = [[UILabel alloc]initWithFrame:CGRectMake(139, 261, 20, 22)];
        //UILabel *dishUnit = [[UILabel alloc]initWithFrame:CGRectMake(112, 261, 40, 22)];
        dishUnit = [[UILabel alloc]initWithFrame:CGRectMake(145, 261, 40, 22)];
    } else {
        downAsk = [[UILabel alloc]initWithFrame:CGRectMake(149, 261, 20, 22)];
        dishUnit = [[UILabel alloc]initWithFrame:CGRectMake(155, 261, 40, 22)];
    }
    
    
    UILabel *dishMore = [[UILabel alloc]initWithFrame:CGRectMake(173, 261, 20, 22)];
    
    UIColor *priceColor = [UIColor colorWithRed:189/255.0 green:40/255.0 blue:24/255.0 alpha:1];
    UIColor *dishColor = [UIColor colorWithRed:196/255.0 green:156/255.0 blue:70/255.0 alpha:1];
    
    dishPrice.font = [UIFont fontWithName:@"Monotype Corsiva" size:25];
    [dishPrice setTextColor:priceColor];
    dishPrice.textAlignment = NSTextAlignmentRight;
    dishPrice.editable = false;
    dishPrice.backgroundColor = [UIColor clearColor];
    
    dishYen.font = [UIFont fontWithName:@"FZCuHuoYi-M25S" size:12];
    [dishYen setTextColor:priceColor];
    dishYen.textAlignment = NSTextAlignmentRight;
    
    dishGuding.font = [UIFont fontWithName:@"FZCuHuoYi-M25S" size:12];
    [dishGuding setTextColor:priceColor];
    
    dishMore.font = [UIFont fontWithName:@"FZCuHuoYi-M25S" size:12];
    [dishMore setTextColor:priceColor];
    
    downAsk.font = [UIFont fontWithName:@"FZCuHuoYi-M25S" size:15];
    [downAsk setTextColor:priceColor];
    
    dishUnit.font = [UIFont fontWithName:@"FZCuHuoYi-M25S" size:12];
    [dishUnit setTextColor:priceColor];
    //dishUnit.textAlignment = NSTextAlignmentRight;
    
    dishName.font = [UIFont fontWithName:@"FZCuHuoYi-M25S" size:17];
    [dishName setTextColor:dishColor];
    dishName.textAlignment = NSTextAlignmentCenter;
    
    downAsk.text = @"/";
    dishGuding.text = @"份";
    dishYen.text = @"元";
    if (([@"0" isEqualToString:dishPriceBigValue] && [@"0" isEqualToString:dishPriceSmallValue]) || ([@"" isEqualToString:dishPriceBigValue] && [@"" isEqualToString:dishPriceSmallValue])) {
        dishMore.text = @"";
    } else {
        dishMore.text = @"等";
    }

    dishUnit.text = unitValue;
    dishName.text = dishNameValue;
    dishPrice.text = dishPriceValue;
    UIImageView *bordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16 + k * 335, 35 + i * 358, 317, 350)];
    bordImageView.image = [UIImage imageNamed:@"list-frame-border.png"];
    
    [bordImageView addSubview:dishName];
    [bordImageView addSubview:dishMore];
    [bordImageView addSubview:dishUnit];
    //[bordImageView addSubview:dishGuding];
    [bordImageView addSubview:downAsk];
    [bordImageView addSubview:dishYen];
    [bordImageView addSubview:dishPrice];
    
    return bordImageView;
}

- (void)clickPhoto:(UITapGestureRecognizer*)recognizer {
    UIImageView *tableGridImage = (UIImageView*)recognizer.view;
    int i = tableGridImage.tag - 1000;
    DishModel *dishModel = [dishList objectAtIndex:i];
    [self.delegate showDishDetail:dishModel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
