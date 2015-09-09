//
//  HBSearchFriendParser.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/23.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBSearchFriendParser.h"
#import "HBUser.h"

@implementation HBSearchFriendParser

-(void)returnSearchFriendArrayWithArray:(NSArray *)userList AndCallBack:(void (^)(NSMutableArray *))block {
    NSMutableArray* userArr = [NSMutableArray array];
    
    for (NSDictionary* userDic in userList) {
        HBUser* user = [[HBUser alloc]init];
        if (![userDic[@"avatar"]isKindOfClass:[NSNull class]]) {
            if (![userDic[@"avatar"] isEqualToString:@"null  "] && ![userDic[@"avatar"] isEqualToString:@"null"]) {
                user.avatar = userDic[@"avatar"];
            }
        }
        if (![userDic[@"gender"] isKindOfClass:[NSNull class]]) {
            user.gender = userDic[@"gender"];
        }
        if (![userDic[@"personalizedSignature"] isKindOfClass:[NSNull class]]) {
            user.personalizedSignature = userDic[@"personalizedSignature"];
        }
        user.heartBeatNumber = userDic[@"heartbeatNumber"];
        user.nickName = userDic[@"nickName"];
        user.phoneNumber = userDic[@"phoneNumber"];
        user.registerData = userDic[@"registerDate"];
        user.userID = [userDic[@"userId"]integerValue];
        
        [userArr addObject:user];
    }
    
    block(userArr);
}

@end
