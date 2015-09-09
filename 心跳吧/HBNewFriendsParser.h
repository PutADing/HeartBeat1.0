//
//  HBNewFriendsParser.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/6.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBNewFriendsParser : NSObject

+createHBNewFriendsParser;

-(void )returnNewFriendsArrayWithDataArray:(NSArray* )verifyFriendsArr AndBlock:(void (^)(NSMutableArray* friendRequestArr))block;

@end
