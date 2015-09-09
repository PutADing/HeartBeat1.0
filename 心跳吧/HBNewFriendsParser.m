//
//  HBNewFriendsParser.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/6.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBNewFriendsParser.h"
#import "HBNewFriendRequest.h"
#import "HBUser.h"

@implementation HBNewFriendsParser

+(id)createHBNewFriendsParser {
    return [[HBNewFriendsParser alloc]init];
}


-(void)returnNewFriendsArrayWithDataArray:(NSArray *)verifyFriendsArr AndBlock:(void (^)(NSMutableArray *))block {
    NSMutableArray* friendRequestArr = [NSMutableArray array];
    
    for (NSDictionary* requestDic in verifyFriendsArr) {
        HBNewFriendRequest* friendRequest = [[HBNewFriendRequest alloc]init];
        
        friendRequest.descriptionStr = requestDic[@"description"];
        NSInteger status = [requestDic[@"status"]integerValue];
        if (status == 1) {
            friendRequest.status = HBNewFriendRequestFailed;
        }else if (status == 2) {
            friendRequest.status = HBNewFriendRequestSucceed;
        }else if (status == -1) {
            friendRequest.status = HBNewFriendRequestVerify;
        }
        
        NSDictionary* fstUserDic = requestDic[@"fstUser"];
        HBUser* fstUser = [[HBUser alloc]init];
        fstUser.avatar = fstUserDic[@"avatar"];
        fstUser.userID = [fstUserDic[@"userId"]integerValue];
        fstUser.heartBeatNumber = fstUserDic[@"heartbeatNumber"];
        fstUser.nickName = fstUserDic[@"nickName"];
        fstUser.gender = fstUserDic[@"gender"];
        fstUser.level = [fstUserDic[@"level"]integerValue];
        fstUser.personalizedSignature = fstUserDic[@"personalizedSignature"];
        friendRequest.fstUser = fstUser;
        
        NSDictionary* secUserDic = requestDic[@"secUser"];
        HBUser* secUser = [[HBUser alloc]init];
        secUser.avatar = secUserDic[@"avatar"];
        secUser.userID = [secUserDic[@"userId"]integerValue];
        secUser.heartBeatNumber = secUserDic[@"heartbeatNumber"];
        secUser.nickName = secUserDic[@"nickName"];
        secUser.gender = secUserDic[@"gender"];
        secUser.level = [secUserDic[@"level"]integerValue];
        secUser.personalizedSignature = secUserDic[@"personalizedSignature"];
        friendRequest.secUser = secUser;
        
        [friendRequestArr addObject:friendRequest];
    }
    
    block(friendRequestArr);
}

@end
