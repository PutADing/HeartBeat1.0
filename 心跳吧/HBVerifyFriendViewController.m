//
//  HBVerifyFriendViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/28.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBVerifyFriendViewController.h"
#import "HBTool.h"

@interface HBVerifyFriendViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong)UIView* infoView;//用户信息 视图
@property (nonatomic, strong)UIImageView* headIV;//头像
@property (nonatomic, strong)UILabel* nickLab;//昵称
@property (nonatomic, strong)UILabel* xinTiaoLab;//心跳号
@property (nonatomic, strong)UILabel* detailInfoLab;//昵称 对方添加你为好友
@property (nonatomic, strong)UIButton* yesBtn;//通过验证 按钮
@property (nonatomic, strong)UIButton* noBtn;//忽略 按钮

@end

@implementation HBVerifyFriendViewController

//头像距离左的间距
#define SPACE_X_IMAGE 10
//通过验证 忽略 按钮 宽高
#define WIDTH_BUTTON (self.view.frame.size.width/3)
#define HEIGHT_BUTTON 35

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友验证";
    self.view.backgroundColor = BACKGROUNGCOLOR_GRAY1;
    
    self.infoView = [self createInfoViewWithY:NAVIGATIOINBARHEIGHT AndHeight:100];
    [self.view addSubview:self.infoView];
    
    if (self.status == HBNewFriendRequestVerify) {
        self.yesBtn = [self createButtonWithX:self.view.frame.size.width/9 AndY:self.infoView.frame.origin.y + self.infoView.frame.size.height + 15 AndWidth:WIDTH_BUTTON AndHeight:HEIGHT_BUTTON AndTitle:@"通过验证"];
        [self.view addSubview:self.yesBtn];
        
        self.noBtn = [self createButtonWithX:self.view.frame.size.width/9*5 AndY:self.yesBtn.frame.origin.y AndWidth:WIDTH_BUTTON AndHeight:HEIGHT_BUTTON AndTitle:@"忽略"];
        [self.view addSubview:self.noBtn];
    }
    
}

//创建 昵称 心跳号 添加你为好友 视图
-(UIView* )createInfoViewWithY:(CGFloat )origin_y AndHeight:(CGFloat )frame_height {
    UIView* vi = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, frame_height)];
    vi.backgroundColor = COLOR_WHITE1;
    
    self.headIV = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_X_IMAGE, SPACE_X_IMAGE, 40, 40)];
    self.headIV.image = self.headImage;
    self.headIV.layer.cornerRadius = self.headIV.frame.size.width/2;
    self.headIV.layer.masksToBounds = YES;
    [vi addSubview:self.headIV];
    
    self.nickLab = [[UILabel alloc]initWithFrame:CGRectMake(self.headIV.frame.size.width + SPACE_X_IMAGE*2, self.headIV.frame.origin.y, vi.frame.size.width - self.headIV.frame.size.width - SPACE_X_IMAGE*3, 20)];
    self.nickLab.font = FONT_17;
    self.nickLab.text = self.user.nickName;
    self.nickLab.textColor = COLOR_BLACK1;
    [vi addSubview:self.nickLab];
    
    self.xinTiaoLab = [[UILabel alloc]initWithFrame:CGRectMake(self.nickLab.frame.origin.x, self.nickLab.frame.origin.y + self.nickLab.frame.size.height, self.nickLab.frame.size.width, self.nickLab.frame.size.height)];
    self.xinTiaoLab.text = self.user.heartBeatNumber;
    self.xinTiaoLab.textColor = COLOR_GRAY1;
    self.xinTiaoLab.font = FONT_17;
    [vi addSubview:self.xinTiaoLab];
    
    UIView* spaceLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.headIV.frame.origin.y + self.headIV.frame.size.height + SPACE_X_IMAGE, vi.frame.size.width, 10)];
    spaceLineView.backgroundColor = self.view.backgroundColor;
    [vi addSubview:spaceLineView];
    
    self.detailInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_X_IMAGE, spaceLineView.frame.origin.y + spaceLineView.frame.size.height, vi.frame.size.width - SPACE_X_IMAGE*2, 20)];
    self.detailInfoLab.text = self.descriptionStr;
    self.detailInfoLab.textColor = COLOR_GRAY1;
    self.detailInfoLab.font = FONT_17;
    [vi addSubview:self.detailInfoLab];
    
    return vi;
}

//创建 通过验证 忽略 按钮
-(UIButton* )createButtonWithX:(CGFloat )origin_x AndY:(CGFloat )origin_y AndWidth:(CGFloat )frame_width AndHeight:(CGFloat )frame_height AndTitle:(NSString* )titleString {
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(origin_x, origin_y, frame_width, frame_height)];
    btn.backgroundColor = COLOR_BLUE1;
    [btn setTitle:titleString forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickedYesOrNoButton:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    return btn;
}

-(void)clickedYesOrNoButton:(UIButton* )sender {
    if (sender == self.yesBtn) {
        
        [self verifyFriendWithType:1];
    }else if (sender == self.noBtn) {
        
        [self verifyFriendWithType:0];
    }
}

//同意添加好友
-(void)verifyFriendWithType:(NSInteger )type {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/friends/verifyFriend.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"reqId=%ld&type=%ld&myId=%ld&apiKey=%@", self.user.userID, type, USERID, APIKEY];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
//        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"resultStr=%@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"操作成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                av.tag = 100;
                [av show];
                
                self.yesBtn.hidden = YES;
                self.noBtn.hidden = YES;
                if (type == 0) {
                    self.status = HBNewFriendRequestFailed;
                }else if (type == 1) {
                    self.status = HBNewFriendRequestSucceed;
                }
            }
        });
    }];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)returnStatus:(void (^)(HBNewFriendRequestStatus))block {
    block(self.status);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
