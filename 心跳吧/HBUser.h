//
//  HBUser.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/25.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HBUser : NSObject <NSCoding>
@property (nonatomic, assign)NSInteger level;//等级
@property (nonatomic, assign)NSInteger userID;//userId
@property (nonatomic, copy)NSString* personalizedSignature;//个性签名
@property (nonatomic, copy)NSString* phoneNumber;//手机号
@property (nonatomic, copy)NSString* nickName;//昵称
@property (nonatomic, copy)NSString* registerData;//注册日期
@property (nonatomic, copy)NSString* gender;//性别
@property (nonatomic, copy)NSString* avatar;//头像路径
@property (nonatomic, copy)NSString* heartBeatNumber;//心跳号


@property (nonatomic, strong)UIImage* headImage;//用户头像
@property (nonatomic, copy)NSString* apiKey;//apiKey
@property (nonatomic, copy)NSString* appToken;//appToken 主要用于融云

@end
