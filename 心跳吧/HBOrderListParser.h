//
//  HBOrderListParser.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/22.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBOrderListParser : NSObject

-(NSArray* )returnWantingOrderListWithJSONDic:(NSDictionary* )jsonDic;

-(NSArray* )returnSongOrderListWithJSONDic:(NSDictionary* )jsonDic;

-(NSArray* )returnShouOrderListWithJSONDic:(NSDictionary* )jsonDic;

@end
