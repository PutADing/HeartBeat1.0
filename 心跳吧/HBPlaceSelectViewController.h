//
//  HBPlaceSelectViewController.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/27.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBBaseViewController.h"

typedef void (^CallBack_Place) (NSString* proviceName, NSInteger proviceId, NSString* cityName, NSInteger cityId, NSString* districtName, NSInteger districtId);

@interface HBPlaceSelectViewController : HBBaseViewController
@property (nonatomic, copy)CallBack_Place callback;

-(void)returnPlaceCallBack:(CallBack_Place )block;

@end
