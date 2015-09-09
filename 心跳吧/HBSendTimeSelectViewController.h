//
//  HBSendTimeSelectViewController.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/7.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBBaseViewController.h"

typedef void (^CallBack_SendTime) (NSString* timeStr, NSInteger timeId);

@interface HBSendTimeSelectViewController : HBBaseViewController

@property (nonatomic, copy)CallBack_SendTime callback;

-(void)returnSendTimeCallBack:(CallBack_SendTime )block;

@end
