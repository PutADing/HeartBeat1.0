//
//  HBRegist_1ViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/26.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBRegist_1ViewController.h"
#import "HBIdentifyCodeViewController.h"
#import "HBTool.h"

@interface HBRegist_1ViewController () <UIAlertViewDelegate>
@property (nonatomic, strong)UITextField* nickNameTF;//昵称
@property (nonatomic, strong)UITextField* phoneNumberTF;//手机号
@property (nonatomic, strong)UITextField* passwordTF;//密码
@property (nonatomic, strong)UITextField* jianMaTF;//简码

@end

@implementation HBRegist_1ViewController

//每行高度
#define LINE_HEIGHT 50
//线距离左的间距
#define SPACE_X_LINE 5
//线的高
#define HEIGHT_LINE 10
//图片距离左的间距
#define SPACE_X_IMAGE 10
//图片大小
#define WIDTH_IMAGE 20
//textField高
#define HEIGHT_TEXTFIELD 30
//按钮 下一步 的宽高
#define WIDTH_NEXTBUTTON (self.view.frame.size.width/2)
#define HEIGHT_NEXTBUTTON 35

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新用户注册";
    self.view.backgroundColor = COLOR_WHITE1;
    
    //添加点击手势
    UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tapGR.numberOfTapsRequired = 1;
    tapGR.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGR];
    
    NSArray* imageNameArr = @[@"nickName.png",@"cellphone.png",@"password.png",@"jianMa.png"];
    NSArray* placeholderArr = @[@"请输入昵称",@"请输入11位手机号",@"请输入密码，8-16个字符",@"请输入简码，2-4个大写字母"];
    for (int i = 0; i < 4; i++) {
        UIView* cellView = [self createCellViewWithY:NAVIGATIOINBARHEIGHT + LINE_HEIGHT*i AndImageName:imageNameArr[i] AndPlaceholdString:placeholderArr[i] AndTime:i];
        [self.view addSubview:cellView];
    }
    
    UIButton* jianMaBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 90 - SPACE_X_LINE, NAVIGATIOINBARHEIGHT + LINE_HEIGHT*4, 90, 20)];
    jianMaBtn.titleLabel.font = FONT_15;
    [jianMaBtn setTitle:@"什么是简码？" forState:UIControlStateNormal];
    [jianMaBtn setTitleColor:COLOR_BLUE1 forState:UIControlStateNormal];
    [jianMaBtn addTarget:self action:@selector(clickedJianMaButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jianMaBtn];
    
    UIButton* nextBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - WIDTH_NEXTBUTTON)/2, jianMaBtn.frame.origin.y + jianMaBtn.frame.size.height + 15, WIDTH_NEXTBUTTON, HEIGHT_NEXTBUTTON)];
    nextBtn.backgroundColor = COLOR_BLUE1;
    nextBtn.titleLabel.font = FONT_20;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickedNextButton:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 5;
    nextBtn.layer.masksToBounds = YES;
    [self.view addSubview:nextBtn];
}

//创建四个单元行
-(UIView* )createCellViewWithY:(CGFloat )origin_y AndImageName:(NSString* )imageName AndPlaceholdString:(NSString* )placeholdStr AndTime:(int )time {
    UIView* vi = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, LINE_HEIGHT)];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_X_IMAGE, (LINE_HEIGHT - WIDTH_IMAGE)/2, WIDTH_IMAGE, WIDTH_IMAGE)];
    imageView.image = [UIImage imageNamed:imageName];
    [vi addSubview:imageView];
    
    if (time == 0) {
        self.nickNameTF = [self createTextFieldWithX:SPACE_X_IMAGE*2 + WIDTH_IMAGE AndY:(LINE_HEIGHT - HEIGHT_TEXTFIELD)/2 AndWidth:vi.frame.size.width - WIDTH_IMAGE - SPACE_X_IMAGE*3 AndHeight:HEIGHT_TEXTFIELD AndPlaceholder:placeholdStr AndView:vi];
        self.nickNameTF.keyboardType = UIKeyboardTypeDefault;
    }else if (time == 1) {
        self.phoneNumberTF = [self createTextFieldWithX:SPACE_X_IMAGE*2 + WIDTH_IMAGE AndY:(LINE_HEIGHT - HEIGHT_TEXTFIELD)/2 AndWidth:vi.frame.size.width - WIDTH_IMAGE - SPACE_X_IMAGE*3 AndHeight:HEIGHT_TEXTFIELD AndPlaceholder:placeholdStr AndView:vi];
        self.phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    }else if (time == 2) {
        self.passwordTF = [self createTextFieldWithX:SPACE_X_IMAGE*2 + WIDTH_IMAGE AndY:(LINE_HEIGHT - HEIGHT_TEXTFIELD)/2 AndWidth:vi.frame.size.width - WIDTH_IMAGE - SPACE_X_IMAGE*3 AndHeight:HEIGHT_TEXTFIELD AndPlaceholder:placeholdStr AndView:vi];
        self.passwordTF.keyboardType = UIKeyboardTypeDefault;
        self.passwordTF.secureTextEntry = YES;
    }else if (time == 3) {
        self.jianMaTF = [self createTextFieldWithX:SPACE_X_IMAGE*2 + WIDTH_IMAGE AndY:(LINE_HEIGHT - HEIGHT_TEXTFIELD)/2 AndWidth:vi.frame.size.width - WIDTH_IMAGE - SPACE_X_IMAGE*3 AndHeight:HEIGHT_TEXTFIELD AndPlaceholder:placeholdStr AndView:vi];
        self.jianMaTF.keyboardType = UIKeyboardTypeDefault;
    }
    
    [self createLineImageViewWithX:SPACE_X_LINE AndY:LINE_HEIGHT - HEIGHT_LINE AndWidth:vi.frame.size.width - SPACE_X_LINE*2 AndHeight:HEIGHT_LINE AndView:vi];
    return vi;
}

//创建textField
-(UITextField* )createTextFieldWithX:(CGFloat )origin_x AndY:(CGFloat )origin_y AndWidth:(CGFloat )frame_width AndHeight:(CGFloat )frame_height AndPlaceholder:(NSString* )placeholderStr AndView:(UIView* )superVi {
    UITextField* tf = [[UITextField alloc]initWithFrame:CGRectMake(origin_x, origin_y, frame_width, frame_height)];
    tf.font = FONT_17;
    tf.placeholder = placeholderStr;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [superVi addSubview:tf];
    return tf;
}

//创建线
-(void)createLineImageViewWithX:(CGFloat )origin_x AndY:(CGFloat )origin_y AndWidth:(CGFloat )frame_width AndHeight:(CGFloat )frame_height AndView:(UIView* )superVi {
    UIImageView* iv = [[UIImageView alloc]initWithFrame:CGRectMake(origin_x, origin_y, frame_width, frame_height)];
    iv.image = [UIImage imageNamed:@"blueLine.png"];
    [superVi addSubview:iv];
}

//点击 什么是简码 按钮
-(void)clickedJianMaButton:(UIButton* )sender {
    NSLog(@"点击 什么是简码 按钮");
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"什么是简码" message:@"简码就是2-4个大写字母，用于修改密码，24小时内有2次输入机会，请牢记！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [av show];
}

//判断昵称
-(BOOL )isNickName:(UITextField* )tf {
    if (tf.text.length != 0) {
        return YES;
    }else {
        return NO;
    }
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

//判断简码
-(BOOL )isJianMa:(UITextField* )tf {
    if (tf.text.length >= 2 && tf.text.length <=4) {
        NSString* passWordRegex = @"^[A-Z]{2,4}+$";
        NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
        return [passWordPredicate evaluateWithObject:tf.text];
    }else {
        return NO;
    }
}

//点击 下一步 按钮
-(void)clickedNextButton:(UIButton* )sender {
    
//    [self submitData];
//    
//    HBIdentifyCodeViewController* HBIdentifyCodeVC = [[HBIdentifyCodeViewController alloc]init];
//    HBIdentifyCodeVC.phoneNumberStr = self.phoneNumberTF.text;
//    HBIdentifyCodeVC.presentWay = 0;
//    [self.navigationController pushViewController:HBIdentifyCodeVC animated:NO];
    
    
    if ([self isNickName:self.nickNameTF]) {
        NSLog(@"昵称 格式正确");
        
        if ([self isCellPhoneNumber:self.phoneNumberTF]) {
            NSLog(@"手机号 格式正确");
            
            if ([self isPassword:self.passwordTF]) {
                NSLog(@"密码 格式正确");
                
                if ([self isJianMa:self.jianMaTF]) {
                    NSLog(@"简码 格式正确");
                    
                    //提交注册信息
                    [self submitData];
                    
                }else {
                    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"简码格式错误，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [av show];
                }
            }else {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"密码格式错误，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [av show];
            }
        }else {
            UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"手机号格式错误，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
        }
    }else {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"昵称格式错误，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    }
    
}

-(void)submitData {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/user/register.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"nickName=%@&phone=%@&password=%@&simpleWord=%@", self.nickNameTF.text, self.phoneNumberTF.text, self.passwordTF.text, self.jianMaTF.text];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* result_String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"result_String:%@", result_String);
        
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([jsonDic[@"status"] intValue] == 1) {
                
                HBIdentifyCodeViewController* HBIdentifyCodeVC = [[HBIdentifyCodeViewController alloc]init];
                HBIdentifyCodeVC.phoneNumberStr = self.phoneNumberTF.text;
                HBIdentifyCodeVC.passwordStr = self.passwordTF.text;
                [self.navigationController pushViewController:HBIdentifyCodeVC animated:NO];
                
            }else if ([jsonDic[@"status"] intValue] == -2) {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"该手机号已注册过，您可以直接登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                av.tag = 10;
                [av show];
            }else if ([jsonDic[@"status"] intValue] == -1) {
                NSLog(@"注册时参数错误");
            }
        });
    }];
}

//服务器返回“手机号已注册”时 pop到登陆页面
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10 && buttonIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//输入框放弃第一响应者身份 收缩键盘
-(void)tap:(UITapGestureRecognizer* )gr {
    [self.nickNameTF resignFirstResponder];
    [self.phoneNumberTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.jianMaTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
