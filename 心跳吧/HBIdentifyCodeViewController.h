//
//  HBIdentifyCodeViewController.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/27.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//



//新用户注册时需要短信验证码时跳转到该类
#import "HBBaseViewController.h"

@interface HBIdentifyCodeViewController : HBBaseViewController
@property (nonatomic, copy)NSString* phoneNumberStr;//显示手机号
@property (nonatomic, copy)NSString* passwordStr;//密码
@property (nonatomic, strong)UILabel* phoneNumberLab;//显示手机号
@property (nonatomic, strong)UITextField* identifyCodeTF;//验证码
@property (nonatomic, strong)UIButton* getCodeBtn;//获取验证码 按钮
@property (nonatomic, strong)UILabel* timeLab;//剩余xx秒
@property (nonatomic, assign)int timeCount;//剩余时间
@property (nonatomic, strong)UIButton* nextBtn;//下一步 按钮

@property (nonatomic, copy)NSString* verifyCode;//验证码

@end
