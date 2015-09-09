//
//  HBModifyAddressViewController.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/30.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBBaseViewController.h"

@interface HBModifyAddressViewController : HBBaseViewController
@property (nonatomic, strong)UITextField* nameTF;//姓名
@property (nonatomic, strong)UITextField* phoneNumberTF;//手机号
@property (nonatomic, strong)UILabel* placeLab;//省/市/区、县
@property (nonatomic, strong)UITextField* detailTF;//详细地址

@property (nonatomic, assign)NSInteger provinceId;//
@property (nonatomic, assign)NSInteger cityId;//
@property (nonatomic, assign)NSInteger districtId;//
@property (nonatomic, copy)NSString* provinceName;//
@property (nonatomic, copy)NSString* cityName;//
@property (nonatomic, copy)NSString* districtName;//

@property (nonatomic, copy)NSString* nameString;
@property (nonatomic, copy)NSString* phoneNumberStr;
@property (nonatomic, copy)NSString* detailString;

@property (nonatomic, assign)NSInteger addressId;//地址id

@end
