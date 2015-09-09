//
//  HBCheckGoodsImagesViewController.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/23.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBBaseViewController.h"

@interface HBCheckGoodsImagesViewController : HBBaseViewController
@property (nonatomic, strong)NSMutableArray* imageArray;//存放image
@property (nonatomic, strong)UIImage* selectedImage;//被选中的照片
@property (nonatomic, assign)NSInteger currentIndex;//当前照片的下标

@end
