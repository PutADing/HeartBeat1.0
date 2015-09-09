//
//  HBContactsTableViewCell.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/30.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBContactsTableViewCell : UITableViewCell
@property (nonatomic, strong)UIImageView* headIV;//头像
@property (nonatomic, strong)UILabel* nameLab;//名字

@property (nonatomic, strong)CALayer* redDot;//新的朋友 右上角的红点

@end
