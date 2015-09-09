//
//  HBVertifySimpleCodeViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/1.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBVertifySimpleCodeViewController.h"
#import "HBResetPasswordViewController.h"
#import "HBTool.h"

@interface HBVertifySimpleCodeViewController ()
@property (nonatomic, strong)UITextField* simpleCodeTF;

@end

@implementation HBVertifySimpleCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证简码";
    self.view.backgroundColor = COLOR_WHITE1;
    
    [self createSimpleCodeTextFieldWithY:NAVIGATIOINBARHEIGHT];
}

-(void)createSimpleCodeTextFieldWithY:(CGFloat )origin_y {
    self.simpleCodeTF = [[UITextField alloc]initWithFrame:CGRectMake(10, origin_y + 15, self.view.frame.size.width - 10*2, 30)];
    self.simpleCodeTF.placeholder = @"请输入简码";
    self.simpleCodeTF.font = FONT_17;
    self.simpleCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.simpleCodeTF];
    
    UIImageView* blueLine = [[UIImageView alloc]initWithFrame:CGRectMake(5, self.simpleCodeTF.frame.origin.y + self.simpleCodeTF.frame.size.height, self.view.frame.size.width - 5*2, 10)];
    blueLine.image = [UIImage imageNamed:@"blueLine.png"];
    [self.view insertSubview:blueLine belowSubview:self.simpleCodeTF];
    
    //忘了简码 按钮
    UIButton* forgetJianMaBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 65 - 10, blueLine.frame.origin.y + blueLine.frame.size.height, 65, 20)];
    forgetJianMaBtn.titleLabel.font = FONT_15;
    [forgetJianMaBtn setTitle:@"忘了简码" forState:UIControlStateNormal];
    [forgetJianMaBtn setTitleColor:COLOR_BLUE1 forState:UIControlStateNormal];
    [forgetJianMaBtn addTarget:self action:@selector(clickedForgetSimpleCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetJianMaBtn];
    
    //提交 按钮
    UIButton* submitBtn = [self createSubmitButtonWithRect:CGRectMake(self.view.frame.size.width/4, forgetJianMaBtn.frame.origin.y + forgetJianMaBtn.frame.size.height + 15, self.view.frame.size.width/2, 35) AndButtonTitle:@"提交"];
    [self.view addSubview:submitBtn];
}

//点击 忘了简码 按钮
-(void)clickedForgetSimpleCodeButton:(UIButton* )sender {
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请前往心跳吧官网进行申诉" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [av show];
}

//提交 按钮
-(UIButton* )createSubmitButtonWithRect:(CGRect )rect AndButtonTitle:(NSString* )titleString {
    UIButton* btn = [[UIButton alloc]initWithFrame:rect];
    btn.backgroundColor = COLOR_BLUE1;
    btn.titleLabel.font = FONT_20;
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    [btn setTitle:titleString forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickedSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
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

//显示alertView
-(void)showAlertViewWithMessage:(NSString* )textStr {
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:textStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [av show];
}

//点击 提交 按钮
-(void)clickedSubmitButton:(UIButton* )sender {
    if ([self isSimpleCode:self.simpleCodeTF]) {
        NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/user/checkSimpleWordByPhone.do"];
        NSString* argumentStr = [NSString stringWithFormat:@"appToken=%@&simpleWord=%@&phone=%@", APPTOKEN, self.simpleCodeTF, PHONENUMBER];
        [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
            NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([jsonDic[@"status"]integerValue] == 1) {
                    HBResetPasswordViewController* HBResetPasswordVC = [[HBResetPasswordViewController alloc]init];
                    HBResetPasswordVC.phoneNumberStr = PHONENUMBER;
                    [self.navigationController pushViewController:HBResetPasswordVC animated:NO];
                }else {
                    [self showAlertViewWithMessage:@"验证简码失败"];
                }
            });
        }];
    }else {
        [self showAlertViewWithMessage:@"简码格式不正确，请重新输入"];
    }
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
