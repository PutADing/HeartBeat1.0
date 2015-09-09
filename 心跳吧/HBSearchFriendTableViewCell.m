//
//  HBSearchFriendTableViewCell.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/14.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBSearchFriendTableViewCell.h"

@implementation HBSearchFriendTableViewCell

//头像距离左 间距
#define SPACE_X 10
//头像宽高
#define WIDTH_HEADIV 40
//nickLab的高
#define HEIGHT_LABEL 20

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createSubViews];
        
    }
    return self;
}

-(void)createSubViews {
    self.headIV = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_X, (self.frame.size.height - WIDTH_HEADIV)/2, WIDTH_HEADIV, WIDTH_HEADIV)];
    self.headIV.layer.cornerRadius = self.headIV.frame.size.width/2;
    self.headIV.layer.masksToBounds = YES;
    [self.contentView addSubview:self.headIV];
    self.nickLab = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_X*2 + self.headIV.frame.size.width, (self.frame.size.height - HEIGHT_LABEL)/2, self.frame.size.width - SPACE_X*3 - self.headIV.frame.size.width, HEIGHT_LABEL)];
    self.nickLab.font = FONT_17;
    [self.contentView addSubview:self.nickLab];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
