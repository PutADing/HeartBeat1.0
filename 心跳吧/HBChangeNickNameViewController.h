//
//  HBChangeNickNameViewController.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/26.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBBaseViewController.h"

typedef void (^ReturnTextBlock)(NSString* showText);

@interface HBChangeNickNameViewController : HBBaseViewController
@property (nonatomic, strong)UITextView* nickNameTV;
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;

@end
