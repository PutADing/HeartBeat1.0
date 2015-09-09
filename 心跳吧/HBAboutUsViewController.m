//
//  HBAboutUsViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/1.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBAboutUsViewController.h"

@interface HBAboutUsViewController ()

@end

@implementation HBAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = COLOR_WHITE1;
    
    [self createLabelWithY:NAVIGATIOINBARHEIGHT];
}

-(void)createLabelWithY:(CGFloat )origin_y {
    UILabel* textLab = [[UILabel alloc]initWithFrame:CGRectMake(10, origin_y, self.view.frame.size.width - 10*2, 100)];
    [self.view addSubview:textLab];
    textLab.font = FONT_17;
    textLab.text = @"心跳吧是上海心跳网络科技有限公司旗下的一款软件应用。在这里，用户可以将自己闲置的图书、衣服、DIY作品等共享给其他用户，聚拢人气，挑逗心跳，同时可以获得他人共享的东西。";
    CGFloat textLab_height = [textLab sizeThatFits:CGSizeMake(textLab.frame.size.width, MAXFLOAT)].height;
    textLab.frame = CGRectMake(textLab.frame.origin.x, textLab.frame.origin.y, textLab.frame.size.width, textLab_height);
    
    UILabel* rightsLab = [[UILabel alloc]initWithFrame:CGRectMake(30, self.view.frame.size.height - 100, self.view.frame.size.width - 30*2, 100)];
    [self.view addSubview:rightsLab];
    rightsLab.font = FONT_17;
    rightsLab.text = @"Copyright 2014-2015. All Rights Reserved沪ICP备14053409号-1";
    CGFloat rightLab_height = [rightsLab sizeThatFits:CGSizeMake(rightsLab.frame.size.width, MAXFLOAT)].height;
    rightsLab.frame = CGRectMake(rightsLab.frame.origin.x, rightsLab.frame.origin.y, rightsLab.frame.size.width, rightLab_height);
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
