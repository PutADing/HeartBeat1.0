//
//  HBMyZhuanGuiCollectionViewCell.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/30.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBMyZhuanGuiCollectionViewCell.h"

@implementation HBMyZhuanGuiCollectionViewCell

//图片距离左 右 上 间距
#define SPACE_X_GOODSIV 0
//喜欢 想要 按钮 高
#define HEIGHT_BUTTOM 20

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_WHITE1;
        
        self.goodsIV = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_X_GOODSIV, SPACE_X_GOODSIV, frame.size.width - SPACE_X_GOODSIV*2, frame.size.width - SPACE_X_GOODSIV*2)];
        [self.contentView addSubview:self.goodsIV];
        
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0,self.goodsIV.frame.origin.y + self.goodsIV.frame.size.height, frame.size.width, 20)];
        self.nameLab.textAlignment = NSTextAlignmentCenter;
        self.nameLab.textColor = COLOR_BLACK1;
        self.nameLab.font = FONT_17;
        [self.contentView addSubview:self.nameLab];
        
        self.likeIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height - HEIGHT_BUTTOM, HEIGHT_BUTTOM, HEIGHT_BUTTOM)];
        [self.likeIV setImage:[UIImage imageNamed:@"like.png"]];
        [self.contentView addSubview:self.likeIV];
        
        self.likeNumLab = [[UILabel alloc]initWithFrame:CGRectMake(HEIGHT_BUTTOM, self.likeIV.frame.origin.y, frame.size.width/2 - HEIGHT_BUTTOM, HEIGHT_BUTTOM)];
        self.likeNumLab.textAlignment = NSTextAlignmentLeft;
        self.likeNumLab.textColor = COLOR_BLACK1;
        self.likeNumLab.font = FONT_15;
        [self.contentView addSubview:self.likeNumLab];
        
        self.wantIV = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2, self.likeIV.frame.origin.y, HEIGHT_BUTTOM, HEIGHT_BUTTOM)];
        [self.wantIV setImage:[UIImage imageNamed:@"want.png"]];
        [self.contentView addSubview:self.wantIV];
        
        self.wantNumLab = [[UILabel alloc]initWithFrame:CGRectMake(self.wantIV.frame.origin.x + self.wantIV.frame.size.width, self.likeIV.frame.origin.y, frame.size.width/2 - HEIGHT_BUTTOM, HEIGHT_BUTTOM)];
        self.wantNumLab.textAlignment = NSTextAlignmentLeft;
        self.wantNumLab.textColor = COLOR_BLACK1;
        self.wantNumLab.font = FONT_15;
        [self.contentView addSubview:self.wantNumLab];
        
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end
