//
//  HBGoodsModel.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/20.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBGoodsModel.h"
#import "HBGoods.h"

@implementation HBGoodsModel

+(id)createGoodsModel {
    return [[HBGoodsModel alloc]init];
}

-(void)returnGoodsArrayWithArray:(NSArray *)goodsList AndBlock:(void (^)(NSMutableArray *))block {
    NSMutableArray* goodsArr = [NSMutableArray array];
    
    for (NSDictionary* goodsDic in goodsList) {
        HBGoods* goods = [[HBGoods alloc]init];
        goods.goodsId = [goodsDic[@"goodsId"]integerValue];
        goods.goodsImageAddrList = goodsDic[@"goodsImageAddrList"];
        if ([goodsDic[@"ifUndercarriage"]integerValue] == 1) {
            goods.ifUndercarriage = YES;
        }else if ([goodsDic[@"ifUndercarriage"]integerValue] == 0) {
            goods.ifUndercarriage = NO;
        }
        goods.likeNum = [goodsDic[@"likeNum"]integerValue];
        goods.name = goodsDic[@"name"];
        if ([goodsDic[@"postageType"]integerValue] == 1) {
            goods.postageType = YES;
        }else if ([goodsDic[@"postageType"]integerValue] == 0) {
            goods.postageType = NO;
        }
        goods.wantNum = [goodsDic[@"wantNum"]integerValue];
        
        [goodsArr addObject:goods];
    }
    
    block(goodsArr);
}


static NSString* keyName = @"goods";

-(void)saveGoodsArray:(NSArray *)array WithUserID:(NSInteger)userId AndPageSize:(NSInteger)pageSize AndPageIndex:(NSInteger)pageIndex {
    NSString* fileName = [NSString stringWithFormat:@"goods-%ld-%ld-%ld", userId, pageSize, pageIndex];
    NSMutableData* data = [NSMutableData data];
    NSKeyedArchiver* arch = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [arch encodeObject:array forKey:keyName];
    [arch finishEncoding];
    NSString* filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", fileName];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {//若该文件已经存在，则先删除该文件
        [manager removeItemAtPath:filePath error:nil];
    }
    
    [data writeToFile:filePath atomically:YES];
}

-(NSArray *)getGoodsArrayWithUserID:(NSInteger)userId AndPageSize:(NSInteger)pageSize AndPageIndex:(NSInteger)pageIndex {
    
    NSString* fileName = [NSString stringWithFormat:@"goods-%ld-%ld-%ld", userId, pageSize, pageIndex];
    NSString* filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", fileName];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver* unArch = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSArray* array = [unArch decodeObjectForKey:keyName];
    [unArch finishDecoding];
    return array;
}

@end
