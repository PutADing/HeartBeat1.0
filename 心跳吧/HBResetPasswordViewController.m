//
//  HBResetPasswordViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/2.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBResetPasswordViewController.h"

@interface HBResetPasswordViewController () <UIAlertViewDelegate>
@property (nonatomic, strong)UITextField* passwordTF;//输入新密码
@property (nonatomic, strong)UITextField* rePasswordTF;//再次输入新密码

@end

@implementation HBResetPasswordViewController

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
    self.passwordTF = [self createTextFieldWithPlaceholder:@"新密码,8-16个字符"];
    [cellView0 addSubview:self.passwordTF];
    
    UIView* cellView1 = [self createCellViewWithY:cellView0.frame.origin.y + cellView0.frame.size.height];
    [self.view addSubview:cellView1];
    self.rePasswordTF = [self createTextFieldWithPlaceholder:@"请再次输入新密码"];
    [cellView1 addSubview:self.rePasswordTF];
    
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

//输入新密码 再次输入新密码 textField
-(UITextField* )createTextFieldWithPlaceholder:(NSString* )placeholderStr {
    UITextField* tf = [[UITextField alloc]initWithFrame:CGRectMake(SPACE_TEXTFIELD, (LINE_HEIGHT - HEIGHT_TEXTFIELD)/2, self.view.bounds.size.width - SPACE_TEXTFIELD*2, HEIGHT_TEXTFIELD)];
    tf.secureTextEntry = YES;
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

-(void)clickedSubmitButton:(UIButton* )sender {
    if ([self.passwordTF.text isEqualToString:self.rePasswordTF.text]) {
        if ([self isPassword:self.passwordTF] && [self isPassword:self.rePasswordTF]) {
            
            [self submitData];
            
        }else {
            UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"格式不正确，密码需为8-16个字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
        }
    }else {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"两次输入的密码不一样" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    }
    
}

-(void)submitData {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/user/modifyPasswordByPhone.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"appToken=%@&newPassword=%@&phone=%@", APPTOKEN, self.passwordTF.text, self.phoneNumberStr];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]intValue] == 1) {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"密码修改成功，前往登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                av.tag = 10;
                [av show];
            }
        });
    }];
}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10) {
        if (buttonIndex == 0) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
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
