//
//  HBSelectAddressTableViewCell.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/30.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBSelectAddressTableViewCell.h"

@implementation HBSelectAddressTableViewCell

#define SPACE_LABEL 10

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubviews];
        
    }
    return self;
}

-(void)initSubviews {
    self.addressLab = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_LABEL, 15, self.frame.size.width - SPACE_LABEL*2, 20)];
    self.addressLab.font = FONT_17;
    [self.contentView addSubview:self.addressLab];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
