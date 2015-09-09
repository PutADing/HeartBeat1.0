//
//  HBMyNumberViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/23.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBMyNumberViewController.h"
#import "HBTool.h"

@interface HBMyNumberViewController ()
@property (nonatomic, strong)UILabel* xinTiao;//用来显示心跳指数
@property (nonatomic, strong)UILabel* xinTiaoPaiMing;//用来显示心跳指数排名
@property (nonatomic, strong)UILabel* yingXiangLi;//用来显示影响力指数
@property (nonatomic, strong)UILabel* yingXiangLiPaiMing;//用来显示影响力指数排名
@property (nonatomic, strong)UILabel* meiLi;//用来显示魅力指数
@property (nonatomic, strong)UILabel* meiLiPaiMing;//用来显示魅力指数排名
@property (nonatomic, strong)UIButton* explainBtn;//"什么是指数?"按钮

@end

@implementation HBMyNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人指数";
    self.view.backgroundColor = BACKGROUNGCOLOR_GRAY1;
    self.xinTiao = [self createDisplayLabel];
    self.xinTiaoPaiMing = [self createDisplayLabel];
    self.yingXiangLi = [self createDisplayLabel];
    self.yingXiangLiPaiMing = [self createDisplayLabel];
    self.meiLi = [self createDisplayLabel];
    self.meiLiPaiMing = [self createDisplayLabel];
    [self createSubViews];
    
    [self getUserIndexFromService];
}

-(UILabel* )createDisplayLabel {
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 5 - 80, 0, 80, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = COLOR_BLACK1;
    label.font = FONT_17;
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

-(void)createSubViews {
    CGFloat space = 5;//图片距离上、下、左的距离
    CGFloat lineHeight = 50;//每一行的高度
//    CGFloat space1_line = 5;//行与行之间的距离1
    CGFloat space2_line = 20;//行与行之间的距离2
    NSArray* imageNamesArr = @[@"xinTiaoZhiShu_CaiSe.png",@"zhiShuLaBa.png",@"flower.png"];//图片名称数组
    NSArray* textArr = @[@"心跳指数",@"心跳指数排名",@"影响力指数",@"影响力指数排名",@"魅力指数",@"魅力指数排名"];//文字数组
    
    UIView* view0 = [self createCellViewWithX:0 AndY:NAVIGATIOINBARHEIGHT AndWidth:self.view.frame.size.width AndHeight:lineHeight];//第1行
    [view0 addSubview:self.xinTiao];
    [self.view addSubview:view0];
    UIView* view1 = [self createCellViewWithX:0 AndY:view0.frame.origin.y+view0.frame.size.height AndWidth:self.view.frame.size.width AndHeight:lineHeight];//第2行
    [view1 addSubview:self.xinTiaoPaiMing];
    [self.view addSubview:view1];
    
    self.explainBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 120, view1.frame.origin.y + view1.frame.size.height, 120, space2_line)];
    self.explainBtn.titleLabel.font = FONT_15;
    [self.explainBtn setTitle:@"什么是心跳指数？" forState:UIControlStateNormal];
    [self.explainBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.explainBtn addTarget:self action:@selector(clickedExplainButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.explainBtn];
    
    UIView* view2 = [self createCellViewWithX:0 AndY:view1.frame.origin.y+view1.frame.size.height+space2_line AndWidth:self.view.frame.size.width AndHeight:lineHeight];//第3行
    [view2 addSubview:self.yingXiangLi];
    [self.view addSubview:view2];
    UIView* view3 = [self createCellViewWithX:0 AndY:view2.frame.origin.y+view2.frame.size.height AndWidth:self.view.frame.size.width AndHeight:lineHeight];//第4行
    [view3 addSubview:self.yingXiangLiPaiMing];
    [self.view addSubview:view3];
    UIView* view4 = [self createCellViewWithX:0 AndY:view3.frame.origin.y+view3.frame.size.height+space2_line AndWidth:self.view.frame.size.width AndHeight:lineHeight];//第5行
    [view4 addSubview:self.meiLi];
    [self.view addSubview:view4];
    UIView* view5 = [self createCellViewWithX:0 AndY:view4.frame.origin.y+view4.frame.size.height AndWidth:self.view.frame.size.width AndHeight:lineHeight];//第6行
    [view5 addSubview:self.meiLiPaiMing];
    [self.view addSubview:view5];
    NSArray* viewArr = @[view0, view1, view2, view3, view4, view5];
    
    for (int i = 0; i < 6; i++) {
        UIView* tempView = viewArr[i];
        if (i%2 == 0) {
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(space, space, lineHeight - space*2, lineHeight - space*2)];
            imageView.image = [UIImage imageNamed:imageNamesArr[i/2]];
            [tempView addSubview:imageView];
            
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(lineHeight, (lineHeight - 20)/2, 150, 20)];
            label.text = textArr[i];
            label.textColor = COLOR_BLACK1;
            label.font = FONT_17;
            [tempView addSubview:label];
            
            UIImageView* lineIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, tempView.frame.size.height - 1, tempView.frame.size.width, 1)];
            lineIV.image = [UIImage imageNamed:@"line.png"];
            [tempView addSubview:lineIV];
        }else {
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(space*2, (lineHeight - 20)/2, 150, 20)];
            label.text = textArr[i];
            label.textColor = COLOR_BLACK1;
            label.font = FONT_17;
            [tempView addSubview:label];
        }
        
    }
}

-(UIView* )createCellViewWithX:(CGFloat )origin_x AndY:(CGFloat )origin_y AndWidth:(CGFloat )frame_width AndHeight:(CGFloat )frame_height {
    UIView* cellView = [[UIView alloc]initWithFrame:CGRectMake(origin_x, origin_y, frame_width, frame_height)];
    cellView.backgroundColor = COLOR_WHITE1;
    return cellView;
}

-(void)clickedExplainButton:(UIButton* )sender {
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"什么是心跳指数" message:@"心跳指数是影响力指数和魅力指数的和，作为获取他人共享物品的依据，取决于实际共享的物品数量和喜欢想要的人数。" delegate:nil cancelButtonTitle:@"明白了" otherButtonTitles:nil];
    [av show];
}

-(void)getUserIndexFromService {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/user/getUserIndex.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"myId=%ld&userId=%ld&apiKey=%@", USERID, self.user.userID, APIKEY];
    
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"result_String:%@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]intValue] == 1) {
                NSDictionary* userDic = jsonDic[@"userEvaluateIndex"];
                self.xinTiao.text = [NSString stringWithFormat:@"%@", userDic[@"comprehensiveIndex"]];
                self.xinTiaoPaiMing.text = [NSString stringWithFormat:@"%@", userDic[@"comprehensiveIndex_rank"]];
                self.yingXiangLi.text = [NSString stringWithFormat:@"%@", userDic[@"influenceIndex"]];
                self.yingXiangLiPaiMing.text = [NSString stringWithFormat:@"%@", userDic[@"influenceIndex_rank"]];
                self.meiLi.text = [NSString stringWithFormat:@"%@", userDic[@"charmIndex"]];
                self.meiLiPaiMing.text = [NSString stringWithFormat:@"%@", userDic[@"charmIndex_rank"]];
            }
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
