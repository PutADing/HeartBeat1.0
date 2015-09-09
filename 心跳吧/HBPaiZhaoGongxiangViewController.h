//
//  HBPaiZhaoGongxiangViewController.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/25.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBBaseViewController.h"

@interface HBPaiZhaoGongxiangViewController : HBBaseViewController
@property (nonatomic, strong)UILabel* classLab;//分类
@property (nonatomic, strong)UILabel* placeLab;//所在地区
@property (nonatomic, strong)UILabel* sendTimeLab;//送出时间

//反向传值
@property (nonatomic, assign)NSInteger classId;//物品二级分类id
@property (nonatomic, assign)NSInteger provinceId;//所在省份id
@property (nonatomic, assign)NSInteger cityId;//所在城市id
@property (nonatomic, assign)NSInteger districtId;//所在区县id
@property (nonatomic, assign)NSInteger sendTimeId;//送出时间id

@property (nonatomic, strong)NSMutableArray* imageArr;//存放照片


@end
