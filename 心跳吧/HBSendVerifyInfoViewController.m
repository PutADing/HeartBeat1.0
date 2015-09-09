//
//  HBSendVerifyInfoViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/10.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBSendVerifyInfoViewController.h"
#import "GCPlaceholderTextView.h"
#import "HBTool.h"

@interface HBSendVerifyInfoViewController ()
@property (nonatomic, strong)UIImageView* headIV;//
@property (nonatomic, strong)UILabel* nickLab;//
@property (nonatomic, strong)UILabel* heartbeatLab;//
@property (nonatomic, strong)GCPlaceholderTextView* verifyTV;//

@end

@implementation HBSendVerifyInfoViewController

//行高
#define LINE_HEIGHT 50
//头像距离 左 间距
#define SPACE_LABEL 10
//头像宽高
#define WIDTH_HEADIV 40
//发送 按钮宽高
#define WIDTH_BUTTON self.view.frame.size.width/2
#define HEIGHT_BUTTON 35

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证信息";
    self.view.backgroundColor = BACKGROUNGCOLOR_GRAY1;
    
    [self initSubviewsWithY:NAVIGATIOINBARHEIGHT];
    
}

-(void)initSubviewsWithY:(CGFloat )origin_y {
    UIView* cellView0 = [self createCellView0WithRect:CGRectMake(0, origin_y, self.view.frame.size.width, LINE_HEIGHT)];
    cellView0.backgroundColor = COLOR_WHITE1;
    [self.view addSubview:cellView0];
    
    UIView* cellView1 = [self createCellView1WithRect:CGRectMake(0, cellView0.frame.origin.y + cellView0.frame.size.height + 5, self.view.frame.size.width, LINE_HEIGHT)];
    cellView1.backgroundColor = COLOR_WHITE1;
    [self.view addSubview:cellView1];
    
    UIButton* sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH_BUTTON/2, cellView1.frame.origin.y + cellView1.frame.size.height + 15, WIDTH_BUTTON, HEIGHT_BUTTON)];
    sendBtn.backgroundColor = COLOR_BLUE1;
    sendBtn.titleLabel.font = FONT_20;
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.layer.cornerRadius = 4;
    sendBtn.layer.masksToBounds = YES;
    [sendBtn addTarget:self action:@selector(clickedSendButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
}

//创建单元行0
-(UIView* )createCellView0WithRect:(CGRect )rect {
    UIView* cellView0 = [[UIView alloc]initWithFrame:rect];
    
    self.headIV = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_LABEL, (LINE_HEIGHT - WIDTH_HEADIV)/2, WIDTH_HEADIV, WIDTH_HEADIV)];
    [cellView0 addSubview:self.headIV];
    self.headIV.image = self.headImage;
    self.headIV.layer.cornerRadius = WIDTH_HEADIV/2;
    self.headIV.layer.masksToBounds = YES;
    
    self.nickLab = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_LABEL*2 + WIDTH_HEADIV, self.headIV.frame.origin.y, self.view.frame.size.width - SPACE_LABEL*2 - WIDTH_HEADIV, WIDTH_HEADIV/2)];
    self.nickLab.text = self.user.nickName;
    self.nickLab.textColor = COLOR_BLACK1;
    self.nickLab.font = FONT_17;
    [cellView0 addSubview:self.nickLab];
    
    self.heartbeatLab = [[UILabel alloc]initWithFrame:CGRectMake(self.nickLab.frame.origin.x, self.nickLab.frame.origin.y + self.nickLab.frame.size.height, self.nickLab.frame.size.width, self.nickLab.frame.size.height)];
    self.heartbeatLab.text = self.user.heartBeatNumber;
    self.heartbeatLab.textColor = COLOR_GRAY1;
    self.heartbeatLab.font = FONT_15;
    [cellView0 addSubview:self.heartbeatLab];
    
    return cellView0;
}

//创建单元行1
-(UIView* )createCellView1WithRect:(CGRect )rect {
    UIView* cellView1 = [[UIView alloc]initWithFrame:rect];
    self.verifyTV = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(SPACE_LABEL, 0, self.view.frame.size.width - SPACE_LABEL*2, LINE_HEIGHT)];
    self.verifyTV.placeholder = @"我是...";
    self.verifyTV.font = FONT_17;
    [cellView1 addSubview:self.verifyTV];
    return cellView1;
}

//返回verifyTextView验证信息
-(NSString* )returnVerifyTextViewText {
    if ([self.verifyTV.text isEqualToString:@"我是..."]) {
        return nil;
    }else {
        return self.verifyTV.text;
    }
}

//点击 发送 按钮
-(void)clickedSendButton:(UIButton* )sender {
    NSString* descriptionStr = [self returnVerifyTextViewText];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/friends/sendVerificationInfo.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"reqId=%ld&description=%@&myId=%ld&apiKey=%@", self.user.userID, descriptionStr, USERID, APIKEY];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"resultStr=%@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"提交成功，等待对方验证" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [av show];
                
            }else if ([jsonDic[@"status"]integerValue] == -1) {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您已经申请过添加TA为好友了" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [av show];
            }
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
