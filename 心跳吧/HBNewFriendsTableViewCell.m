//
//  HBNewFriendsTableViewCell.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/5.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBNewFriendsTableViewCell.h"

@implementation HBNewFriendsTableViewCell

//头像距离左 间距
#define SPACE_X 10
//头像宽高
#define WIDTH_HEADIV 40
//descriptionLab的高
#define HEIGHT_LABEL 20
//statusLab宽高
#define WIDTH_STATUSLABEL 70
#define HEIGHT_STATUSLABEL 40

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createSubViews];
        
    }
    return self;
}

-(void)createSubViews {
    self.headIV = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_X, 5, WIDTH_HEADIV, WIDTH_HEADIV)];
    self.headIV.layer.cornerRadius = self.headIV.frame.size.width/2;
    self.headIV.layer.masksToBounds = YES;
    [self.contentView addSubview:self.headIV];
    
    self.statusLab = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - WIDTH_STATUSLABEL, 5, WIDTH_STATUSLABEL, HEIGHT_STATUSLABEL)];
    self.statusLab.backgroundColor = COLOR_BLUE1;
    self.statusLab.textColor = COLOR_WHITE1;
    self.statusLab.font = FONT_17;
    self.statusLab.textAlignment = NSTextAlignmentCenter;
    self.statusLab.layer.cornerRadius = 3;
    self.statusLab.layer.masksToBounds = YES;
    [self.contentView addSubview:self.statusLab];
    
    self.descriptionLab = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_X*2 + WIDTH_HEADIV, 15, self.frame.size.width - SPACE_X*2 - WIDTH_HEADIV - WIDTH_STATUSLABEL, HEIGHT_LABEL)];
    self.descriptionLab.font = FONT_17;
    [self.contentView addSubview:self.descriptionLab];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
