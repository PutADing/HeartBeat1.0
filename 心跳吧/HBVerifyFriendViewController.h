//
//  HBVerifyFriendViewController.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/28.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBBaseViewController.h"
#import "HBUser.h"
#import "HBNewFriendRequest.h"

@interface HBVerifyFriendViewController : HBBaseViewController
@property (nonatomic, strong)HBUser* user;
@property (nonatomic, strong)UIImage* headImage;//头像
@property (nonatomic, copy)NSString* descriptionStr;//验证消息
@property (nonatomic, assign)HBNewFriendRequestStatus status;//好友请求状态

-(void)returnStatus:(void (^) (HBNewFriendRequestStatus requestStatus))block;

@end
