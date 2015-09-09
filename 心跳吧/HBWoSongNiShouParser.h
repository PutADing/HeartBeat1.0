//
//  HBWoSongNiShouParser.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/28.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBWoSongNiShouParser : NSObject

+(id)createWoSongNiShouParser;

-(void)returnWoSongArrayWithDictioinary:(NSDictionary* )jsonDic AndBlock:(void (^) (NSMutableArray* songOrderArr))block;

-(void)returnNiShouArrayWithDictioinary:(NSDictionary* )jsonDic AndBlock:(void (^) (NSMutableArray* shouOrderArr))block;

@end
