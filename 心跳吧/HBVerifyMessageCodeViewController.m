//
//  HBVerifyMessageCodeViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/17.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBVerifyMessageCodeViewController.h"
#import "HBLoginViewController.h"

@interface HBVerifyMessageCodeViewController ()

@end

@implementation HBVerifyMessageCodeViewController

//行高
#define LINE_HEIGHT 50
//线距离左的间距
#define SPACE_X_LINE 5
//label距离左的间距
#define SPACE_X_LABEL 10
//textField的高
#define HEIGHT_TEXTFIELD 30
//获取验证码 按钮的宽高
#define WIDTH_GETCODEBUTTON 100
#define HEIGHT_GETCODEBUTTON 30
//下一步 按钮的宽高
#define WIDTH_NEXTBUTTON (self.view.frame.size.width/2)
#define HEIGHT_NEXTBUTTON 35
//剩余xx秒 label的宽高
#define WIDTH_TIMELABEL 70
#define HEIGHT_TIMELABEL 20

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写验证码";
    self.view.backgroundColor = COLOR_WHITE1;
    
    UIView* cellView1 = [self createCellViewWithX:0 AndY:NAVIGATIOINBARHEIGHT AndWidth:self.view.frame.size.width AndHeight:LINE_HEIGHT];
    [self.view addSubview:cellView1];
    UILabel* shouJiLab = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_X_LABEL, (LINE_HEIGHT - 20)/2, 55, 20)];
    shouJiLab.text = @"手机号";
    shouJiLab.textColor = COLOR_BLACK1;
    shouJiLab.font = FONT_17;
    [cellView1 addSubview:shouJiLab];
    
    self.phoneNumberLab = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_X_LABEL*2 + shouJiLab.frame.size.width, shouJiLab.frame.origin.y, cellView1.frame.size.width - shouJiLab.frame.size.width - SPACE_X_LABEL*4 - WIDTH_GETCODEBUTTON, shouJiLab.frame.size.height)];
    self.phoneNumberLab.text = self.phoneNumberStr;
    self.phoneNumberLab.textColor = COLOR_BLACK1;
    self.phoneNumberLab.font = FONT_17;
    [cellView1 addSubview:self.phoneNumberLab];
    
    UIView* cellView2 = [self createCellViewWithX:0 AndY:NAVIGATIOINBARHEIGHT + LINE_HEIGHT AndWidth:self.view.frame.size.width AndHeight:LINE_HEIGHT];
    [self.view addSubview:cellView2];
    UIImageView* lineIV = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_X_LINE, LINE_HEIGHT - 10, cellView2.frame.size.width - SPACE_X_LINE*2, 10)];
    lineIV.image = [UIImage imageNamed:@"blueLine.png"];
    [cellView2 addSubview:lineIV];
    
    self.identifyCodeTF = [[UITextField alloc]initWithFrame:CGRectMake(SPACE_X_LABEL, (LINE_HEIGHT - HEIGHT_TEXTFIELD)/2, cellView2.frame.size.width - SPACE_X_LABEL*3 - WIDTH_GETCODEBUTTON, HEIGHT_GETCODEBUTTON)];
    self.identifyCodeTF.placeholder = @"输入验证码";
    self.identifyCodeTF.textColor = COLOR_BLACK1;
    self.identifyCodeTF.font = FONT_17;
    self.identifyCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    [cellView2 addSubview:self.identifyCodeTF];
    
    self.getCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SPACE_X_LABEL*2 + self.identifyCodeTF.frame.size.width, (LINE_HEIGHT - HEIGHT_GETCODEBUTTON)/2, WIDTH_GETCODEBUTTON, HEIGHT_GETCODEBUTTON)];
    self.getCodeBtn.titleLabel.font = FONT_17;
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.getCodeBtn.backgroundColor = COLOR_BLUE1;
    [self.getCodeBtn addTarget:self action:@selector(clickedGetCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    self.getCodeBtn.layer.cornerRadius = 3;
    self.getCodeBtn.layer.masksToBounds = YES;
    [cellView2 addSubview:self.getCodeBtn];
    
    self.nextBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - WIDTH_NEXTBUTTON)/2, cellView2.frame.origin.y + cellView2.frame.size.height + 30, WIDTH_NEXTBUTTON, HEIGHT_NEXTBUTTON)];
    self.nextBtn.backgroundColor = COLOR_BLUE1;
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    self.nextBtn.titleLabel.font = FONT_20;
    self.nextBtn.layer.cornerRadius = 4;
    self.nextBtn.layer.masksToBounds = YES;
    [self.nextBtn addTarget:self action:@selector(clickedNextButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
}

-(UIView* )createCellViewWithX:(CGFloat )origin_x AndY:(CGFloat )origin_y AndWidth:(CGFloat )frame_width AndHeight:(CGFloat )frame_height {
    UIView* vi = [[UIView alloc]initWithFrame:CGRectMake(origin_x, origin_y, frame_width, frame_height)];
    return vi;
}

-(void)clickedGetCodeButton:(UIButton* )sender {
    self.getCodeBtn.enabled = NO;
    self.getCodeBtn.backgroundColor = COLOR_GRAY1;
    UIView* cellView2 = self.getCodeBtn.superview;
    self.timeLab = [self createTimeLabelWithX:self.view.frame.size.width - SPACE_X_LABEL - WIDTH_TIMELABEL AndY:cellView2.frame.origin.y + cellView2.frame.size.height AndWidth:WIDTH_TIMELABEL AndHeight:HEIGHT_TIMELABEL];
    [self.view addSubview:self.timeLab];
    self.timeCount = 60;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTimeLabelValueWithNumber:) userInfo:nil repeats:YES];
    
    [self getIdentifyCodeFromService];
}

-(UILabel* )createTimeLabelWithX:(CGFloat )origin_x AndY:(CGFloat )origin_y AndWidth:(CGFloat )frame_width AndHeight:(CGFloat )frame_height {
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(origin_x, origin_y, frame_width, frame_height)];
    lab.textColor = COLOR_GRAY1;
    lab.font = FONT_15;
    return lab;
}

//改变 剩余时间的数值
-(void)changeTimeLabelValueWithNumber:(NSTimer* )time {
    if (self.timeCount > 1) {
        self.timeCount--;
        self.timeLab.text = [NSString stringWithFormat:@"剩余%d秒",self.timeCount];
    }else if (self.timeCount == 1) {
        [self.timeLab removeFromSuperview];
        self.getCodeBtn.enabled = YES;
        self.getCodeBtn.backgroundColor = COLOR_BLUE1;
        [time invalidate];
    }
}

//点击 下一步 按钮
-(void)clickedNextButton:(UIButton* )sender {
    if (self.identifyCodeTF.text.length == 0) {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    }else {
        if ([self.identifyCodeTF.text isEqualToString:self.verifyCode]) {

            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.phoneNumberStr forKey:@"phoneNumber"];
            [defaults setInteger:0 forKey:@"runCount"];
            [defaults setBool:NO forKey:@"isLogin"];
            [defaults synchronize];
            
            HBLoginViewController* HBLoginVC = [[HBLoginViewController alloc]init];
            [self.navigationController presentViewController:HBLoginVC animated:NO completion:^{
                
            }];
        }else {
            UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证码错误，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
        }
    }
    
}

//获取验证码
-(void)getIdentifyCodeFromService {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/data/getVerificationCode.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"appToken=%@&appSecret=%@&appType=%@&phone=%@", APPTOKEN, self.passwordStr, APPTYPE, self.phoneNumberStr];
    
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]intValue] == 1) {
                self.verifyCode = jsonDic[@"verifyCode"];//验证码
            }
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
