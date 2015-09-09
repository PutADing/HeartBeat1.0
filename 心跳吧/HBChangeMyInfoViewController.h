//
//  HBChangeMyInfoViewController.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/17.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//



//从 个人主页 修改个人信息时跳转到该类
#import "HBAddUserInfoViewController.h"

@interface HBChangeMyInfoViewController : HBAddUserInfoViewController
@property (nonatomic, strong)UIImage* headImage;
@property (nonatomic, copy)NSString* placeString;//地区

@end
