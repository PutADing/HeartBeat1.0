//
//  HBBaseViewController.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/2/2.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
#import "SVPullToRefresh.h"
#import "HBTool.h"
#import "HBReachability.h"

@interface HBBaseViewController : UIViewController <NSURLConnectionDataDelegate, NSURLConnectionDelegate, UIScrollViewDelegate>

@property (nonatomic, strong)UILabel* networkingStatusLab;

-(instancetype)init;

-(UIStatusBarStyle)preferredStatusBarStyle;

-(void)judgeNetworkingStatusWithY:(CGFloat )origin_y;
-(void)showNetworkingStatusViewWithY:(CGFloat )origin_y;//显示联网状态 视图
-(void)hideNetworkingStatusView;//删除联网状态 视图

@end
