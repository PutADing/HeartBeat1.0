//
//  HBContactsTableViewCell.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/30.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBContactsTableViewCell.h"

@implementation HBContactsTableViewCell

#define LINE_HEIGHT 50
//头像宽高
#define WIDTH_HEADIV 40
//头像距离左、右间距
#define SPACE_LEFT_HEADIV 10
//头像距离上、下间距
#define SPACE_UP_HEADIV 5

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createHeadImageViewAndNameLabel];
        
    }
    return self;
}

-(void)createHeadImageViewAndNameLabel {
    self.headIV = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_LEFT_HEADIV, SPACE_UP_HEADIV, WIDTH_HEADIV, WIDTH_HEADIV)];
    self.headIV.layer.cornerRadius = WIDTH_HEADIV/2;
    self.headIV.layer.masksToBounds = YES;
    [self.contentView addSubview:self.headIV];
    
    self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH_HEADIV + SPACE_LEFT_HEADIV*2, (LINE_HEIGHT - 20)/2, self.bounds.size.width - WIDTH_HEADIV - SPACE_LEFT_HEADIV*2, 20)];
    self.nameLab.textColor = COLOR_BLACK1;
    self.nameLab.font = FONT_17;
    [self.contentView addSubview:self.nameLab];
    
    self.redDot = [[CALayer alloc]init];
    self.redDot.frame = CGRectMake(self.nameLab.frame.origin.x + 70, self.nameLab.frame.origin.y, 8, 8);
    self.redDot.cornerRadius = self.redDot.frame.size.width/2;
    self.redDot.masksToBounds = YES;
    [self.redDot setBackgroundColor:COLOR_RED1.CGColor];
    [self.contentView.layer addSublayer:self.redDot];
    self.redDot.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
