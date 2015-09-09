//
//  HBNewFriendRequest.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/27.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBUser.h"

//2:成功 1:失败 -1:等待对方(secUser)验证
typedef enum {
    HBNewFriendRequestVerify = -1,
    HBNewFriendRequestFailed = 1,
    HBNewFriendRequestSucceed = 2
} HBNewFriendRequestStatus;

@interface HBNewFriendRequest : NSObject
@property (nonatomic, strong)HBUser* fstUser;
@property (nonatomic, strong)HBUser* secUser;
@property (nonatomic, copy)NSString* descriptionStr;
@property (nonatomic, assign)HBNewFriendRequestStatus status;
@property (nonatomic, assign)NSInteger requestId;

@end
