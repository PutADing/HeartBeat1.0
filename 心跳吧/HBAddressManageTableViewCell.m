//
//  HBAddressManageTableViewCell.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/28.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBAddressManageTableViewCell.h"

@implementation HBAddressManageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubView];
        
    }
    return self;
}

-(void)initSubView {
    self.addressLab = [[UILabel alloc]initWithFrame:CGRectMake(10, (self.frame.size.height - 20)/2, self.frame.size.width - 20, 20)];
    self.addressLab.font = FONT_17;
    self.addressLab.textColor = COLOR_BLACK1;
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
