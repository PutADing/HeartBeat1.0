//
//  HBNavigationController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/2/2.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBNavigationController.h"

@interface HBNavigationController ()

@end

@implementation HBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        self.navigationBar.translucent = YES;
    }
    
//    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {       self.navigationController.navigationBar.tintColor = [UIColor brownColor];    }
//    else {
//        self.navigationController.navigationBar.barTintColor = [UIColor brownColor];
//    }
    
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
