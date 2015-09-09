//
//  MyHopeViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/24.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBMyHopeViewController.h"
#import "HBMyZhuanGuiViewController.h"
#import "HBTool.h"
#import "HBChangeMyInfoViewController.h"
#import "HBMyNumberViewController.h"
#import "UIImageView+WebCache.h"
#import "HBGoods.h"
#import "HBSendVerifyInfoViewController.h"

@interface HBMyHopeViewController ()
@property (nonatomic, strong)UIImageView* headIV;//头像
@property (nonatomic, strong)UILabel* nickLabel;//昵称
@property (nonatomic, strong)UILabel* xinTiaoLabel;//心跳号
@property (nonatomic, strong)UIImageView* jianTouIV;//箭头 当显示自己的信息时可编辑 显示别人信息时不可编辑 需隐藏
@property (nonatomic, strong)UILabel* placeLabel;//地区
@property (nonatomic, strong)UILabel* xinTiaoNumber;//心跳指数
@property (nonatomic, strong)UILabel* personalSign;//个性签名
@property (nonatomic, strong)UIImageView* zhuanGuiIV;//个人专柜图片
@property (nonatomic, strong)UIButton* headBtn;//头像、昵称、心跳号
@property (nonatomic, strong)UIView* infoView;//地区、心跳指数等 视图
@property (nonatomic, strong)UIButton* zhuanGuiBtn;//专柜 视图
@property (nonatomic, strong)UIButton* addFriendsBtn;//加为好友 按钮

@end

@implementation HBMyHopeViewController

//headBtn高
#define HEIGHT_HEADBUTTON 70
//头像 宽高
#define WIDTH_HEADIV 50
//行高
#define LINE_HEIGHT 50
//label距离左间距 宽
#define SPACE_LABEL 10
#define WIDTH_LABEL 75

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人主页";
    self.view.backgroundColor = BACKGROUNGCOLOR_GRAY1;
    
    self.headBtn = [self createHeadButtonWithRect:CGRectMake(0, NAVIGATIOINBARHEIGHT, self.view.frame.size.width, HEIGHT_HEADBUTTON)];
    [self.view addSubview:self.headBtn];
    
    
    self.infoView = [self createInfoViewWithRect:CGRectMake(0, self.headBtn.frame.origin.y+self.headBtn.frame.size.height, self.view.frame.size.width, LINE_HEIGHT*3)];
    [self.view addSubview:self.infoView];
    
    self.zhuanGuiBtn = [self createZhuanGuiButtonWithY:self.infoView.frame.origin.y+self.infoView.frame.size.height+15 AndHeight:LINE_HEIGHT];
    [self.view addSubview:self.zhuanGuiBtn];
    
    [self createAddFriendButtonWithRect:CGRectMake(self.view.frame.size.width/4, self.zhuanGuiBtn.frame.origin.y + self.zhuanGuiBtn.frame.size.height + 15, self.view.frame.size.width/2, 35)];
    
    [self initDatas];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getIsFriendFromService];
}

//创建 头像 昵称 心跳号 视图按钮
-(UIButton* )createHeadButtonWithRect:(CGRect )rect {
    UIButton* btn = [[UIButton alloc]initWithFrame:rect];
    [btn addTarget:self action:@selector(clickedHeadViewButon:) forControlEvents:UIControlEventTouchUpInside];
    
//    头像
    self.headIV = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_LABEL, SPACE_LABEL, WIDTH_HEADIV, WIDTH_HEADIV)];
    [self.headIV.layer setCornerRadius:CGRectGetHeight(self.headIV.bounds)/2];
    self.headIV.layer.masksToBounds = YES;
    [btn addSubview:self.headIV];
    
//    昵称
    self.nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_LABEL*2 + WIDTH_HEADIV, self.headIV.frame.origin.y, self.view.frame.size.width - SPACE_LABEL*2 - WIDTH_HEADIV - 16, WIDTH_HEADIV/2)];
    self.nickLabel.textColor = COLOR_BLACK1;
    self.nickLabel.font = FONT_17;
    [btn addSubview:self.nickLabel];
    
//    心跳号
    self.xinTiaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nickLabel.frame.origin.x, self.nickLabel.frame.origin.y + self.nickLabel.frame.size.height, self.nickLabel.frame.size.width, self.nickLabel.frame.size.height)];
    self.xinTiaoLabel.textColor = COLOR_GRAY1;
    self.xinTiaoLabel.font = FONT_15;
    [btn addSubview:self.xinTiaoLabel];
    
//    箭头
    self.jianTouIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 16, (HEIGHT_HEADBUTTON - 16)/2, 16, 16)];
    self.jianTouIV.image = [UIImage imageNamed:@"jianTou.png"];
    [btn addSubview:self.jianTouIV];
    
    return btn;
}

//创建infoView
-(UIView* )createInfoViewWithRect:(CGRect )rect {
    UIView* vi = [[UIView alloc]initWithFrame:rect];
    vi.backgroundColor = COLOR_WHITE1;
    
    NSArray* nameArray = @[@"心跳指数",@"地区",@"签名"];
    CGFloat origin_x = WIDTH_LABEL + SPACE_LABEL*2;
    CGFloat frame_width = self.view.frame.size.width - origin_x - SPACE_LABEL;
    for (int i = 0; i < 3; i++) {
        if (i == 0) {
            UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, LINE_HEIGHT)];
            [button addTarget:self action:@selector(clickedXinTiaoZhiShuButton:) forControlEvents:UIControlEventTouchUpInside];
            [vi addSubview:button];
            
            UILabel* lab = [self createLabelWithRect:CGRectMake(SPACE_LABEL, (LINE_HEIGHT - 20)/2, WIDTH_LABEL, 20) AndTextString:nameArray[i]];
            [button addSubview:lab];
            
            UIImageView* line = [self createLineImageViewWithRect:CGRectMake(0, LINE_HEIGHT - 1, self.view.frame.size.width, 1)];
            [button addSubview:line];
            
            self.xinTiaoNumber = [self createDisplayLabelWithRect:CGRectMake(origin_x, (LINE_HEIGHT - 20)/2, frame_width, 20)];
            [button addSubview:self.xinTiaoNumber];
            
        }else if (i == 1) {
            UILabel* lab = [self createLabelWithRect:CGRectMake(SPACE_LABEL, (LINE_HEIGHT - 20)/2 + LINE_HEIGHT, WIDTH_LABEL, 20) AndTextString:nameArray[i]];
            [vi addSubview:lab];
            
            UIImageView* line = [self createLineImageViewWithRect:CGRectMake(0, LINE_HEIGHT*2 - 1, self.view.frame.size.width, 1)];
            [vi addSubview:line];
            
            self.placeLabel = [self createDisplayLabelWithRect:CGRectMake(origin_x, LINE_HEIGHT + (LINE_HEIGHT - 20)/2, frame_width, 20)];
            [vi addSubview:self.placeLabel];
        }else if (i == 2) {
            UILabel* lab = [self createLabelWithRect:CGRectMake(SPACE_LABEL, (LINE_HEIGHT - 20)/2 + LINE_HEIGHT*2, WIDTH_LABEL, 20) AndTextString:nameArray[i]];
            [vi addSubview:lab];
            
            self.personalSign = [self createDisplayLabelWithRect:CGRectMake(origin_x, LINE_HEIGHT*2 + (LINE_HEIGHT - 20)/2, frame_width, 20)];
            [vi addSubview:self.personalSign];
        }
    }
    return vi;
}

//创建 心跳指数 地区 签名 label
-(UILabel* )createLabelWithRect:(CGRect )rect AndTextString:(NSString* )textStr {
    UILabel* lab = [[UILabel alloc]initWithFrame:rect];
    lab.text = textStr;
    lab.textColor = COLOR_BLACK1;
    lab.font = FONT_17;
    return lab;
}

//创建下划线
-(UIImageView* )createLineImageViewWithRect:(CGRect )rect {
    UIImageView* line = [[UIImageView alloc]initWithFrame:rect];
    line.image = [UIImage imageNamed:@"line.png"];
    return line;
}

//创建 placeLabel xinTiaoNumber personalSign
-(UILabel* )createDisplayLabelWithRect:(CGRect )rect {
    UILabel* lab = [[UILabel alloc]initWithFrame:rect];
    lab.textColor = COLOR_GRAY1;
    lab.font = FONT_17;
    lab.textAlignment = NSTextAlignmentRight;
    return lab;
}

//创建 个人专柜 按钮
-(UIButton* )createZhuanGuiButtonWithY:(CGFloat )origin_y AndHeight:(CGFloat )frame_height {
    CGFloat space_y = 15;//label距离上、下的距离
    CGFloat zhuanGuiIVHeight = 40;//个人专柜 图片大小为40*40
    
    UIButton* button_ZhuanGui = [[UIButton alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, frame_height)];
    button_ZhuanGui.backgroundColor = COLOR_WHITE1;
    [button_ZhuanGui addTarget:self action:@selector(clickedZhuanGuiButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* label_ZhuanGui = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_LABEL, space_y, 75, 20)];
    label_ZhuanGui.text = @"专柜";
    label_ZhuanGui.textColor = COLOR_BLACK1;
    label_ZhuanGui.font = FONT_17;
    [button_ZhuanGui addSubview:label_ZhuanGui];
    
    self.zhuanGuiIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - SPACE_LABEL - 40, 5, zhuanGuiIVHeight, zhuanGuiIVHeight)];
    [self.zhuanGuiIV.layer setCornerRadius:4];
    self.zhuanGuiIV.layer.masksToBounds = YES;
    [button_ZhuanGui addSubview:self.zhuanGuiIV];
    
    return button_ZhuanGui;
}

//创建 添加好友 按钮
-(void)createAddFriendButtonWithRect:(CGRect )rect {
    self.addFriendsBtn = [[UIButton alloc]initWithFrame:rect];
    [self.view addSubview:self.addFriendsBtn];
    self.addFriendsBtn.backgroundColor = COLOR_BLUE1;
    self.addFriendsBtn.titleLabel.font = FONT_20;
    [self.addFriendsBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    self.addFriendsBtn.layer.cornerRadius = 4;
    self.addFriendsBtn.layer.masksToBounds = YES;
    [self.addFriendsBtn addTarget:self action:@selector(clickedAddFriendButton:) forControlEvents:UIControlEventTouchUpInside];
    self.addFriendsBtn.hidden = YES;
}

//点击头像
-(void)clickedHeadViewButon:(UIButton* )sender {
    HBChangeMyInfoViewController* HBChangeMyInfoVC = [[HBChangeMyInfoViewController alloc]init];
    HBChangeMyInfoVC.headImage = self.headIV.image;
    HBChangeMyInfoVC.placeString = self.placeLabel.text;
    [self.navigationController pushViewController:HBChangeMyInfoVC animated:NO];
}

//点击 心跳指数 按钮
-(void)clickedXinTiaoZhiShuButton:(UIButton* )sender {
    HBMyNumberViewController* HBMyNumberVC = [[HBMyNumberViewController alloc]init];
    HBMyNumberVC.user = self.user;
    [self.navigationController pushViewController:HBMyNumberVC animated:NO];
}

//点击 个人专柜 按钮
-(void)clickedZhuanGuiButton:(UIButton* )sender {
    if (sender == self.zhuanGuiBtn) {
        HBMyZhuanGuiViewController* HBMyZhuanGuiVC = [[HBMyZhuanGuiViewController alloc]init];
        HBMyZhuanGuiVC.user = self.user;
        [self.navigationController pushViewController:HBMyZhuanGuiVC animated:NO];
    }
}

//初始化数据
-(void)initDatas {
    if (self.user.userID != USERID) {
        self.headBtn.enabled = NO;
        self.jianTouIV.hidden = YES;
    }
    //从服务器获取用户详细信息
    NSInteger userId = self.user.userID;
    NSString* urlStr_UserInfo = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/user/getUserDetailInfo.do"];
    NSString* argumentStr_UserInfo = [NSString stringWithFormat:@"myId=%ld&userId=%ld&apiKey=%@", USERID, userId, APIKEY];
    [self getDetailUserInfoFromServiceWithURLString:urlStr_UserInfo AndArgumentString:argumentStr_UserInfo];
    
    //从服务器获取该用户最近的物品
    NSString* urlStr_RectntGoods = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/goods/findRecentGoodsByUser.do"];
    NSString* argumentStr_RectntGoods = [NSString stringWithFormat:@"myId=%ld&userId=%ld&apiKey=%@&pageIndex=%d&pageSize=%d", USERID, userId, APIKEY, 0, 1];
    [self getRecentGoodsFromServiceWithURLString:urlStr_RectntGoods AndArgumentString:argumentStr_RectntGoods];
}

//从服务器获取用户详细信息
-(void)getDetailUserInfoFromServiceWithURLString:(NSString* )urlStr AndArgumentString:(NSString*)argumentStr {
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* result_String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"result_String:%@", result_String);
        
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                NSDictionary* userDetailInfoDic = jsonDic[@"userDetailInfo"];
                self.nickLabel.text = [NSString stringWithFormat:@"%@", self.user.nickName];
                self.xinTiaoLabel.text = [NSString stringWithFormat:@"%@", self.user.heartBeatNumber];
                self.xinTiaoNumber.text = [NSString stringWithFormat:@"%@", userDetailInfoDic[@"comprehensiveIndex"]];
                if (self.user.avatar != nil) {
                    NSURL* imageURL = [NSURL URLWithString:self.user.avatar];
                    [self.headIV sd_setImageWithURL:imageURL placeholderImage:DEFAULT_HEADIMAGE options:SDWebImageRetryFailed];
                }
                if (self.user.personalizedSignature != nil) {
                    self.personalSign.text = self.user.personalizedSignature;
                }
                if (![userDetailInfoDic[@"province"] isKindOfClass:[NSNull class]] && ![userDetailInfoDic[@"city"] isKindOfClass:[NSNull class]]) {
                    NSDictionary* provinceDic = userDetailInfoDic[@"province"];
                    NSDictionary* cityDic = userDetailInfoDic[@"city"];
                    self.placeLabel.text = [NSString stringWithFormat:@"%@%@", provinceDic[@"provinceName"], cityDic[@"cityName"]];
                }
                
            }else {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取用户信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [av show];
            }
        });
    }];
}

//从服务器获取该用户最近的物品
-(void)getRecentGoodsFromServiceWithURLString:(NSString* )urlStr AndArgumentString:(NSString*)argumentStr {
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                HBGoods* goods = [[HBGoods alloc]init];
                NSDictionary* goodsDic = jsonDic[@"goods"];
                goods.goodsImageAddrList = goodsDic[@"goodsImageAddrList"];
                goods.goodsId = [goodsDic[@"goodsId"]integerValue];
                
                if (goods.goodsImageAddrList.count > 0) {
                    NSURL* imageURL = [NSURL URLWithString:goods.goodsImageAddrList[0]];
                    [self.zhuanGuiIV sd_setImageWithURL:imageURL placeholderImage:DEFAULT_HEADIMAGE options:SDWebImageRetryFailed];
                }
            }else if ([jsonDic[@"status"]integerValue] == -1) {
                NSLog(@"查找近期分享的物品失败");
                self.zhuanGuiIV.image = DEFAULT_HEADIMAGE;
            }else if ([jsonDic[@"status"]integerValue] == -2) {
                NSLog(@"近期分享的物品为空");
                self.zhuanGuiIV.image = DEFAULT_HEADIMAGE;
            }
        });
    }];
}

//判断是否为好友 若不为好友 则显示 添加好友 按钮 否则隐藏该按钮
-(void)getIsFriendFromService {
    //判断是否为好友
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/friends/isMyFriend.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"myId=%ld&frId=%ld&apiKey=%@", USERID, self.user.userID, APIKEY];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                self.addFriendsBtn.hidden = YES;
            }else if ([jsonDic[@"status"]integerValue] == -1) {
                self.addFriendsBtn.hidden = YES;
            }else if ([jsonDic[@"status"]integerValue] == -2) {
                if (self.user.userID == USERID) {
                    self.addFriendsBtn.hidden = YES;
                }else {
                    self.addFriendsBtn.hidden = NO;
                }
            }
        });
    }];
}

//点击 添加好友 按钮
-(void)clickedAddFriendButton:(UIButton* )sender {
    if (sender == self.addFriendsBtn) {
        NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/friends/addFriend.do"];
        NSString* argumentStr = [NSString stringWithFormat:@"myId=%ld&frId=%ld&apiKey=%@&description=", USERID, self.user.userID, APIKEY];
        [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
            NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"addFriend_resultStr=%@", resultStr);
            NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"jsonDic=%@", jsonDic);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([jsonDic[@"status"]integerValue] == 1) {
                    [self showAlertViewWithMessageString:@"添加好友成功"];
                }else if ([jsonDic[@"status"]integerValue] == -1) {
                    [self showAlertViewWithMessageString:@"添加好友失败"];
                }else if ([jsonDic[@"status"]integerValue] == -2) {
                    [self showAlertViewWithMessageString:@"对方已经是自己的好友"];
                }else if ([jsonDic[@"status"]integerValue] == -3) {
                    [self showAlertViewWithMessageString:@"不能添加自己为好友"];
                }else if ([jsonDic[@"status"]integerValue] == -4) {
                    [self showAlertViewWithMessageString:@"对方已设置为不允许添加"];
                }else if ([jsonDic[@"status"]integerValue] == -5) {
                    //跳转至HBSendVerifyInfoViewController（发送验证信息）页面
                    
                    HBSendVerifyInfoViewController* HBSendVerifyInfoVC = [[HBSendVerifyInfoViewController alloc]init];
                    HBSendVerifyInfoVC.user = self.user;
                    HBSendVerifyInfoVC.headImage = self.headIV.image;
                    [self.navigationController pushViewController:HBSendVerifyInfoVC animated:NO];
                }
            });
        }];
    }
}

//显示alertView
-(void)showAlertViewWithMessageString:(NSString* )messageStr {
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:messageStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [av show];
}

@end
