//
//  HBChangePhoneViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/1.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBChangePhoneViewController.h"
#import "HBTool.h"
#import "HBVerifyMessageCodeViewController.h"

@interface HBChangePhoneViewController ()
@property (nonatomic, strong)UITextField* simpleCodeTF;
@property (nonatomic, strong)UITextField* phoneNumberTF;

@end

@implementation HBChangePhoneViewController

#define LINE_HEIGHT 50

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手机号";
    self.view.backgroundColor = COLOR_WHITE1;
    
    UIView* cellView0 = [self createCellViewWithY:NAVIGATIOINBARHEIGHT];
    [self.view addSubview:cellView0];
    self.simpleCodeTF = [self createTextFieldWithRect:CGRectMake(10, (LINE_HEIGHT - 30)/2, self.view.frame.size.width - 10*2, 30) AndPlaceholder:@"请输入简码"];
    [cellView0 addSubview:self.simpleCodeTF];
    
    //忘了简码 按钮
    UIButton* forgetJianMaBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 65 - 10, cellView0.frame.origin.y + cellView0.frame.size.height, 65, 20)];
    forgetJianMaBtn.titleLabel.font = FONT_15;
    [forgetJianMaBtn setTitle:@"忘了简码" forState:UIControlStateNormal];
    [forgetJianMaBtn setTitleColor:COLOR_BLUE1 forState:UIControlStateNormal];
    [forgetJianMaBtn addTarget:self action:@selector(clickedForgetSimpleCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetJianMaBtn];
    
    UIView* cellView1 = [self createCellViewWithY:forgetJianMaBtn.frame.origin.y + forgetJianMaBtn.frame.size.height];
    [self.view addSubview:cellView1];
    self.phoneNumberTF = [self createTextFieldWithRect:CGRectMake(10, (LINE_HEIGHT - 30)/2, self.view.frame.size.width - 10*2, 30) AndPlaceholder:@"请输入新手机号"];
    [cellView1 addSubview:self.phoneNumberTF];
    
    //提交 按钮
    UIButton* submitBtn = [self createSubmitButtonWithRect:CGRectMake(self.view.frame.size.width/4, cellView1.frame.origin.y + cellView1.frame.size.height + 15, self.view.frame.size.width/2, 35) AndButtonTitle:@"提交"];
    [self.view addSubview:submitBtn];
    
}

//创建单元行
-(UIView* )createCellViewWithY:(CGFloat )origin_y {
    UIView* vi = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y + 15, self.view.frame.size.width, LINE_HEIGHT)];
    UIImageView* iv = [[UIImageView alloc]initWithFrame:CGRectMake(5, LINE_HEIGHT - 10, self.view.frame.size.width - 5*2, 10)];
    iv.image = [UIImage imageNamed:@"blueLine.png"];
    return vi;
}

//创建textField
-(UITextField* )createTextFieldWithRect:(CGRect )rect AndPlaceholder:(NSString* )placeholderStr {
    UITextField* tf = [[UITextField alloc]initWithFrame:rect];
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.placeholder = placeholderStr;
    tf.textColor = COLOR_BLACK1;
    tf.font = FONT_17;
    return tf;
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

-(BOOL )isPhoneNumberWithTextField:(UITextField* )tf {
    if (tf.text.length == 11) {
        return YES;
    }else {
        return NO;
    }
}

-(void)showAlertViewWithMessage:(NSString* )messageStr {
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:messageStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [av show];
}

//点击 提交 按钮
-(void)clickedSubmitButton:(UIButton* )sender {
    if ([self isSimpleCode:self.simpleCodeTF]) {
        if ([self isPhoneNumberWithTextField:self.phoneNumberTF]) {
            
            [self submitData];
            
        }else {
            [self showAlertViewWithMessage:@"手机号格式不正确，请重新输入"];
        }
    }else {
        [self showAlertViewWithMessage:@"简码格式不正确，请重新输入"];
    }
}

-(void)submitData {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/user/modifyPhoneNumber.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"newPhone=%@&myId=%ld&apiKey=%@", self.phoneNumberTF.text, USERID, APIKEY];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                
                HBVerifyMessageCodeViewController* HBVMCVC = [[HBVerifyMessageCodeViewController alloc]init];
                HBVMCVC.phoneNumberStr = self.phoneNumberTF.text;
                HBVMCVC.passwordStr = APPSECRET;
                [self.navigationController pushViewController:HBVMCVC animated:NO];
                
            }else {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"修改手机号失败，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
