//
//  HBGoods.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/20.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBGoods.h"

@implementation HBGoods


-(id)initWithCoder:(NSCoder *)decoder{
    self.goodsId = [decoder decodeIntegerForKey:@"goodsId"];
    self.goodsImageAddrList = [decoder decodeObjectForKey:@"goodsImageAddrList"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.ifUndercarriage = [decoder decodeBoolForKey:@"ifUndercarriage"];
    self.postageType = [decoder decodeBoolForKey:@"postageType"];
    self.likeNum = [decoder decodeIntegerForKey:@"likeNum"];
    self.wantNum = [decoder decodeIntegerForKey:@"wantNum"];

    return self;
}


-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeInteger:self.goodsId forKey:@"goodsId"];
    [encoder encodeObject:self.goodsImageAddrList forKey:@"goodsImageAddrList"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeBool:self.ifUndercarriage forKey:@"ifUndercarriage"];
    [encoder encodeBool:self.postageType forKey:@"postageType"];
    [encoder encodeInteger:self.likeNum forKey:@"likeNum"];
    [encoder encodeInteger:self.wantNum forKey:@"wantNum"];
}

@end
