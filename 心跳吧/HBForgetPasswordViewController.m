//
//  HBForgetPasswordViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/31.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBForgetPasswordViewController.h"
#import "HBResetPasswordViewController.h"
#import "HBTool.h"

@interface HBForgetPasswordViewController ()
@property (nonatomic, strong)UITextField* phoneNumberTF;//手机号
@property (nonatomic, strong)UITextField* simpleCodeTF;//简码

@end

@implementation HBForgetPasswordViewController

//行高
#define LINE_HEIGHT 50
//textField距离左、右间距 高
#define SPACE_TEXTFIELD 10
#define HEIGHT_TEXTFIELD 30
//蓝色线 距离左、右间距  高
#define SPACE_BLUELINE 5
#define HEIGHT_BLUELINE 10
//提交 按钮 宽高
#define WIDTH_BUTTON (self.view.bounds.size.width/2)
#define HEIGHT_BUTTON 35

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_WHITE1;
    self.title = @"验证简码";
    
    UIView* cellView0 = [self createCellViewWithY:NAVIGATIOINBARHEIGHT];
    [self.view addSubview:cellView0];
    self.phoneNumberTF = [self createTextFieldWithPlaceholder:@"手机号"];
    self.phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    if (self.phoneNumberStr.length == 11) {
        self.phoneNumberTF.text = self.phoneNumberStr;
    }
    [cellView0 addSubview:self.phoneNumberTF];
    
    UIView* cellView1 = [self createCellViewWithY:cellView0.frame.origin.y + cellView0.frame.size.height];
    [self.view addSubview:cellView1];
    self.simpleCodeTF = [self createTextFieldWithPlaceholder:@"简码"];
    [cellView1 addSubview:self.simpleCodeTF];
    
    //忘了简码 按钮
    UIButton* forgetJiamMaBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 65 - 10, cellView1.frame.origin.y + cellView1.frame.size.height, 65, 20)];
    forgetJiamMaBtn.titleLabel.font = FONT_15;
    [forgetJiamMaBtn setTitle:@"忘了简码" forState:UIControlStateNormal];
    [forgetJiamMaBtn setTitleColor:COLOR_BLUE1 forState:UIControlStateNormal];
    [forgetJiamMaBtn addTarget:self action:@selector(clickedForgetSimpleCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetJiamMaBtn];
    
    //提交 按钮
    UIButton* submitBtn = [self createSubmitButtonWithX:(self.view.bounds.size.width - WIDTH_BUTTON)/2 AndY:cellView1.frame.origin.y + cellView1.frame.size.height + 35 AndButtonTitle:@"提交"];
    [self.view addSubview:submitBtn];
}

//创建单元行
-(UIView* )createCellViewWithY:(CGFloat )origin_y {
    UIView* vi = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.bounds.size.width, LINE_HEIGHT)];
    vi.backgroundColor = COLOR_WHITE1;
    
    UIImageView* blueLine = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_BLUELINE, LINE_HEIGHT - HEIGHT_BLUELINE, vi.bounds.size.width - SPACE_BLUELINE*2, HEIGHT_BLUELINE)];
    blueLine.image = [UIImage imageNamed:@"blueLine.png"];
    [vi addSubview:blueLine];
    
    return vi;
}

//手机号 简码 textField
-(UITextField* )createTextFieldWithPlaceholder:(NSString* )placeholderStr {
    UITextField* tf = [[UITextField alloc]initWithFrame:CGRectMake(SPACE_TEXTFIELD, (LINE_HEIGHT - HEIGHT_TEXTFIELD)/2, self.view.bounds.size.width - SPACE_TEXTFIELD*2, HEIGHT_TEXTFIELD)];
    tf.placeholder = placeholderStr;
    tf.textColor = COLOR_BLACK1;
    tf.font = FONT_17;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    return tf;
}

//提交 按钮
-(UIButton* )createSubmitButtonWithX:(CGFloat )origin_x AndY:(CGFloat )origin_y AndButtonTitle:(NSString* )titleString {
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(origin_x, origin_y, WIDTH_BUTTON, HEIGHT_BUTTON)];
    btn.backgroundColor = COLOR_BLUE1;
    btn.titleLabel.font = FONT_20;
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    [btn setTitle:titleString forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickedSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

//点击 忘了简码 按钮
-(void)clickedForgetSimpleCodeButton:(UIButton* )sender {
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请前往心跳吧官网进行申诉" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [av show];
}

//判断手机号
-(BOOL )isCellPhoneNumber:(UITextField* )tf {
    if (tf.text.length == 11) {
        return YES;
    }else {
        return NO;
    }
}

//判断简码
-(BOOL )isSimpleCode:(UITextField* )tf {
    if (tf.text.length >= 2 && tf.text.length <=4) {
        NSString* passWordRegex = @"^[A-Z]{2,4}+$";
        NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
        return [passWordPredicate evaluateWithObject:tf.text];
    }else {
        return NO;
    }
}

//点击 提交 按钮
-(void)clickedSubmitButton:(UIButton* )sender {
    if ([self isCellPhoneNumber:self.phoneNumberTF] && [self isSimpleCode:self.simpleCodeTF]) {
        NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/user/checkSimpleWordByPhone.do"];
        NSString* argumentStr = [NSString stringWithFormat:@"appToken=%@&simpleWord=%@&phone=%@", APPTOKEN, self.simpleCodeTF.text, self.phoneNumberTF.text];
        
        [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
            NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"result_String=%@", resultStr);
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"jsonDic=%@", jsonDic);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([jsonDic[@"status"] intValue] == 1) {
                    
                    HBResetPasswordViewController* HBResetPasswordVC = [[HBResetPasswordViewController alloc]init];
                    HBResetPasswordVC.phoneNumberStr = self.phoneNumberTF.text;
                    [self.navigationController pushViewController:HBResetPasswordVC animated:NO];
                    
                }else if ([jsonDic[@"status"] intValue] == -2) {
                    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您输入的简码错误，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [av show];
                }
            });
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
