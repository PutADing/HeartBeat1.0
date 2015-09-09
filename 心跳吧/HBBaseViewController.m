//
//  HBBaseViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/2/2.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBBaseViewController.h"

@interface HBBaseViewController ()

@end

@implementation HBBaseViewController

-(instancetype)init {
    self = [super init];
    if (self != nil) {
        [self judgeNetworkingStatusWithY:NAVIGATIOINBARHEIGHT];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)judgeNetworkingStatusWithY:(CGFloat)origin_y {
    __block BOOL networking;
    HBReachability* reach = [[HBTool shareTool]getHBReachability];
    reach.reachableBlock = ^(HBReachability* reach) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE!");
            networking = YES;
            [self hideNetworkingStatusView];
        });
    };
    
    reach.unreachableBlock = ^(HBReachability* reach) {
        NSLog(@"UNREACHABLE!");
        networking = NO;
        [self showNetworkingStatusViewWithY:origin_y];
    };
    
    [reach startNotifier];
}

-(void)showNetworkingStatusViewWithY:(CGFloat)origin_y {
    self.networkingStatusLab = [[UILabel alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, 20)];
    self.networkingStatusLab.text = @"网络连接异常！";
    self.networkingStatusLab.font = FONT_17;
    self.networkingStatusLab.backgroundColor = [UIColor orangeColor];
    [self.view insertSubview:self.networkingStatusLab atIndex:1000];
}

-(void)hideNetworkingStatusView {
    [self.networkingStatusLab removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
