//
//  HBCategorySelectViewController.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/27.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBBaseViewController.h"

typedef void (^CallBack_Category) (NSString* firstCateName, NSInteger firstCateId, NSString* secondCateName, NSInteger secondCateId);

@interface HBCategorySelectViewController : HBBaseViewController

@property (nonatomic, copy)CallBack_Category callback;

-(void)returnCategoryCallBack:(CallBack_Category )block;

@end
