//
//  HBLoginViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/26.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBLoginViewController.h"
#import "HBTool.h"
#import "HBForgetPasswordViewController.h"
#import "HBNavigationController.h"
#import "HBShareViewController.h"
#import "HBUser.h"

@interface HBLoginViewController ()
@property (nonatomic, strong)UITextField* phoneNumberTF;//手机号
@property (nonatomic, strong)UITextField* passwordTF;//密码

@end

@implementation HBLoginViewController

//距离顶部的间距
#define SPACE_TOP 0
//每行的高度
#define LINE_HEIGHT 50
//线距离左的间距
#define SPACE_X_LINE 5
//图片距离左的间距
#define SPACE_X_IMAGE 10
//图片大小
#define WIDTH_IMAGE 20
//textField的高度
#define HEIGHT_TEXTFIELD 30
//登陆 按钮宽高
#define WIDTH_LOGIN_BUTTON (self.view.frame.size.width/2)
#define HEIGHT_LOGIN_BUTTON 35

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[HBTool shareTool]isIOS7_Later]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    self.view.backgroundColor = COLOR_WHITE1;
    [self createLogoLabelWithString:@"心跳吧"];
    
    [self initViews];
}

//最左上角 心跳吧 三个字
-(void)createLogoLabelWithString:(NSString* )logoString {
    UILabel* logoLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    logoLab.text = logoString;
    logoLab.textColor = COLOR_WHITE1;
    logoLab.font = FONT_20;
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:logoLab];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)initViews {
    UIView* cellView1 = [self createCellViewWithY:NAVIGATIOINBARHEIGHT+SPACE_TOP AndImageName:@"cellphone.png"];
    self.phoneNumberTF = [self createTextFieldWithX:SPACE_X_IMAGE*2 + WIDTH_IMAGE AndY:(LINE_HEIGHT - HEIGHT_TEXTFIELD)/2 AndWidth:cellView1.frame.size.width - SPACE_X_IMAGE*3 - WIDTH_IMAGE AndHeight:HEIGHT_TEXTFIELD AndPlaceholder:@"手机号"];
    self.phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;//数字键盘类型
    self.phoneNumberTF.clearButtonMode = UITextFieldViewModeWhileEditing;//编辑时可以清除
    [cellView1 addSubview:self.phoneNumberTF];
    [self.view addSubview:cellView1];
    
    UIView* cellView2 = [self createCellViewWithY:cellView1.frame.origin.y + LINE_HEIGHT AndImageName:@"password.png"];
    self.passwordTF = [self createTextFieldWithX:SPACE_X_IMAGE*2 + WIDTH_IMAGE AndY:(LINE_HEIGHT - HEIGHT_TEXTFIELD)/2 AndWidth:cellView2.frame.size.width - SPACE_X_IMAGE*3 - WIDTH_IMAGE AndHeight:HEIGHT_TEXTFIELD AndPlaceholder:@"密码"];
    self.passwordTF.keyboardType = UIKeyboardTypeDefault;//默认键盘类型
    self.passwordTF.secureTextEntry = YES;//密码形式
    self.passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;//编辑时可以清除
    [cellView2 addSubview:self.passwordTF];
    [self.view addSubview:cellView2];
    
    self.phoneNumberTF.text = @"18565592468";//
    self.passwordTF.text = @"ldszz123";//
    
    //忘了密码 按钮
    UIButton* forgetPasswordBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 65 - 10, cellView2.frame.origin.y + cellView2.frame.size.height, 65, 20)];
    forgetPasswordBtn.titleLabel.font = FONT_15;
    [forgetPasswordBtn setTitle:@"忘了密码" forState:UIControlStateNormal];
    [forgetPasswordBtn setTitleColor:COLOR_BLUE1 forState:UIControlStateNormal];
    [forgetPasswordBtn addTarget:self action:@selector(clickedForgetPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPasswordBtn];
    
    UIButton* loginBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - WIDTH_LOGIN_BUTTON)/2, forgetPasswordBtn.frame.origin.y + forgetPasswordBtn.frame.size.height + 10, WIDTH_LOGIN_BUTTON, HEIGHT_LOGIN_BUTTON)];
    loginBtn.backgroundColor = COLOR_BLUE1;
    loginBtn.titleLabel.font = FONT_20;
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(clickedLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:loginBtn];
    
    UIButton* registBtn = [[UIButton alloc]initWithFrame:CGRectMake(SPACE_X_LINE, loginBtn.frame.origin.y + loginBtn.frame.size.height + 10, 80, 20)];
    registBtn.titleLabel.font = FONT_15;
    [registBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor colorWithRed:0 green:0.8f blue:0 alpha:1.0f] forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(clickedRegistButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
}

//创建 两行
-(UIView* )createCellViewWithY:(CGFloat )origin_y AndImageName:(NSString* )imageName {
    UIView* cellView = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, LINE_HEIGHT)];
    
    UIImageView* imageView = [self createImageViewWithX:SPACE_X_IMAGE AndY:(LINE_HEIGHT - WIDTH_IMAGE)/2 AndWidth:WIDTH_IMAGE AndHeight:WIDTH_IMAGE AndImageName:imageName];
    [cellView addSubview:imageView];
    
    UIImageView* iv = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_X_LINE, LINE_HEIGHT - 10, cellView.frame.size.width - SPACE_X_LINE*2, 10)];
    iv.image = [UIImage imageNamed:@"blueLine.png"];
    [cellView addSubview:iv];
    return cellView;
}

//创建 手机号、密码 两张图片
-(UIImageView* )createImageViewWithX:(CGFloat )origin_x AndY:(CGFloat )origin_y AndWidth:(CGFloat )frame_width AndHeight:(CGFloat )frame_height AndImageName:(NSString* )imageName {
    UIImageView* iv = [[UIImageView alloc]initWithFrame:CGRectMake(origin_x, origin_y, frame_width, frame_height)];
    iv.image = [UIImage imageNamed:imageName];
    return iv;
}

//创建 手机号、密码 两个输入框
-(UITextField* )createTextFieldWithX:(CGFloat )origin_x AndY:(CGFloat )origin_y AndWidth:(CGFloat )frame_width AndHeight:(CGFloat )frame_height AndPlaceholder:(NSString* )placeholderStr {
    UITextField* tf = [[UITextField alloc]initWithFrame:CGRectMake(origin_x, origin_y, frame_width, frame_height)];
    tf.placeholder = placeholderStr;
    tf.textColor = COLOR_BLACK1;
    tf.font = FONT_17;
    return tf;
}

//判断手机号
-(BOOL )isCellPhoneNumber:(UITextField* )tf {
    if (tf.text.length == 11) {
        return YES;
    }else {
        return NO;
    }
}

//判断密码
-(BOOL )isPassword:(UITextField* )tf {
    if (tf.text.length >= 8 && tf.text.length <= 16) {
        NSString* passWordRegex = @"^[a-zA-Z0-9]{8,16}+$";
        NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
        return [passWordPredicate evaluateWithObject:tf.text];
    }else {
        return NO;
    }
}

//点击 忘了密码 按钮
-(void)clickedForgetPasswordButton:(UIButton* )sender {    
    HBForgetPasswordViewController* HBForgetPasswordVC = [[HBForgetPasswordViewController alloc]init];
    if ([self isCellPhoneNumber:self.phoneNumberTF]) {
        HBForgetPasswordVC.phoneNumberStr = self.phoneNumberTF.text;
    }
    [self.navigationController pushViewController:HBForgetPasswordVC animated:NO];
}

//点击 注册 按钮
-(void)clickedRegistButton:(UIButton* )sender {
    
    HBRegist_1ViewController* HBRegist_1VC = [[HBRegist_1ViewController alloc]init];
    [self.navigationController pushViewController:HBRegist_1VC animated:NO];
}

//点击 登陆 按钮
-(void)clickedLoginButton:(UIButton* )sender {
    
    NSString* date1 = @"2015-06-15 12:23:00";
    NSString* date2 = @"2015-06-15 12:25";
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter* df2 = [[NSDateFormatter alloc]init];
    [df2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* dateDate1 = [df dateFromString:date1];
    NSDate* dateDate2 = [df2 dateFromString:date2];
    
    NSTimeInterval cha = [dateDate2 timeIntervalSinceDate:dateDate1];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:cha];
    NSString* nowTime = [df stringFromDate:date];
    
    
      //测试时将判断手机号、密码屏蔽
    if ([self isCellPhoneNumber:self.phoneNumberTF]) {
        if ([self isPassword:self.passwordTF]) {
            
            //若手机号 密码都不为空 提交数据
            [self submitData];
            
        }else {
            UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
        }
    }else {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    }
}

-(void)submitData {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/user/login.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"phone=%@&password=%@&versionInfo=&deviceInfo=&longtitude=&latitude=",self.phoneNumberTF.text, self.passwordTF.text];
    [[HBTool shareTool]postWithURL:urlStr andArgument:argumentStr AndBlock:^(NSDictionary *jsonDic) {
        if ([jsonDic[@"status"] intValue] == 1) {
            
            [self saveUserInfoWithJSONDic:jsonDic];
            
            HBShareViewController* shareVC = [[HBShareViewController alloc]init];
            HBNavigationController* navi = [[HBNavigationController alloc]initWithRootViewController:shareVC];
            [self.navigationController presentViewController:navi animated:NO completion:^{
                
            }];
        }else if ([jsonDic[@"status"] intValue] == -2) {
            UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"该手机号尚未注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
        }else if ([jsonDic[@"status"] intValue] == -3) {
            UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"账号或密码错误，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
        }else {
            UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"登陆失败，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
        }
    }];
}

/*
//提交数据
-(void)submitData {
    //versionInfo deviceInfo longtitude latitude先空缺
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/user/login.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"phone=%@&password=%@&versionInfo=&deviceInfo=&longtitude=&latitude=",self.phoneNumberTF.text, self.passwordTF.text];
    
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
//        NSString* result_String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"result_String=%@", result_String);
        NSDictionary* jsonDic;
        if (data == nil || data.length == 0) {
            NSLog(@"error=%@", [error localizedDescription]);
        }else {
            jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"jsonDic=%@", jsonDic);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"] intValue] == 1) {
                
                [self saveUserInfoWithJSONDic:jsonDic];
                
                HBShareViewController* shareVC = [[HBShareViewController alloc]init];
                HBNavigationController* navi = [[HBNavigationController alloc]initWithRootViewController:shareVC];
                [self.navigationController presentViewController:navi animated:NO completion:^{
                    
                }];
                
            }else if ([jsonDic[@"status"] intValue] == -2) {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"该手机号尚未注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [av show];
            }else if ([jsonDic[@"status"] intValue] == -3) {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"账号或密码错误，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [av show];
            }else {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"登陆失败，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [av show];
            }
        });
    }];
}
*/

-(void)saveUserInfoWithJSONDic:(NSDictionary* )jsonDic {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* apiKey = jsonDic[@"apiKey"];
    [defaults setObject:apiKey forKey:@"apiKey"];
    
    NSDictionary* userInfoDic = jsonDic[@"userInfo"];
    NSString* avatar = userInfoDic[@"avatar"];
    if (![userInfoDic[@"avatar"] isKindOfClass:[NSNull class]]) {
        if (![avatar isEqualToString:@"null  "] && ![avatar isEqualToString:@"null"]) {
            [defaults setObject:avatar forKey:@"avatar"];
        }
    }
    if ([userInfoDic[@"personalizedSignature"] isKindOfClass:[NSNull class]]) {
        NSLog(@"进入if语句，personalizedSignature为空");
    }else {
        NSString* personalizedSignature = userInfoDic[@"personalizedSignature"];
        [defaults setObject:personalizedSignature forKey:@"personalizedSignature"];
    }
    NSString* gender = userInfoDic[@"gender"];
    [defaults setObject:gender forKey:@"gender"];
    
    NSString* heartbeatNumber = userInfoDic[@"heartbeatNumber"];
    if (heartbeatNumber.length > 0) {
        [defaults setObject:heartbeatNumber forKey:@"heartbeatNumber"];
    }
    
    NSInteger level = [userInfoDic[@"level"]integerValue];
    [defaults setInteger:level forKey:@"level"];
    
    NSString* nickName = userInfoDic[@"nickName"];
    [defaults setObject:nickName forKey:@"nickName"];
    
    NSString* registerDate = userInfoDic[@"registerDate"];
    [defaults setObject:registerDate forKey:@"registerDate"];
    
    NSInteger userId = [userInfoDic[@"userId"]integerValue];
    [defaults setInteger:userId forKey:@"userId"];
    
    NSString* appSecret = self.passwordTF.text;
    [defaults setObject:appSecret forKey:@"appSecret"];
    
    NSString* phoneNumberStr = self.phoneNumberTF.text;
    [defaults setObject:phoneNumberStr forKey:@"phoneNumber"];
    
    [defaults setBool:YES forKey:@"isLogin"];
    
    [defaults synchronize];//数据同步
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
