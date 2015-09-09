//
//  HBCheckDetailImageViewController.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/7.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBBaseViewController.h"
#import "HBPaiZhaoGongxiangViewController.h"

@interface HBCheckDetailImageViewController : HBBaseViewController
@property (nonatomic, strong)NSMutableArray* imageArray;
@property (nonatomic, strong)UIImage* selectedImage;
@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, strong)HBPaiZhaoGongxiangViewController* HBPZGXVC;

@end
