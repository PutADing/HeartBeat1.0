//
//  HBNewFriendsTableViewCell.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/5.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBUser.h"

@interface HBNewFriendsTableViewCell : UITableViewCell
@property (nonatomic, strong)UIImageView* headIV;
@property (nonatomic, strong)UILabel* descriptionLab;//显示验证消息
@property (nonatomic, strong)UILabel* statusLab;//好友请求状态
//2:成功 1:失败 -1:等待对方(secUser)验证

@end
