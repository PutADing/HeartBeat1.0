//
//  HBPersonalSignViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/26.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBPersonalSignViewController.h"
#import "HBTool.h"

@interface HBPersonalSignViewController ()<UITextViewDelegate>
@property (nonatomic, strong)UIImageView* blueLine;
@property (nonatomic, strong)UILabel* tipLab;

@end

@implementation HBPersonalSignViewController

#define NUMBEROFTEXT 32

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改签名";
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
    self.personalSignTV = [[UITextView alloc]initWithFrame:CGRectMake(10, origin_y + 20, self.view.frame.size.width - 10*2, 30)];
    self.personalSignTV.textColor = COLOR_BLACK1;
    self.personalSignTV.font = FONT_17;
    self.personalSignTV.delegate = self;
    [self.view addSubview:self.personalSignTV];
    
    self.blueLine = [[UIImageView alloc]initWithFrame:CGRectMake(5, self.personalSignTV.frame.origin.y + self.personalSignTV.frame.size.height, self.view.frame.size.width - 5*2, 10)];
    self.blueLine.image = [UIImage imageNamed:@"blueLine.png"];
    [self.view insertSubview:self.blueLine belowSubview:self.personalSignTV];
    
    self.tipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.blueLine.frame.origin.y + self.blueLine.frame.size.height, self.view.frame.size.width, 20)];
    self.tipLab.textAlignment = NSTextAlignmentRight;
    self.tipLab.textColor = COLOR_GRAY1;
    self.tipLab.font = FONT_15;
    self.tipLab.text = [NSString stringWithFormat:@"限制%d个字以内", NUMBEROFTEXT+1];
    [self.view addSubview:self.tipLab];
}

#pragma mark- UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > NUMBEROFTEXT) {
        textView.text = [textView.text substringToIndex:NUMBEROFTEXT];
    }
    CGFloat height_tv = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, CGFLOAT_MAX)].height;
    if (height_tv > 30) {
        self.personalSignTV.frame = CGRectMake(self.personalSignTV.frame.origin.x, self.personalSignTV.frame.origin.y, self.personalSignTV.frame.size.width, height_tv);
        self.blueLine.frame = CGRectMake(self.blueLine.frame.origin.x, self.personalSignTV.frame.origin.y + self.personalSignTV.frame.size.height, self.blueLine.frame.size.width, self.blueLine.frame.size.height);
        self.tipLab.frame = CGRectMake(self.tipLab.frame.origin.x, self.blueLine.frame.origin.y + self.blueLine.frame.size.height, self.tipLab.frame.size.width, self.tipLab.frame.size.height);
    }else if (height_tv <= 30) {
        self.personalSignTV.frame = CGRectMake(self.personalSignTV.frame.origin.x, self.personalSignTV.frame.origin.y, self.personalSignTV.frame.size.width, 30);
        self.blueLine.frame = CGRectMake(self.blueLine.frame.origin.x, self.personalSignTV.frame.origin.y + self.personalSignTV.frame.size.height, self.blueLine.frame.size.width, self.blueLine.frame.size.height);
        self.tipLab.frame = CGRectMake(self.tipLab.frame.origin.x, self.blueLine.frame.origin.y + self.blueLine.frame.size.height, self.tipLab.frame.size.width, self.tipLab.frame.size.height);
    }
}

//点击了 完成 按钮
-(void)clickedDoneButton:(UIButton* )sender {
    if (self.personalSignTV.text.length <= 32) {
        NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/user/modifyPersonalizedSignature.do"];
        NSString* argumentStr = [NSString stringWithFormat:@"myId%ld&apiKey=%@&personalizedSignature=%@", USERID, APIKEY, self.personalSignTV.text];
        [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
            NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"jsonDic=%@", jsonDic);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([jsonDic[@"status"]integerValue] == 1) {
                    if (self.returnTextBlock != nil) {
                        self.returnTextBlock(self.personalSignTV.text);
                    }
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
    }
}

-(void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
