//
//  HBOrderListParser.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/22.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBOrderListParser.h"

@implementation HBOrderListParser

-(NSArray *)returnWantingOrderListWithJSONDic:(NSDictionary *)jsonDic {
    NSMutableArray* wantArr = [NSMutableArray array];
    NSArray* goodsList = jsonDic[@"goodsList"];
    [wantArr addObjectsFromArray:goodsList];
    return wantArr;
}

-(NSArray *)returnSongOrderListWithJSONDic:(NSDictionary *)jsonDic {
    NSMutableArray* songArr = [NSMutableArray array];
    NSArray* orderList = jsonDic[@"orderList"];
    [songArr addObjectsFromArray:orderList];
    return songArr;
}

-(NSArray *)returnShouOrderListWithJSONDic:(NSDictionary *)jsonDic {
    NSMutableArray* shouArr = [NSMutableArray array];
    NSArray* orderList = jsonDic[@"orderList"];
    [shouArr addObjectsFromArray:orderList];
    return shouArr;
}


/*
 想要中
 oriderList_jsonDic={
 goodsList =     (
 {
 goodsId = 81;
 goodsImageAddrList = (
 "http://test-upload-image.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150521182146_0_1.jpg"
 );
 ifUndercarriage = 0;
 likeNum = 0;
 name = "\U4e00\U4f11";
 owner = {
 avatar = "http://heartbeat-avatar.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150508133543_1.jpg";
 gender = "\U7537";
 heartbeatNumber = 888888;
 nickName = hope;
 personalizedSignature = "We have a dream";
 userId = 1;
 };
 postageType = 1;
 wantNum = 0;
 }
 );
 msg = "\U67e5\U627e\U6210\U529f";
 status = 1;
 }
 
 */

/*送出
 oriderList_jsonDic={
 msg = "\U67e5\U8be2\U6210\U529f";
 orderList =     (
 {
 goods =             {
 description = "\U7b14";
 goodsId = 92;
 goodsImageAddrList =                 (
 "http://test-upload-image.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150522110848_0_1.jpg"
 );
 name = "\U7b14";
 postageType = 1;
 };
 id = 78;
 orderNumber = 15052211150002;
 },
 {
 goods =             {
 description = "\U597d\U7528";
 goodsId = 89;
 goodsImageAddrList =                 (
 "http://test-upload-image.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150522095826_0_1.jpg"
 );
 name = "\U5145\U7535\U5b9d";
 postageType = 1;
 };
 id = 75;
 orderNumber = 15052210030002;
 }
 );
 status = 1;
 }
 */


/*收进
 oriderList_jsonDic={
 msg = "\U67e5\U8be2\U6210\U529f";
 orderList =     (
 {
 goods =             {
 description = "\U7b14";
 goodsId = 92;
 goodsImageAddrList =                 (
 "http://test-upload-image.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150522110848_0_1.jpg"
 );
 name = "\U7b14";
 postageType = 1;
 };
 id = 78;
 orderNumber = 15052211150002;
 },
 {
 goods =             {
 description = "\U597d\U7528";
 goodsId = 89;
 goodsImageAddrList =                 (
 "http://test-upload-image.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150522095826_0_1.jpg"
 );
 name = "\U5145\U7535\U5b9d";
 postageType = 1;
 };
 id = 75;
 orderNumber = 15052210030002;
 }
 );
 status = 1;
 }
 */

@end
