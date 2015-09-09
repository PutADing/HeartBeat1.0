//
//  HBPayViewController.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/7.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBBaseViewController.h"
#import <WXApi.h>

@interface HBPayViewController : HBBaseViewController <WXApiDelegate>
@property (nonatomic, strong)UILabel* priceLab;//显示快递运费
@property (nonatomic, copy)NSString* orderId;//orderId参数
@property (nonatomic, copy)NSString* goodsName;//goodsName参数
@property (nonatomic, copy)NSString* goodsDescription;//goodsDescription参数
@property (nonatomic, assign)double postageValue;//postageValue参数

+(instancetype)sharePayViewController;
-(void)didSuccessfullyPay;
-(void)didFailPay;

@end
