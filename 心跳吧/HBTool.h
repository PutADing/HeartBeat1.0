//
//  HBTool.h
//  HBDemoVersion
//
//  Created by okwei on 14-11-4.
//  Copyright (c) 2014年 heartbeat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HBReachability.h"

//声明block
typedef void (^CallBack)(id obj);
//typedef void (^CallBack)(NSURLResponse* response, NSData* data, NSError* error);

@interface HBTool : NSObject

@property (nonatomic, getter=getHBReachability)HBReachability* reach;


+(instancetype)shareTool;

-(BOOL)isIOS7_Later;

-(BOOL)isIOS8_Later;

//将当前时间转换成时间戳
-(NSString* )currentTimeStamp;

//将时间戳转换成当前时间
-(NSString* )currentTimeWithTimeStamp:(NSTimeInterval )timeStamp;

//将异步请求封装成block
-(void)postURLConnectionWithURL:(NSString* )urlStr andArgument:(NSString* )argumentStr AndBlock:(void (^)(NSURLResponse* response, NSData* data, NSError* error)) block;
-(void)postURLSessionWithURL:(NSString* )urlStr andArgument:(NSString* )argumentStr AndCallBack:(CallBack) callback;

-(void)postWithURL:(NSString* )urlStr andArgument:(NSString* )argumentStr AndBlock:(void (^)(NSDictionary* jsonDic)) block;

-(HBReachability* )getHBReachability;//HBReachability的getter方法

//将数据保存在沙盒中
-(void)saveArray:(NSArray *)array AndKey:(NSString *)keyName AndFileName:(NSString *)fileName;

//将数据从沙盒中取出
-(NSArray* )getArrayWithKeyName:(NSString *)keyName AndFileName:(NSString *)fileName;
@end
