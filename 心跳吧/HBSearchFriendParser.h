//
//  HBSearchFriendParser.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/23.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBSearchFriendParser : NSObject

-(void)returnSearchFriendArrayWithArray:(NSArray* )userList AndCallBack:(void (^)(NSMutableArray* userArr))block;

@end
