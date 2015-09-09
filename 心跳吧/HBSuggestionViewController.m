//
//  HBSuggestionViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/1.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBSuggestionViewController.h"
#import "GCPlaceholderTextView.h"
#import "HBTool.h"

@interface HBSuggestionViewController () <UIAlertViewDelegate>
@property (nonatomic, strong)GCPlaceholderTextView* adviceTV;
@property (nonatomic, strong)UITextField* contactTF;

@end

@implementation HBSuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"反馈建议";
    self.view.backgroundColor = COLOR_WHITE1;
    
    [self initViewsWithY:NAVIGATIOINBARHEIGHT];
    
    
}

-(void)initViewsWithY:(CGFloat )origin_y {
    self.contactTF = [[UITextField alloc]initWithFrame:CGRectMake(10, origin_y + 15, self.view.frame.size.width - 10*2, 30)];
    self.contactTF.placeholder = @"请输入您的联系方式";
    self.contactTF.font = FONT_17;
    [self.view addSubview:self.contactTF];
    
    self.adviceTV = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(10, self.contactTF.frame.origin.y + self.contactTF.frame.size.height + 15, self.view.frame.size.width, 100)];
    self.adviceTV.placeholder = @"请输入您的建议";
    self.adviceTV.font = FONT_17;
    [self.view addSubview:self.adviceTV];
    
    UIButton* submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4, self.adviceTV.frame.origin.y + self.adviceTV.frame.size.height + 15, self.view.frame.size.width/2, 35)];
    submitBtn.backgroundColor = COLOR_BLUE1;
    submitBtn.titleLabel.font = FONT_20;
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(clickedSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}

//判断 textView 是否为空
-(BOOL )isTextWithTextView:(UITextView* )tv {
    if (tv.text.length > 0) {
        return YES;
    }else {
        return NO;
    }
}

//判断 textField 是否为空
-(BOOL )isTextWithTextField:(UITextField* )tf {
    if (tf.text.length > 0) {
        return YES;
    }else {
        return NO;
    }
}

//显示alertView
-(void)showAlertViewWithMessage:(NSString* )messageStr {
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:messageStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [av show];
}

//点击 提交 按钮
-(void)clickedSubmitButton:(UIButton* )sender {
    if ([self isTextWithTextView:self.adviceTV]) {
        if ([self isTextWithTextField:self.contactTF]) {
            NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/setting/submitAdvice.do"];
            NSString* argumentStr = [NSString stringWithFormat:@"content=%@&contact=%@&myId=%ld&apiKey=%@", self.adviceTV.text, self.contactTF.text, USERID, APIKEY];
            
            [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
                NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"jsonDic=%@", jsonDic);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([jsonDic[@"status"]integerValue] == 1) {
                        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"提交成功，非常感谢您的反馈，我们将努力改进" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        alertView.tag = 100;
                        [alertView show];
                    }else {
                        [self showAlertViewWithMessage:@"提交失败，请稍后重试"];
                    }
                });
            }];
        }else {
            [self showAlertViewWithMessage:@"请留下您的联系方式"];
        }
    }else {
        [self showAlertViewWithMessage:@"请输入您的建议"];
    }
}

//点击alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
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
