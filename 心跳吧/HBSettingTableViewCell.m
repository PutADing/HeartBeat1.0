//
//  HBSettingTableViewCell.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/24.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBSettingTableViewCell.h"

@implementation HBSettingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [self createNameLabel];
        [self.contentView addSubview:self.nameLabel];
        
        self.jianTouIV = [self createJianTouImageView];
        [self.contentView addSubview:self.jianTouIV];
    }
    return self;
}

-(UILabel* )createNameLabel {
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 110, 20)];
    lab.textColor = COLOR_BLACK1;
    lab.font = FONT_17;
    return lab;
}

-(UIImageView* )createJianTouImageView {
    UIImageView* tempIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 16 - 10, 17, 16, 16)];
    tempIV.image = [UIImage imageNamed:@"jianTou.png"];
    return tempIV;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
