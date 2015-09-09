//
//  HBWoSongNiShouTableViewCell.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/24.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBWoSongNiShouTableViewCell.h"

@implementation HBWoSongNiShouTableViewCell

CGFloat space_x = 10;//图片距离左、上、下的距离
CGFloat space_y = 5;//图片距离上、下的距离
CGFloat imageViewHeight = 40;//图片大小 40*40

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubviews];
        
    }
    return self;
}

-(void)initSubviews {
    self.productIV = [[UIImageView alloc]initWithFrame:CGRectMake(space_x, space_y, imageViewHeight, imageViewHeight)];
    [self.contentView addSubview:self.productIV];
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(imageViewHeight + space_x*2, space_y, self.frame.size.width - imageViewHeight - space_x*2 - 16, 20)];
    self.titleLab.textColor = COLOR_BLACK1;
    self.titleLab.font = FONT_17;
    [self.contentView addSubview:self.titleLab];
    self.descriptionLab = [[UILabel alloc]initWithFrame:CGRectMake(imageViewHeight + space_x*2, space_y + 20, self.frame.size.width - imageViewHeight - space_x*2 - 16, 20)];
    self.descriptionLab.textColor = COLOR_GRAY1;
    self.descriptionLab.font = FONT_15;
    [self.contentView addSubview:self.descriptionLab];
    
    UIImageView* jianTouIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 16, (50 - 16)/2, 16, 16)];
    jianTouIV.image = [UIImage imageNamed:@"jianTou.png"];
    [self.contentView addSubview:jianTouIV];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
