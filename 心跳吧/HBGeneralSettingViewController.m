//
//  HBGeneralSettingViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/24.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBGeneralSettingViewController.h"
#import "HBTool.h"
#import "AppDelegate.h"

@interface HBGeneralSettingViewController ()
@property (nonatomic, strong)UISwitch* voiceSwitch;//声音
@property (nonatomic, strong)UISwitch* shakeSwitch;//振动
@property (nonatomic, strong)UISwitch* verifySwitch;//添加好友需要验证

@end

@implementation HBGeneralSettingViewController

//label距离左 间距
#define SPACE_LABEL 10
//行高
#define LINEHEIGHT 50   //每行的高度

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通用设置";
    self.view.backgroundColor = BACKGROUNGCOLOR_GRAY1;
    
    [self initSubviewsWithY:NAVIGATIOINBARHEIGHT];
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (![delegate isFirstRunCount]) {
        BOOL voiceSwitch = [defaults boolForKey:@"voiceSwitch"];
        [self.voiceSwitch setOn:voiceSwitch animated:YES];
        
        BOOL shakeSwitch = [defaults boolForKey:@"shakeSwitch"];
        [self.shakeSwitch setOn:shakeSwitch animated:YES];
        
        BOOL verifySwitch = [defaults boolForKey:@"verifySwitch"];
        [self.verifySwitch setOn:verifySwitch animated:YES];
    }else {
        [defaults setBool:YES forKey:@"voiceSwitch"];
        [defaults setBool:YES forKey:@"shakeSwitch"];
        [defaults setBool:YES forKey:@"verifySwitch"];
        
        [self.voiceSwitch setOn:YES animated:YES];
        [self.shakeSwitch setOn:YES animated:YES];
        [self.verifySwitch setOn:YES animated:YES];
    }
    
    [self getVoiceSetting];
    [self getShakeSetting];
    [self getVerifyFriendSetting];
}

//获取系统设置
-(void)getVoiceSetting {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/setting/getVoice.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"myId=%ld&apiKey=%@", USERID, APIKEY];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                if ([jsonDic[@"value"]integerValue] == 1) {
                    [self.voiceSwitch setOn:YES animated:YES];
                    [defaults setBool:YES forKey:@"voiceSwitch"];
                }else {
                    [self.voiceSwitch setOn:NO animated:YES];
                    [defaults setBool:YES forKey:@"shakeSwitch"];
                }
                [defaults synchronize];
            }
        });
    }];
}

//获取系统设置
-(void)getShakeSetting {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/setting/getShake.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"myId=%ld&apiKey=%@", USERID, APIKEY];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                if ([jsonDic[@"value"]integerValue] == 1) {
                    [self.shakeSwitch setOn:YES animated:YES];
                    [defaults setBool:YES forKey:@"shakeSwitch"];
                }else {
                    [self.shakeSwitch setOn:NO animated:YES];
                    [defaults setBool:YES forKey:@"shakeSwitch"];
                }
                [defaults synchronize];
            }
        });
    }];
}

//获取系统设置
-(void)getVerifyFriendSetting {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/setting/getVerifyFriend.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"myId=%ld&apiKey=%@", USERID, APIKEY];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                if ([jsonDic[@"value"]integerValue] == 1) {
                    [self.verifySwitch setOn:YES animated:YES];
                    [defaults setBool:YES forKey:@"verifySwitch"];
                }else {
                    [self.verifySwitch setOn:NO animated:YES];
                    [defaults setBool:YES forKey:@"verifySwitch"];
                }
                [defaults synchronize];
            }
        });
    }];
}

//初始化视图
-(void)initSubviewsWithY:(CGFloat )origin_y {
    NSArray* textArr = @[@"声音", @"振动", @"添加好友需要验证"];
    for (int i = 0; i < 3; i++) {
        UIView* cellView = [self createCellViewWithY:origin_y + LINEHEIGHT*i AndString:textArr[i]];
        [self.view addSubview:cellView];
        
        if (i == 0) {
            self.voiceSwitch = [self createSwitch];//UISwitch的size固定为51*31，改变不了
            [cellView addSubview:self.voiceSwitch];
        }else if (i == 1) {
            self.shakeSwitch = [self createSwitch];
            [cellView addSubview:self.shakeSwitch];
        }else if (i == 2) {
            self.verifySwitch = [self createSwitch];
            [cellView addSubview:self.verifySwitch];
        }
    }
}

//创建单元行
-(UIView* )createCellViewWithY:(CGFloat )origin_y AndString:(NSString* )nameString {
    UIView* tempView = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, LINEHEIGHT)];
    tempView.backgroundColor = COLOR_WHITE1;
    
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_LABEL, (LINEHEIGHT-20)/2, 140, 20)];
    lab.text = nameString;
    lab.textColor = COLOR_BLACK1;
    lab.font = FONT_17;
    [tempView addSubview:lab];
    
    UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, LINEHEIGHT - 1, self.view.frame.size.width, 1)];
    line.image = [UIImage imageNamed:@"line.png"];
    [tempView addSubview:line];
    
    return tempView;
}

//创建switch
-(UISwitch* )createSwitch {
    UISwitch* tempSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width - SPACE_LABEL - 51, (LINEHEIGHT - 31)/2, 51, 31)];
    tempSwitch.onTintColor = COLOR_BLUE1;
    [tempSwitch addTarget:self action:@selector(clickedSwitch:) forControlEvents:UIControlEventValueChanged];
    return tempSwitch;
}

//点击switch
-(void)clickedSwitch:(UISwitch* )sender {
    if (sender == self.voiceSwitch) {
        [self setVoiceSwitchState];
    }else if (sender == self.shakeSwitch) {
        [self setShakeSwitchState];
    }else if (sender == self.verifySwitch) {
        [self setVerifySwitchState];
    }
}

//设置声音
-(void)setVoiceSwitchState {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/setting/setVoice.do"];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    BOOL voiceSwitch = [defaults boolForKey:@"voiceSwitch"];
    NSString* argumentStr = [NSString stringWithFormat:@"flag=%d&myId=%ld&apiKey=%@", !voiceSwitch, USERID, APIKEY];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                [defaults setBool:!voiceSwitch forKey:@"voiceSwitch"];
                [defaults synchronize];
            }
        });
    }];
}

//设置振动
-(void)setShakeSwitchState {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/setting/setShake.do"];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    BOOL shakeSwitch = [defaults boolForKey:@"shakeSwitch"];
    NSString* argumentStr = [NSString stringWithFormat:@"flag=%d&myId=%ld&apiKey=%@", !shakeSwitch, USERID, APIKEY];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                [defaults setBool:!shakeSwitch forKey:@"shakeSwitch"];
                [defaults synchronize];
            }
        });
    }];
}

//设置添加朋友需要验证
-(void)setVerifySwitchState {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/setting/setVerifyFriend.do"];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    BOOL verifySwitch = [defaults boolForKey:@"verifySwitch"];
    NSString* argumentStr = [NSString stringWithFormat:@"flag=%d&myId=%ld&apiKey=%@", !verifySwitch, USERID, APIKEY];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                [defaults setBool:!verifySwitch forKey:@"verifySwitch"];
                [defaults synchronize];
            }
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
