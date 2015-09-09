//
//  HBOrderListTableViewCell.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/17.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBOrderListTableViewCell.h"

@implementation HBOrderListTableViewCell

//照片距离 左 间距
#define SPACE_GOODSIV 5
//照片宽高
#define WIDTH_GOODSIV 40
//行高
#define LINE_HEIGHT self.frame.size.height
//label的高
#define HEIGHT_LABEL 20
//箭头宽高
#define WIDTH_JIANTOUIV 16

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = COLOR_WHITE1;
        [self initSubView];
        
    }
    return self;
}

-(void)initSubView {
    self.goodsIV = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_GOODSIV, (LINE_HEIGHT - WIDTH_GOODSIV)/2, WIDTH_GOODSIV, WIDTH_GOODSIV)];
    self.goodsIV.layer.cornerRadius = 3;
    self.goodsIV.layer.masksToBounds = YES;
    [self.contentView addSubview:self.goodsIV];
    
    UIImageView* jianTouIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - WIDTH_JIANTOUIV, (LINE_HEIGHT - WIDTH_JIANTOUIV)/2, WIDTH_JIANTOUIV, WIDTH_JIANTOUIV)];
    jianTouIV.image = [UIImage imageNamed:@"jianTou.png"];
    [self.contentView addSubview:jianTouIV];
    
    self.nameLab = [self createLabelWithRect:CGRectMake(SPACE_GOODSIV*2 + WIDTH_GOODSIV, (LINE_HEIGHT - HEIGHT_LABEL*2)/2, self.frame.size.width - SPACE_GOODSIV*2 - WIDTH_GOODSIV - WIDTH_JIANTOUIV, HEIGHT_LABEL)];
    [self.contentView addSubview:self.nameLab];
    
    self.detailLab = [self createLabelWithRect:CGRectMake(self.nameLab.frame.origin.x, self.nameLab.frame.origin.y + self.nameLab.frame.size.height, self.nameLab.frame.size.width, HEIGHT_LABEL)];
    [self.contentView addSubview:self.detailLab];
}

-(UILabel* )createLabelWithRect:(CGRect )rect {
    UILabel* lab = [[UILabel alloc]initWithFrame:rect];
    lab.textColor = COLOR_BLACK1;
    lab.font = FONT_17;
    return lab;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
