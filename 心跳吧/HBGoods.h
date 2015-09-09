//
//  HBGoods.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/20.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBGoods : NSObject <NSCoding>
@property (nonatomic, assign)NSInteger goodsId;
@property (nonatomic, strong)NSArray* goodsImageAddrList;
@property (nonatomic, assign)BOOL ifUndercarriage;//0未下架 1已下架
@property (nonatomic, assign)NSInteger likeNum;
@property (nonatomic, copy)NSString* name;
@property (nonatomic, assign)BOOL postageType;//0自己付 1对方付
@property (nonatomic, assign)NSInteger wantNum;

@end
