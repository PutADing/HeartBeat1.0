//
//  HBChangeHBNumberViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/26.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBChangeHBNumberViewController.h"
#import "HBTool.h"

@interface HBChangeHBNumberViewController ()<UITextViewDelegate>
@property (nonatomic, strong)UIImageView* blueLine;
@property (nonatomic, strong)UILabel* tipLab;

@end

@implementation HBChangeHBNumberViewController

#define NUMBEROFTEXT 24

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改心跳号";
    self.view.backgroundColor = COLOR_WHITE1;
    
    [self createTextViewWithY:NAVIGATIOINBARHEIGHT];
    
    [self createNavigationBarRightItem];

    
}

//创建右上角 完成 按钮
-(void)createNavigationBarRightItem {
    UIButton* doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 24)];
    [doneBtn addTarget:self action:@selector(clickedDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.layer.cornerRadius = 3;
    doneBtn.layer.masksToBounds = YES;
    doneBtn.backgroundColor = COLOR_BLUE1;
    doneBtn.titleLabel.font = FONT_17;
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:COLOR_WHITE1 forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
}

//创建文本输入框
-(void)createTextViewWithY:(CGFloat )origin_y {
    self.hbNumberTV = [[UITextView alloc]initWithFrame:CGRectMake(10, origin_y + 20, self.view.frame.size.width - 10*2, 30)];
    self.hbNumberTV.textColor = COLOR_BLACK1;
    self.hbNumberTV.font = FONT_17;
    self.hbNumberTV.delegate = self;
    [self.view addSubview:self.hbNumberTV];
    
    self.blueLine = [[UIImageView alloc]initWithFrame:CGRectMake(5, self.hbNumberTV.frame.origin.y + self.hbNumberTV.frame.size.height, self.view.frame.size.width - 5*2, 10)];
    self.blueLine.image = [UIImage imageNamed:@"blueLine.png"];
    [self.view insertSubview:self.blueLine belowSubview:self.hbNumberTV];
    
    self.tipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.blueLine.frame.origin.y + self.blueLine.frame.size.height, self.view.frame.size.width, 20)];
    self.tipLab.textAlignment = NSTextAlignmentRight;
    self.tipLab.textColor = COLOR_GRAY1;
    self.tipLab.font = FONT_15;
    self.tipLab.numberOfLines = 10;
    self.tipLab.text = [NSString stringWithFormat:@"心跳号由6-24位“字母”、“数字”、“.”、“_”组成，只能修改一次"];
    CGFloat height_tipLab = [self.tipLab sizeThatFits:CGSizeMake(self.tipLab.frame.size.width, MAXFLOAT)].height;
    self.tipLab.frame = CGRectMake(self.tipLab.frame.origin.x, self.tipLab.frame.origin.y, self.tipLab.frame.size.width, height_tipLab);
    [self.view addSubview:self.tipLab];
}

#pragma mark- UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > NUMBEROFTEXT) {
        textView.text = [textView.text substringToIndex:NUMBEROFTEXT];
    }
    CGFloat height_tv = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, CGFLOAT_MAX)].height;
    if (height_tv > 30) {
        self.hbNumberTV.frame = CGRectMake(self.hbNumberTV.frame.origin.x, self.hbNumberTV.frame.origin.y, self.hbNumberTV.frame.size.width, height_tv);
        self.blueLine.frame = CGRectMake(self.blueLine.frame.origin.x, self.hbNumberTV.frame.origin.y + self.hbNumberTV.frame.size.height, self.blueLine.frame.size.width, self.blueLine.frame.size.height);
        self.tipLab.frame = CGRectMake(self.tipLab.frame.origin.x, self.blueLine.frame.origin.y + self.blueLine.frame.size.height, self.tipLab.frame.size.width, self.tipLab.frame.size.height);
    }else if (height_tv <= 30) {
        self.hbNumberTV.frame = CGRectMake(self.hbNumberTV.frame.origin.x, self.hbNumberTV.frame.origin.y, self.hbNumberTV.frame.size.width, 30);
        self.blueLine.frame = CGRectMake(self.blueLine.frame.origin.x, self.hbNumberTV.frame.origin.y + self.hbNumberTV.frame.size.height, self.blueLine.frame.size.width, self.blueLine.frame.size.height);
        self.tipLab.frame = CGRectMake(self.tipLab.frame.origin.x, self.blueLine.frame.origin.y + self.blueLine.frame.size.height, self.tipLab.frame.size.width, self.tipLab.frame.size.height);
    }
}

//点击了 完成 按钮
-(void)clickedDoneButton:(UIButton* )sender {
    if (self.hbNumberTV.text.length >= 6 && self.hbNumberTV.text.length <= 24) {
        if ([self isHBNumberWithString:self.hbNumberTV.text]) {
            NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/user/modifyHtNumber.do"];
            NSString* argumentStr = [NSString stringWithFormat:@"myId=%ld&apiKey=%@&newHtName=%@", USERID, APIKEY, self.hbNumberTV.text];
            [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
                NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"jsonDic=%@", jsonDic);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([jsonDic[@"status"]integerValue] == 1) {
                        if (self.returnTextBlock != nil) {
                            self.returnTextBlock(self.hbNumberTV.text);
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }else if ([jsonDic[@"status"]integerValue] == -1) {
                        NSString* messageStr = jsonDic[@"msg"];
                        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"messageStr" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [av show];
                    }
                });
            }];
        }else {
            UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"心跳号只能包含“字母”、“数字”、“.”、“_”" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
        }
    }else {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"心跳号必须是6-24位有效字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    }
}

-(BOOL )isHBNumberWithString:(NSString* )hbNumStr {
    NSCharacterSet *nameCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"._abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    //判断字符串是否在指定的字符集范围内
    NSRange userNameRange = [hbNumStr rangeOfCharacterFromSet:nameCharacters];
    if (userNameRange.location == NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}

-(void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
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
