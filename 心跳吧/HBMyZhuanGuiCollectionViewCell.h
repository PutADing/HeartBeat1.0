//
//  HBMyZhuanGuiCollectionViewCell.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/30.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBMyZhuanGuiCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView* goodsIV;//物品图片
@property (nonatomic, strong)UILabel* nameLab;//物品名称
@property (nonatomic, strong)UIImageView* likeIV;//喜欢
@property (nonatomic, strong)UIImageView* wantIV;//想要
@property (nonatomic, strong)UILabel* likeNumLab;//显示 喜欢 数量
@property (nonatomic, strong)UILabel* wantNumLab;//显示 想要 数量

@end
