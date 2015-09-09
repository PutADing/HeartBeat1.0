//
//  HBSelectInfoTableViewCell.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/7.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBSelectInfoTableViewCell.h"

@implementation HBSelectInfoTableViewCell

//行高
#define LINE_HEIGHT 40
//label距离左 间距
#define SPACE_X_LABEL 10
//label的高
#define HEIGHT_LABEL 20

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_X_LABEL, (LINE_HEIGHT - HEIGHT_LABEL)/2, self.frame.size.width, HEIGHT_LABEL)];
        [self.contentView addSubview:self.label];        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
