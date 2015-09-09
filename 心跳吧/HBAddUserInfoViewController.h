//
//  HBAddUserInfoViewController.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/27.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//



//新用户注册添加用户信息时跳转到该类
#import "HBBaseViewController.h"
#import "HBNavigationController.h"
#import "HBShareViewController.h"
#import "HBTool.h"
#import "ALBBOSSServiceProtocol.h"
#import "ALBBOSSServiceProvider.h"
#import "OSSBucket.h"
#import "OSSData.h"
#import "HBPersonalSignViewController.h"
#import "HBPlaceSelectViewController.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "HBChangeNickNameViewController.h"
#import "HBChangeHBNumberViewController.h"

@interface HBAddUserInfoViewController : HBBaseViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, VPImageCropperDelegate>

@property (nonatomic, strong)UIView* infoView;//头像 昵称 心跳号... 视图
@property (nonatomic, strong)UIView* buttonView;//确认保存 按钮 视图
@property (nonatomic, strong)UIImageView* headIV;//头像 按钮
@property (nonatomic, strong)UILabel* nickLab;//昵称
@property (nonatomic, strong)UILabel* xinTiaoLab;//心跳号
@property (nonatomic, strong)UILabel* sexLab;//性别
@property (nonatomic, strong)UILabel* placeLab;//地区
@property (nonatomic, strong)UILabel* personalSignLab;//个性签名

@end
