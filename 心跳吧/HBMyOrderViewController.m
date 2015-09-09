//
//  HBMyOrderViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/26.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBMyOrderViewController.h"
#import "HBTool.h"
#import "HBOrderListViewController.h"
#import "HBAddressManageViewController.h"

@interface HBMyOrderViewController ()
@property (nonatomic, strong)UIButton* orderListBtn;//订单记录
@property (nonatomic, strong)UIButton* addAddressBtn;//地址管理

@end

@implementation HBMyOrderViewController

//每行的高度
#define LINE_HEIGHT 50
//行与行之间间距
#define SPACE_LINE 15
//距离左的间距
#define SPACE_X 10
//距离上、下的间距
#define SPACE_Y 5

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[HBTool shareTool]isIOS7_Later]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    self.title = @"我的订单";
    self.view.backgroundColor = BACKGROUNGCOLOR_GRAY1;
    
    self.orderListBtn = [self createOrderListButtonWithY:NAVIGATIOINBARHEIGHT+SPACE_LINE AndHeight:LINE_HEIGHT];
    [self.view addSubview:self.orderListBtn];
    
    self.addAddressBtn = [self createAddAddressButtonWithY:SPACE_LINE + self.orderListBtn.frame.origin.y + self.orderListBtn.frame.size.height AndHeight:LINE_HEIGHT];
    [self.view addSubview:self.addAddressBtn];
}

//创建 订单记录
-(UIButton* )createOrderListButtonWithY:(CGFloat )origin_y AndHeight:(CGFloat )frame_height {
    UIButton* orderBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, frame_height)];
    orderBtn.backgroundColor = COLOR_WHITE1;
    [orderBtn addTarget:self action:@selector(clickedOrderListButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* orderIV = [self createImageViewWithX:SPACE_X AndY:SPACE_Y AndWidth:40 AndHeight:40 AndNameString:@"order.png"];
    [orderBtn addSubview:orderIV];
    
    UILabel* orderLab = [self createLabelWithX:SPACE_X*2 + orderIV.frame.size.width AndWidth:70 AndHeight:20 AndTitleString:@"订单记录"];
    [orderBtn addSubview:orderLab];
    
    UIImageView* jianTouIV = [self createImageViewWithX:orderBtn.frame.size.width - SPACE_X - 16 AndY:(LINE_HEIGHT - 16)/2 AndWidth:16 AndHeight:16 AndNameString:@"jianTou.png"];
    [orderBtn addSubview:jianTouIV];
    
    return orderBtn;
}

//点击了 订单记录
-(void)clickedOrderListButton:(UIButton* )sender {
    HBOrderListViewController* HBOrderListVC = [[HBOrderListViewController alloc]init];
    [self.navigationController pushViewController:HBOrderListVC animated:NO];
}

//创建 地址管理
-(UIButton* )createAddAddressButtonWithY:(CGFloat )origin_y AndHeight:(CGFloat )frame_height {
    UIButton* addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, frame_height)];
    addBtn.backgroundColor = COLOR_WHITE1;
    [addBtn addTarget:self action:@selector(clickedAddressManageButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* addIV = [self createImageViewWithX:SPACE_X AndY:SPACE_Y AndWidth:40 AndHeight:40 AndNameString:@"car.png"];
    [addBtn addSubview:addIV];
    
    UILabel* addLab = [self createLabelWithX:SPACE_X*2 + addIV.frame.size.width AndWidth:70 AndHeight:20 AndTitleString:@"管理地址"];
    [addBtn addSubview:addLab];
    
    UIImageView* jianTouIV = [self createImageViewWithX:addBtn.frame.size.width - SPACE_X - 16 AndY:(LINE_HEIGHT - 16)/2 AndWidth:16 AndHeight:16 AndNameString:@"jianTou.png"];
    [addBtn addSubview:jianTouIV];
    
    return addBtn;
}

//点击了 地址管理
-(void)clickedAddressManageButton:(UIButton* )sender {
    HBAddressManageViewController* HBAddressManageVC = [[HBAddressManageViewController alloc]init];
    [self.navigationController pushViewController:HBAddressManageVC animated:NO];
}

-(UIImageView* )createImageViewWithX:(CGFloat )origin_x AndY:(CGFloat )origin_y AndWidth:(CGFloat )frame_width AndHeight:(CGFloat )frame_height AndNameString:(NSString* )imageName {
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(origin_x, origin_y, frame_width, frame_height)];
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}

-(UILabel* )createLabelWithX:(CGFloat )origin_x AndWidth:(CGFloat )frame_width AndHeight:(CGFloat )frame_height AndTitleString:(NSString* )titleString {
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(origin_x, (LINE_HEIGHT - frame_height)/2, frame_width, frame_height)];
    label.text = titleString;
    label.textColor = COLOR_BLACK1;
    label.font = FONT_17;
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
