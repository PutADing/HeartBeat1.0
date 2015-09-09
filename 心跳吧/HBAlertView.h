//
//  HBAlertView.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/20.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBUser.h"

@interface HBAlertView : UIAlertView

@property (nonatomic, strong)HBUser* user;
@property (nonatomic, strong)NSIndexPath* indexPath;

@end
