//
//  DishDetailViewController.m
//  eMenuZY
//
//  Created by Gong Lingxiao on 15/1/19.
//  Copyright (c) 2015年 宫凌霄. All rights reserved.
//

#import "DishDetailViewController.h"

@interface DishDetailViewController ()

@end

@implementation DishDetailViewController

@synthesize dishName;
@synthesize dishImage;
@synthesize bigLabel;
@synthesize normalLabel;
@synthesize smallLabel;
@synthesize bigYuan;
@synthesize normalYuan;
@synthesize smallYuan;
@synthesize bigCutLine;
@synthesize normalCutLine;
@synthesize smallCutLine;
@synthesize descImage;
@synthesize descText;
@synthesize dishModel;
@synthesize leftTag;
@synthesize rightTag;
@synthesize bigLine;
@synthesize normalLine;
@synthesize smallLine;
@synthesize bigUnit;
@synthesize normalUnit;
@synthesize smallUnit;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initPage];
}

- (void)initPage {
    //NSLog(@"%@", dishModel.imageUrl);
    NSString *dishNameValue = dishModel.dishName;
    NSString *dishPriceValue = dishModel.dishPrice;
    NSString *dishPriceBigValue = dishModel.dishPriceBig;
    NSString *dishPriceSmallValue = dishModel.dishPriceSmall;
    //NSString *unitValue = dishModel.unit;
    //NSString *unitBigValue = dishModel.unitBig;
    //NSString *unitSnallValue = dishModel.unitSmall;
    NSString *zhuChuValue = dishModel.zhuChu;
    NSString *zhaoPaiValue = dishModel.zhaoPai;
    NSString *desc = dishModel.dishDesc;
    UIColor *dishColor = [UIColor colorWithRed:196/255.0 green:156/255.0 blue:70/255.0 alpha:1];
    descText.editable = YES;
    descText.font = [UIFont fontWithName:@"Microsoft YaHei" size:16];
    [descText setTextColor:dishColor];
    descText.text = desc;
    descText.editable = NO;
    dishName.text = dishNameValue;
    NSLog(@"%@", dishModel.imageUrl);
    [dishImage sd_setImageWithURL:[NSURL fileURLWithPath:dishModel.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
    // red
    UIColor *priceColor = [UIColor colorWithRed:189/255.0 green:40/255.0 blue:24/255.0 alpha:1];
    
    UITextView *dishPriceNormal = [[UITextView alloc]initWithFrame:CGRectMake(116, 550, 130, 42)];
    dishPriceNormal.font = [UIFont fontWithName:@"Monotype Corsiva" size:40];
    [dishPriceNormal setTextColor:priceColor];
    dishPriceNormal.textAlignment = NSTextAlignmentRight;
    dishPriceNormal.editable = false;
    dishPriceNormal.backgroundColor = [UIColor clearColor];
    
    dishPriceNormal.text = [dishPriceSmallValue isEqualToString:@"<null>"] ? @"" : dishPriceSmallValue;
    
    UITextView *dishPriceSmall = [[UITextView alloc]initWithFrame:CGRectMake(116, 600, 130, 42)];
    dishPriceSmall.font = [UIFont fontWithName:@"Monotype Corsiva" size:40];
    [dishPriceSmall setTextColor:priceColor];
    dishPriceSmall.textAlignment = NSTextAlignmentRight;
    dishPriceSmall.editable = false;
    dishPriceSmall.backgroundColor = [UIColor clearColor];
    
    dishPriceSmall.text = [dishPriceValue isEqualToString:@"<null>"] ? @"" : dishPriceValue;
    
    UITextView *dishPriceBig = [[UITextView alloc]initWithFrame:CGRectMake(116, 650, 130, 42)];
    dishPriceBig.font = [UIFont fontWithName:@"Monotype Corsiva" size:40];
    [dishPriceBig setTextColor:priceColor];
    dishPriceBig.textAlignment = NSTextAlignmentRight;
    dishPriceBig.editable = false;
    dishPriceBig.backgroundColor = [UIColor clearColor];
    
    dishPriceBig.text = [dishPriceBigValue isEqualToString:@"<null>"] ? @"" : dishPriceBigValue;
    
    if ([@"1" isEqualToString:zhaoPaiValue] && [@"0" isEqualToString:zhuChuValue]) {
        leftTag.image = [UIImage imageNamed:@"center-icon-zhaopai"];
    }
    if ([@"0" isEqualToString:zhaoPaiValue] && [@"1" isEqualToString:zhuChuValue]) {
        leftTag.image = [UIImage imageNamed:@"center-icon-zhuchu"];
    }
    if ([@"1" isEqualToString:zhaoPaiValue] && [@"1" isEqualToString:zhuChuValue]) {
        leftTag.image = [UIImage imageNamed:@"center-icon-zhaopai"];
        rightTag.image = [UIImage imageNamed:@"center-icon-zhuchu"];
    }
    
    [self.view addSubview:dishPriceNormal];
    [self.view addSubview:dishPriceSmall];
    [self.view addSubview:dishPriceBig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
