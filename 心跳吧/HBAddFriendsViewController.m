//
//  HBAddFriendsViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/23.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBAddFriendsViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "HBSearchFriendViewController.h"

@interface HBAddFriendsViewController () <ISSShareViewDelegate>
@property (nonatomic, strong)UIButton* searchBtn;
@property (nonatomic, strong)UIView* searchView;
@property (nonatomic, strong)UIView* shareView;

@end

@implementation HBAddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加朋友";
    [self addSearchViewWithY:NAVIGATIOINBARHEIGHT];
    [self addShareView];
    
}

//创建搜索这一部分视图
-(void)addSearchViewWithY:(CGFloat )origin_y {
    CGFloat searchViewHeight = 80;//搜索这一部分视图的高度
    CGFloat space_x = 5;//"搜索"图标距离左的距离
    CGFloat space_y = 20;//"搜索"图标距离上的距离
    CGFloat width_imageView = 40;//"搜索"图标宽高
    self.searchView = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, searchViewHeight)];
    [self.view addSubview:self.searchView];
    //"心跳号/手机号"按钮
    self.searchBtn = [[UIButton alloc]initWithFrame:self.searchView.bounds];
    [self.searchBtn addTarget:self action:@selector(clickedSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView addSubview:self.searchBtn];
    //"搜索"图标
    UIImageView* searchIV = [[UIImageView alloc]initWithFrame:CGRectMake(space_x, space_y, width_imageView, width_imageView)];
    searchIV.image = [UIImage imageNamed:@"HB_Search.png"];
    [self.searchBtn addSubview:searchIV];
    //"心跳号/手机号"文字
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(space_x*2 + searchIV.frame.size.width, space_y + (width_imageView - 20)/2, self.searchBtn.frame.size.width - space_x*3 - searchIV.frame.size.width, 20)];
    lab.text = @"心跳号/手机号";
    lab.textColor = COLOR_GRAY1;
    lab.font = FONT_17;
    [self.searchBtn addSubview:lab];

    //蓝色线条
    UIImageView* lineIV = [[UIImageView alloc]initWithFrame:CGRectMake(space_x, searchIV.frame.origin.y + searchIV.frame.size.height, self.view.frame.size.width - space_x*2, 2)];
    lineIV.image = [UIImage imageNamed:@"blueLine.png"];
    [self.searchView addSubview:lineIV];
}

//创建"邀请微信好友"、"邀请QQ好友"、"分享我的心跳号"这一部分视图
-(void)addShareView {
    CGFloat lineHeight = 50;//每一行的高度
    CGFloat space = 5;//图片距离上、下、左的距离
    self.shareView = [[UIView alloc]initWithFrame:CGRectMake(0, self.searchView.frame.origin.y + self.searchView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchView.frame.origin.y - self.searchView.frame.size.height)];
    [self.view addSubview:self.shareView];
    
    NSArray* textArr = @[@"邀请微信好友",@"邀请QQ好友",@"分享我的心跳号到"];//文字数组
    NSArray* pictureArr = @[@"weiXin.png",@"QQ.png",@"shareHB.png"];//图片名称数组
    for (int i = 0; i < 3; i++) {
        UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(0, i*lineHeight, self.view.frame.size.width, lineHeight)];
        button.tag = 10+i;
        [button addTarget:self action:@selector(clickedShareViewButton:) forControlEvents:UIControlEventTouchUpInside];//添加点击事件
        [self.shareView addSubview:button];
        //图片
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(space, space, lineHeight-space*2, lineHeight-space*2)];
        imageView.image = [UIImage imageNamed:pictureArr[i]];
        [button addSubview:imageView];
        //文字
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(lineHeight + space, 15, 140, 20)];
        label.text = textArr[i];
        label.textColor = COLOR_BLACK1;
        label.font = FONT_17;
        [button addSubview:label];
        //线条
        UIImageView* lineIV = [[UIImageView alloc]initWithFrame:CGRectMake(space, lineHeight - 1, self.view.frame.size.width - space*2, 1)];
        lineIV.image = [UIImage imageNamed:@"line.png"];
        [button addSubview:lineIV];
        if (i == 2) {
            NSArray* shareImagesArr = @[@"weiXin.png", @"QQ.png", @"weiBo.png"];
            for (int j = 0; j < 3; j++) {
                UIImageView* iv = [[UIImageView alloc]initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 40*j, (lineHeight - 40)/2, 40, 40)];
                iv.image = [UIImage imageNamed:shareImagesArr[j]];
                [button addSubview:iv];
            }
        }
    }
}

-(void)clickedSearchButton:(UIButton* )sender {
    if (sender == self.searchBtn) {
        HBSearchFriendViewController* HBSFVC = [[HBSearchFriendViewController alloc]init];
        [self.navigationController pushViewController:HBSFVC animated:NO];        
    }
}

-(void)clickedShareViewButton:(UIButton* )sender {
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon-60@2x" ofType:@"png"];
    //构造分享微信好友、QQ好友内容
    id<ISSContent> publishContent_Friend = [ShareSDK content:@"邀请您来闲置共享应用心跳吧，一起玩心跳。www.xintiao8.com"
                                              defaultContent:@"心跳吧分享"
                                                       image:nil
                                                       title:nil
                                                         url:@"http://www.xintiao8.com"
                                                 description:@"心跳吧分享"
                                                   mediaType:SSPublishContentMediaTypeNews];
    //构造分享微信朋友圈、QQ空间、微博内容
    id<ISSContent> publishContent_Public = [ShareSDK content:[NSString stringWithFormat:@"我在闲置物品共享应用心跳吧，快来加我心跳号：%@，一起玩心跳哟。www.xintiao8.com", HEARTBEATNUMBER]
                                       defaultContent:@"心跳吧分享"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"寻找小伙伴"
                                                  url:@"http://www.xintiao8.com"
                                          description:@"心跳吧分享"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    switch (sender.tag) {
        case 10://邀请微信好友
        {
            //自定义UI分享
            [ShareSDK shareContent:publishContent_Friend
                              type:ShareTypeWeixiSession
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                }
                                
                            }];
        }
            break;
        case 11://邀请QQ好友
        {
            //自定义UI分享
            [ShareSDK shareContent:publishContent_Friend
                              type:ShareTypeQQ
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                }
                                
                            }];
        }
            break;
        case 12://分享我的心跳号到
        {
            //创建弹出菜单容器
            id<ISSContainer> container = [ShareSDK container];
            [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
            //创建自定义分享列表
            NSArray *shareList = [ShareSDK getShareListWithType:
                                  ShareTypeWeixiTimeline,//微信朋友圈
                                  ShareTypeWeixiSession,//微信好友
                                  ShareTypeQQ,//QQ好友
                                  ShareTypeQQSpace,//QQ空间
                                  ShareTypeSinaWeibo,//新浪微博
                                  nil];
            //弹出分享菜单
            [ShareSDK showShareActionSheet:container
                                 shareList:shareList
                                   content:publishContent_Public
                             statusBarTips:YES
                               authOptions:nil
                              shareOptions:nil
                                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                        
                                        if (state == SSResponseStateSuccess)
                                        {
                                            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                        }
                                        else if (state == SSResponseStateFail)
                                        {
                                            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                        }
                                    }];
        }
            break;
        default:
            break;
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
