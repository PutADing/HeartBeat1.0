//
//  HBGoodsModel.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/20.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBGoodsModel : NSObject

+(id)createGoodsModel;

-(void)returnGoodsArrayWithArray:(NSArray *)goodsList AndBlock:(void (^)(NSMutableArray *goodsArr))block;

//将联系人数据保存在沙盒中
-(void)saveGoodsArray:(NSArray* )array WithUserID:(NSInteger )userId AndPageSize:(NSInteger )pageSize AndPageIndex:(NSInteger )pageIndex;

//从沙盒获取联系人数据
-(NSArray* )getGoodsArrayWithUserID:(NSInteger )userId AndPageSize:(NSInteger )pageSize AndPageIndex:(NSInteger )pageIndex;

@end
