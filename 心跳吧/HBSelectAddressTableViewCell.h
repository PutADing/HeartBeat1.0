//
//  HBSelectAddressTableViewCell.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/30.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBSelectAddressTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel* addressLab;

@property (nonatomic, copy)NSString* nameString;
@property (nonatomic, copy)NSString* phoneNumberStr;
@property (nonatomic, copy)NSString* detailString;
@property (nonatomic, copy)NSString* provinceName;
@property (nonatomic, copy)NSString* cityName;
@property (nonatomic, copy)NSString* districtName;
@property (nonatomic, assign)NSInteger provinceId;
@property (nonatomic, assign)NSInteger cityId;
@property (nonatomic, assign)NSInteger districtId;

@property (nonatomic, assign)NSInteger addressId;

@end
