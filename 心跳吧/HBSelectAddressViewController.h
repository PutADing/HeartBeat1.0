//
//  HBSelectAddressViewController.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/30.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBBaseViewController.h"

typedef void (^CallBack_SelectedAddress) (NSString* provinceName, NSInteger provinceId, NSString* cityName, NSInteger cityId, NSString* districtName, NSInteger districtId, NSString* nameString, NSString* phoneNumberStr, NSString* detailString);

@interface HBSelectAddressViewController : HBBaseViewController

@property (nonatomic, copy)CallBack_SelectedAddress callback;

-(void)returnSelectedAddress:(CallBack_SelectedAddress)block;

@end
