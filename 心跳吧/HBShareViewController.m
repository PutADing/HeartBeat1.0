//
//  HBShareViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/2/2.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBShareViewController.h"
#import "HBTool.h"
#import "HBContactsTableViewCell.h"
#import "HBAddFriendsViewController.h"
#import "AppDelegate.h"
#import "HBContactModel.h"
#import <UIImageView+WebCache.h>
#import "HBNewFriendsViewController.h"
#import "HBAlertView.h"

@interface HBShareViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong)UILabel* nickNameLab;//显示昵称
@property (nonatomic, strong)UIImageView* headImageView;
@property (nonatomic, strong)UIButton* moreBtn;//“...”按钮
@property (nonatomic, strong)UIButton* addBtn;//“+”按钮
@property (nonatomic, strong)UIView* buttonView;//共享 通讯录 按钮视图
@property (nonatomic, strong)UIButton* shareBtn;//“共享”按钮
@property (nonatomic, strong)UIButton* contactsBtn;//“通讯录”按钮
@property (nonatomic, strong)CALayer* blueLayer;//蓝色 线
@property (nonatomic, strong)CALayer* grayLayer;//灰色 线
@property (nonatomic, strong)UIView* moreView;//点击“...”时出现的视图
@property (nonatomic, strong)UIView* addView;//点击“+”时出现的视图
@property (nonatomic, strong)UIView* shareView;//"共享"视图
@property (nonatomic, strong)UIView* contactsView;//"通讯录"视图
@property (nonatomic, strong)UITableView* tableView;//联系人tableView
@property (nonatomic, strong)NSMutableArray* sectionHeadsKeys;//tableView的分区头标题
@property (nonatomic, strong)NSMutableArray* sortedArrayForArray;//按昵称整理后的数据
@property (nonatomic, assign)NSInteger pageIndex;//
@property (nonatomic, assign)NSInteger pageSize;//

@property (nonatomic, strong)CALayer* share_RedDot;//共享 右上角 红点
@property (nonatomic, strong)CALayer* contacts_RedDot;//通讯录 右上角 红点

@end

@implementation HBShareViewController

//行高 新的朋友、添加朋友按钮的高度也为行高
#define LINE_HEIGHT 50
//头像宽高
#define WIDTH_HEADIV 40
//头像距离左、右间距
#define SPACE_LEFT_HEADIV 10
//头像距离上、下间距
#define SPACE_UP_HEADIV 5
//共享 通讯录 按钮高
#define HEIGHT_BUTTON LINE_HEIGHT

static NSString* identifier = @"cell";

//设置状态栏为亮色
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[HBTool shareTool]isIOS7_Later]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }

    self.view.backgroundColor = COLOR_WHITE1;
    [self createNavigationItems];
    [self createButtonViewWithY:NAVIGATIOINBARHEIGHT];
    [self createMoreViewAndAddViewWithY:NAVIGATIOINBARHEIGHT];
    
    self.sectionHeadsKeys = [NSMutableArray array];
    self.sortedArrayForArray = [NSMutableArray array];
    
    
    self.pageIndex = 0;
    self.pageSize = 27;
//    若第一次运行程序 从服务器获取所有好友列表 否则从沙盒中取
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"runCount"] > 0) {
        NSArray* arr = [[HBContactModel createContactModel]getContactsArrayWithPageSize:self.pageSize AndPageIndex:self.pageIndex];
        
        if (arr.count > 0) {
            [self.sortedArrayForArray addObjectsFromArray:arr];
        }else {
            NSString* argumentStr = [NSString stringWithFormat:@"condition=%@&pageIndex=%ld&pageSize=%ld&sortStyle=%@&siftCondition=%@&siftValue=%@&myId=%ld&apiKey=%@", @"", self.pageIndex, self.pageSize, @"", @"", @"", USERID, APIKEY];
            [self getContactsFromServiceWithArgumentStr:argumentStr];
        }
        
        
    }else {
        NSString* argumentStr = [NSString stringWithFormat:@"condition=%@&pageIndex=%ld&pageSize=%ld&sortStyle=%@&siftCondition=%@&siftValue=%@&myId=%ld&apiKey=%@", @"", self.pageIndex, self.pageSize, @"", @"", @"", USERID, APIKEY];
        [self getContactsFromServiceWithArgumentStr:argumentStr];
    }
    
    
    [self uploadClientIdToService];//上传clientId给服务器

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"shareRedDot"] > 0) {
        [self showShareRedDot];
    }
    if ([defaults integerForKey:@"contactsRedDot"] > 0) {
        [self showContactsRedDot];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger runCount = [defaults integerForKey:@"runCount"];
    if (runCount > 0) {
        if (runCount < INT32_MAX) {
            runCount++;
        }else {
            runCount = 1;
        }
    }
    [defaults setInteger:runCount forKey:@"runCount"];
    
    NSString* avatar = [defaults objectForKey:@"avatar"];
    
    NSURL* imageURL;
    if (![avatar isKindOfClass:[NSNull class]]) {
        if (![avatar isEqualToString:@"null  "] && ![avatar isEqualToString:@"null"]) {
            imageURL = [NSURL URLWithString:avatar];
        }
    }
    if (imageURL != nil) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:imageURL options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            self.headImageView.image = image;
            
        }];
    }else {
        self.headImageView.image = DEFAULT_HEADIMAGE;
    }
    
    [defaults synchronize];
}

-(void)createNavigationItems {
    UILabel* titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.text = @"心跳吧";
    titleLab.textColor = COLOR_WHITE1;
    titleLab.font = [UIFont boldSystemFontOfSize:18];
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleLab];
    self.navigationItem.leftBarButtonItem = titleItem;
    
    self.addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"barbuttonicon_add.png"] forState:UIControlStateNormal];
    self.addBtn.tag = 1;//"+"按钮
    UIBarButtonItem* addItem = [[UIBarButtonItem alloc]initWithCustomView:self.addBtn];
    
    self.moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"barItem_More.png"] forState:UIControlStateNormal];
    self.moreBtn.tag = 2;//"..."按钮
    UIBarButtonItem* moreItem = [[UIBarButtonItem alloc]initWithCustomView:self.moreBtn];
    self.navigationItem.rightBarButtonItems = @[moreItem, addItem];
    
    [self.addBtn addTarget:self action:@selector(clickedNavigationBarItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn addTarget:self action:@selector(clickedNavigationBarItem:) forControlEvents:UIControlEventTouchUpInside];
}

//点击了"+"和"..."按钮
-(void)clickedNavigationBarItem:(UIButton* )sender {
    if (sender.tag == 1) {
        if (self.moreView.hidden == YES && self.addView.hidden == YES) {
            self.addView.hidden = NO;
        }else if (self.moreView.hidden == NO && self.addView.hidden == YES) {
            self.moreView.hidden = YES;
            self.addView.hidden = NO;
        }else if (self.moreView.hidden == YES && self.addView.hidden == NO) {
            self.addView.hidden = YES;
        }else {
            self.moreView.hidden = YES;
            self.addView.hidden = YES;
        }
        
        
    }else if (sender.tag == 2) {
        if (self.moreView.hidden == YES && self.addView.hidden == YES) {
            self.moreView.hidden = NO;
        }else if (self.moreView.hidden == NO && self.addView.hidden == YES) {
            self.moreView.hidden = YES;
        }else if (self.moreView.hidden == YES && self.addView.hidden == NO) {
            self.addView.hidden = YES;
            self.moreView.hidden = NO;
        }else {
            self.moreView.hidden = YES;
            self.addView.hidden = YES;
        }
    }
    
    
}

//添加"+"和"..."视图
-(void)createMoreViewAndAddViewWithY:(CGFloat )origin_y {
    CGFloat lineHeight = 40;//“hope”、“心跳指数”、“添加朋友”、“拍照共享”等每行高35
    CGFloat lineWidth = 110;//行宽110
    
    self.moreView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-lineWidth - 10, origin_y, lineWidth, 5*lineHeight)];
    self.moreView.backgroundColor = COLOR_BLACK1;
    [self.view addSubview:self.moreView];
    NSArray* moreViewTitle = @[@"",@"心跳指数",@"我的专柜",@"我的订单",@"设置"];
    NSArray* moreViewPicName = @[@"",@"xinTiaoZhiShu.png",@"zhuanGui.png",@"shoppingCar.png",@"setting.png"];//对应图片的名字
    for (int i = 0; i < 5; i++) {
        UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(0, i*lineHeight, lineWidth, lineHeight)];
        button.tag = 100+i;
        button.backgroundColor = COLOR_BLACK1;
        [self.moreView addSubview:button];
        if (i == 0) {
            self.nickNameLab = [[UILabel alloc]initWithFrame:CGRectMake(8 + 20 + 8, (lineHeight - 20)/2, lineWidth - 8 - 20, 20)];
            self.nickNameLab.text = NICKNAME;
            self.nickNameLab.textColor = COLOR_WHITE1;
            self.nickNameLab.font = FONT_15;
            [button addSubview:self.nickNameLab];
            [button addTarget:self action:@selector(clickedMoreButton:) forControlEvents:UIControlEventTouchUpInside];
            
            self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake((lineHeight - 30)/2, (lineHeight - 30)/2, 30, 30)];
            self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.width/2;
            self.headImageView.layer.masksToBounds = YES;
            [button addSubview:self.headImageView];
        }else{
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, (lineHeight - 20)/2, 20, 20)];
            imageView.image = [UIImage imageNamed:moreViewPicName[i]];
            [button addSubview:imageView];
            
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(8 + 20 + 8, (lineHeight - 20)/2, lineWidth - 8 - 20, 20)];
            label.text = moreViewTitle[i];
            label.textColor = COLOR_WHITE1;
            label.font = FONT_15;
            [button addSubview:label];
            [button addTarget:self action:@selector(clickedMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    self.moreView.hidden = YES;
    
    self.addView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-180, origin_y, lineWidth, 2*lineHeight)];
    self.addView.backgroundColor = COLOR_BLACK1;
    [self.view addSubview:self.addView];
    NSArray* addViewTitle = @[@"添加朋友",@"拍照共享"];
    NSArray* addViewPicName = @[@"addContacts.png",@"camera.png"];
    for (int j = 0; j < 2; j++) {
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, j*lineHeight, lineWidth, lineHeight)];
        btn.tag = 200+j;
        btn.backgroundColor = COLOR_BLACK1;
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, (lineHeight - 20)/2, 20, 20)];
        imageView.image = [UIImage imageNamed:addViewPicName[j]];
        [btn addSubview:imageView];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 8, (lineHeight - 20)/2, lineWidth - imageView.frame.origin.x - imageView.frame.size.width, 20)];
        label.text = addViewTitle[j];
        label.textColor = COLOR_WHITE1;
        label.font = FONT_15;
        [btn addSubview:label];
        [self.addView addSubview:btn];
        [btn addTarget:self action:@selector(clickedAddButton:) forControlEvents:UIControlEventTouchUpInside];//添加点击事件
    }
    self.addView.hidden = YES;
}

//点击了"..."按钮里的"hope"、"心跳指数"、"我的专柜"、"我的订单"或"设置"
-(void)clickedMoreButton:(UIButton* )sender {
    HBUser* user_self = [[HBUser alloc]init];
    user_self.userID = USERID;
    user_self.nickName = NICKNAME;
    user_self.heartBeatNumber = HEARTBEATNUMBER;
    user_self.personalizedSignature = PERSONALIZEDSIGNATURE;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* avatar = [defaults objectForKey:@"avatar"];
    user_self.avatar = avatar;
    switch (sender.tag) {
        case 100:   //hope
        {
            self.moreView.hidden = YES;
            HBMyHopeViewController* HBMyHopeVC = [[HBMyHopeViewController alloc]init];
            HBMyHopeVC.user = user_self;
            [self.navigationController pushViewController:HBMyHopeVC animated:NO];
        }
            break;
        case 101:   //心跳指数
        {
            self.moreView.hidden = YES;
            HBMyNumberViewController* HBMyNumberVC = [[HBMyNumberViewController alloc]init];
            HBMyNumberVC.user = user_self;
            [self.navigationController pushViewController:HBMyNumberVC animated:NO];
        }
            break;
        case 102:   //我的专柜
        {
            self.moreView.hidden = YES;
            HBMyZhuanGuiViewController* HBMyZhuanGuiVC = [[HBMyZhuanGuiViewController alloc]init];
            HBMyZhuanGuiVC.user = user_self;
            [self.navigationController pushViewController:HBMyZhuanGuiVC animated:NO];
        }
            break;
        case 103:   //我的订单
        {
            self.moreView.hidden = YES;
            HBMyOrderViewController* HBMyOrderVC = [[HBMyOrderViewController alloc]init];
            [self.navigationController pushViewController:HBMyOrderVC animated:NO];
        }
            break;
        case 104:   //设置
        {
            self.moreView.hidden = YES;
            HBSettingViewController* HBSettingVC = [[HBSettingViewController alloc]init];
            [self.navigationController pushViewController:HBSettingVC animated:NO];
        }
            break;
        default:
            break;
    }
}

//点击了"+"按钮里的"添加朋友"或"拍照共享"
-(void)clickedAddButton:(UIButton* )sender {
    switch (sender.tag) {
        case 200:   //添加朋友
        {
            self.addView.hidden = YES;
            HBAddFriendsViewController* HBAddFriendsVC = [[HBAddFriendsViewController alloc]init];
            [self.navigationController pushViewController:HBAddFriendsVC animated:NO];
        }
            break;
        case 201:   //拍照共享
        {
            self.addView.hidden = YES;
            HBPaiZhaoGongxiangViewController* HBPaiZhaoGongXiangVC = [[HBPaiZhaoGongxiangViewController alloc]init];
            [self.navigationController pushViewController:HBPaiZhaoGongXiangVC animated:NO];
        }
            break;
        default:
            break;
    }
}

//创建 共享 通讯录 视图
-(void)createButtonViewWithY:(CGFloat )origin_y {
    self.buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, HEIGHT_BUTTON)];
    [self.view addSubview:self.buttonView];
    
    self.shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.buttonView.frame.size.width/2, HEIGHT_BUTTON)];
    self.shareBtn.selected = YES;
    [self.shareBtn setTitle:@"共享" forState:UIControlStateNormal];
    self.shareBtn.titleLabel.font = FONT_20;
    [self.shareBtn setTitleColor:COLOR_BLUE1 forState:UIControlStateSelected];
    [self.shareBtn setTitleColor:COLOR_GRAY1 forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(clickedShareAndContactsButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonView addSubview:self.shareBtn];
    
    self.contactsBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.shareBtn.frame.size.width, self.shareBtn.frame.origin.y, self.view.frame.size.width/2, HEIGHT_BUTTON)];
    self.contactsBtn.selected = NO;
    [self.contactsBtn setTitle:@"通讯录" forState:UIControlStateNormal];
    self.contactsBtn.titleLabel.font = FONT_20;
    [self.contactsBtn setTitleColor:COLOR_GRAY1 forState:UIControlStateNormal];
    [self.contactsBtn setTitleColor:COLOR_BLUE1 forState:UIControlStateSelected];
    [self.contactsBtn addTarget:self action:@selector(clickedShareAndContactsButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonView addSubview:self.contactsBtn];
    
    //共享 通讯录 按钮 底部灰色线
    UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.buttonView.bounds.size.height - 1, self.buttonView.bounds.size.width, 1)];
    line.image = [UIImage imageNamed:@"line.png"];
    [self.buttonView addSubview:line];
    
    self.shareView = [self createShareViewWithPosition_Y:self.buttonView.frame.origin.y + self.buttonView.frame.size.height];
    self.shareView.hidden = NO;
    [self.view addSubview:self.shareView];
    
    self.contactsView = [self createContactsViewWithPosition_Y:self.buttonView.frame.origin.y + self.buttonView.frame.size.height];
    self.contactsView.hidden = YES;
    [self.view addSubview:self.contactsView];
    
    //蓝色 线
    self.blueLayer = [[CALayer alloc] init];
    [self.blueLayer setCornerRadius:1];
    self.blueLayer.frame = CGRectMake(self.buttonView.frame.size.width/8, self.buttonView.frame.size.height - 3, self.buttonView.frame.size.width/4, 3);
    [self.blueLayer setBackgroundColor:COLOR_BLUE1.CGColor];
    [self.buttonView.layer addSublayer:self.blueLayer];
    
    //灰色 线
    self.grayLayer =  [[CALayer alloc] init];
    self.grayLayer.frame = CGRectMake(self.buttonView.frame.size.width/2, 10, 1, 30);
    [self.grayLayer setBackgroundColor:COLOR_GRAY_CALAYER];
    [self.buttonView.layer addSublayer:self.grayLayer];
}

-(void)clickedShareAndContactsButton:(UIButton* )sender {
    self.addView.hidden = YES;
    self.moreView.hidden = YES;
    if (sender == self.shareBtn) {
        self.contactsBtn.selected = NO;
        self.shareBtn.selected = YES;
        self.contactsView.hidden = YES;
        self.shareView.hidden = NO;
        [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blueLayer.frame = CGRectMake(self.buttonView.frame.size.width/8, self.buttonView.frame.size.height - 3, self.buttonView.frame.size.width/4, 3);
        } completion:^(BOOL finished) {
            [self hideShareRedDot];
        }];
        
    }else if (sender == self.contactsBtn) {
        self.shareBtn.selected = NO;
        self.contactsBtn.selected = YES;
        self.shareView.hidden = YES;
        self.contactsView.hidden = NO;
        [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.blueLayer setFrame:CGRectMake(self.buttonView.frame.size.width/8*5, self.buttonView.frame.size.height - 3, self.buttonView.frame.size.width/4, 3)];
        } completion:^(BOOL finished) {
            [self hideContactsRedDot];
        }];
        
    }
}

//根据起始点的y坐标来创建"共享"视图
-(UIView*)createShareViewWithPosition_Y:(CGFloat )position_y {
    UIView* vi = [[UIView alloc]initWithFrame:CGRectMake(0, position_y, self.view.frame.size.width, self.view.frame.size.height - position_y)];
    vi.backgroundColor = BACKGROUNGCOLOR_GRAY1;
    UIButton* shareButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, LINE_HEIGHT)];
    shareButton.backgroundColor = COLOR_WHITE1;
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_LEFT_HEADIV, SPACE_UP_HEADIV, 40, 40)];
    imageView.image = [UIImage imageNamed:@"woSongNiShou.png"];
    [shareButton addSubview:imageView];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width + SPACE_LEFT_HEADIV*2, (LINE_HEIGHT - 20)/2, self.view.frame.size.width - imageView.frame.size.width - SPACE_LEFT_HEADIV*2, 20)];
    label.text = @"我送你收";
    label.textColor = COLOR_BLACK1;
    label.font = FONT_17;
    [shareButton addSubview:label];
    [vi addSubview:shareButton];
    [shareButton addTarget:self action:@selector(clickedWoSongNiShouButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return vi;
}

//点击了"我送你收"按钮
-(void)clickedWoSongNiShouButton:(UIButton* )sender {
    [self hideShareRedDot];
    
    HBWoSongNiShouViewController* HBWoSongNiShouVC = [[HBWoSongNiShouViewController alloc]init];
    [self.navigationController pushViewController:HBWoSongNiShouVC animated:NO];
}

//根据起始点的y坐标来创建"通讯录"视图
-(UIView*)createContactsViewWithPosition_Y:(CGFloat )position_y {
    UIView* vi = [[UIView alloc]initWithFrame:CGRectMake(0, position_y, self.view.frame.size.width, self.view.frame.size.height - position_y)];
    
    //创建联系人tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, vi.bounds.size.height) style:UITableViewStyleGrouped];
    [self.tableView registerClass:[HBContactsTableViewCell class] forCellReuseIdentifier:identifier];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [vi addSubview:self.tableView];
    
    return vi;
}

//获取所有联系人列表
-(void)getContactsFromServiceWithArgumentStr:(NSString* )argumentStr {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/friends/findFriends.do"];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
//        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"resultStr=%@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"jsonDic=%@", jsonDic);
        
        if ([jsonDic[@"status"]intValue] == 1) {
            __block NSMutableArray* contactArray = [NSMutableArray array];
            
            HBContactModel* contactModel = [HBContactModel createContactModel];
            [contactModel returnUserArrayWithDataDictionary:jsonDic AndBlock:^(NSMutableArray *usersArray) {
                contactArray = usersArray;
                
            }];
            
            [contactModel returnSectionTitleArrayWithTableViewDataArray:contactArray AndBlock:^(NSMutableArray *sortedArray, NSMutableArray *sectionTitleArray) {
                
                if (self.sortedArrayForArray.count > 0) {
                    [self.sortedArrayForArray removeAllObjects];
                }
                [self.sortedArrayForArray addObjectsFromArray:sortedArray];
                self.sectionHeadsKeys = sectionTitleArray;
                
//                保存联系人数据
                [contactModel saveContactsArray:self.sortedArrayForArray WithPageSize:self.pageSize AndPageIndex:self.pageIndex];
                
                
//                NSLog(@"self.sortedArrayForArray=%@, self.sectionHeadsKeys=%@", self.sortedArrayForArray, self.sectionHeadsKeys);
            }];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideInfiniteScrolling];
            [self hidePullToRefresh];

            [self.tableView reloadData];
        });
        
    }];
}

#pragma mark- tableViewDataSource
//多少个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortedArrayForArray.count + 1;
}

//每个分区有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else {
        return [[self.sortedArrayForArray objectAtIndex:section-1] count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBContactsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HBContactsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;//去掉点击时的颜色效果
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.headIV.image = [UIImage imageNamed:@"newFriend.png"];
            cell.nameLab.text = @"新的朋友";
            
            if ([defaults integerForKey:@"newFriends"] > 0) {
                cell.redDot.hidden = NO;
            }
            
        }else if (indexPath.row == 1) {
            cell.headIV.image = [UIImage imageNamed:@"add_Friend.png"];
            cell.nameLab.text = @"添加朋友";
            
            cell.redDot.hidden = YES;
        }
    }else {
        NSArray* sectionArray = self.sortedArrayForArray[indexPath.section - 1];
        HBUser* user = sectionArray[indexPath.row];
        
        if (user.avatar != nil) {
            if (user.avatar.length > 20) {
                NSURL* imageURL = [NSURL URLWithString:user.avatar];
//                [cell.headIV sd_setImageWithURL:imageURL placeholderImage:DEFAULT_HEADIMAGE options:SDWebImageLowPriority];
                
                
                [cell.headIV sd_setImageWithPreviousCachedImageWithURL:imageURL andPlaceholderImage:DEFAULT_HEADIMAGE options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    user.headImage = image;
                }];
                
            }
        }else {
            user.headImage = DEFAULT_HEADIMAGE;
            cell.headIV.image = user.headImage;
        }
        
        cell.nameLab.text = user.nickName;
        
        cell.redDot.hidden = YES;
        
        //添加长按手势
        UILongPressGestureRecognizer* longPressGesture =         [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        longPressGesture.minimumPressDuration = 1.0f;
        [cell addGestureRecognizer:longPressGesture];
    }
    
    return cell;
}

//点击了某一行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"newFriends"];
            HBContactsTableViewCell* cell = (HBContactsTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            if (cell.redDot.hidden == NO) {
                cell.redDot.hidden = YES;
            }
            
            HBNewFriendsViewController* HBNewFriendsVC = [[HBNewFriendsViewController alloc]init];
            [self.navigationController pushViewController:HBNewFriendsVC animated:NO];
        }else if (indexPath.row == 1) {
            
            HBAddFriendsViewController* HBAFVC = [[HBAddFriendsViewController alloc]init];
            [self.navigationController pushViewController:HBAFVC animated:NO];
        }
    }else {
        NSArray* userArray = self.sortedArrayForArray[indexPath.section - 1];
        HBUser* user = userArray[indexPath.row];
        
        HBMyHopeViewController* HBMyHopeVC = [[HBMyHopeViewController alloc]init];
        HBMyHopeVC.user = user;
        [self.navigationController pushViewController:HBMyHopeVC animated:NO];
    }
    
}

//索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
}

//分区标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else {
        return self.sectionHeadsKeys[section-1];
    }
}

//分区头 高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }else {
        return 10;
    }
}

-(CGFloat )tableView:(UITableView* )tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.sortedArrayForArray.count) {
        return 0.01;
    }else {
        return 0;
    }
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LINE_HEIGHT;
}

//长按cell删除好友
-(void)cellLongPress:(UILongPressGestureRecognizer* )gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self.tableView];//点击的位置
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:p];//根据点击的坐标得出点击的indexpath
    
    if (indexPath != nil) {
        NSArray* sectionArray = self.sortedArrayForArray[indexPath.section - 1];
        HBUser* user = sectionArray[indexPath.row];
        
        if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {//长按事件开始
            
            HBAlertView* deleteFriendAV = [[HBAlertView alloc] initWithTitle:@"温馨提示" message:@"此操作不可恢复，确认删除此好友？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            deleteFriendAV.tag = 300;
            deleteFriendAV.user = user;
            deleteFriendAV.indexPath = indexPath;
            [deleteFriendAV show];
            
        }else {
            
        }
    }
}

//删除好友
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 300) {
        HBAlertView* deleteFriendAV = (HBAlertView* )alertView;
        if (buttonIndex == 1) {
            
            NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/friends/deleteFriend.do"];
            NSString* argumentStr = [NSString stringWithFormat:@"frId=%ld&myId=%ld&apiKey=%@", deleteFriendAV.user.userID, USERID, APIKEY];
            [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
                NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"resultStr=%@", resultStr);
                NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"jsonDic=%@", jsonDic);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([jsonDic[@"status"]integerValue] == 1) {
                        
                        NSIndexPath* indexPath = deleteFriendAV.indexPath;
                        
                        NSMutableArray* sectionArr = self.sortedArrayForArray[indexPath.section - 1];
                        if (sectionArr.count == 1) {//如果该分区中只有一行，则直接删除该分区
                            [self.sectionHeadsKeys removeObjectAtIndex:(indexPath.section - 1)];
                            [self.sortedArrayForArray removeObjectAtIndex:(indexPath.section - 1)];
                            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
                        }else {//如果该分区中有多行，则删除该行
                            [sectionArr removeObjectAtIndex:indexPath.row];
                            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                        }
                        
//                        [self.tableView reloadData];
                        
                    }else if ([jsonDic[@"status"]integerValue] == -3) {
                        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"不能删除自己" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [av show];
                    }else {
                        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"删除好友失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [av show];
                    }
                });
            }];
        }
    }
}

//上传clientId给服务器
-(void)uploadClientIdToService {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/data/uploadGeTuiCidUid.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"userId=%ld&clientId=%@&myId=%ld&apiKey=%@", USERID, CLIENTID, USERID, APIKEY];
//    NSLog(@"uploadGeTuiCidUid.do_argumentStr=%@", argumentStr);
    
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data == nil || data.length == 0) {
                NSLog(@"uploadClientId_error=%@", [error localizedDescription]);
            }else {
                NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if ([jsonDic[@"status"]integerValue] == 1) {
                    NSLog(@"上传clientId给服务器成功");
                }
            }
        });
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    __weak HBShareViewController* weakSelf = self;
    
    if (-scrollView.contentOffset.y > LINE_HEIGHT) {//下拉刷新
        [self.tableView.pullToRefreshView setTitle:@"刷新" forState:SVPullToRefreshStateAll];
        [self.tableView addPullToRefreshWithActionHandler:^{
            
            weakSelf.tableView.showsInfiniteScrolling = NO;
            weakSelf.pageIndex = 0;
            NSString* argumentStr = [NSString stringWithFormat:@"condition=%@&pageIndex=%ld&pageSize=%ld&sortStyle=%@&siftCondition=%@&siftValue=%@&myId=%ld&apiKey=%@", @"", weakSelf.pageIndex, weakSelf.pageSize, @"", @"", @"", USERID, APIKEY];
            [weakSelf getContactsFromServiceWithArgumentStr:argumentStr];
        }];
    }
    
    [self hideInfiniteScrolling];
    
    /*
    if ((self.sortedArrayForArray.count > 0) && (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + LINE_HEIGHT)) {//上拉加载
        NSInteger totalArrayCount = 0;
        for (NSArray* sectionArr in self.sortedArrayForArray) {
            totalArrayCount += sectionArr.count;
        }
        if (totalArrayCount >= self.pageSize*(self.pageIndex+1)) {
            self.tableView.showsInfiniteScrolling = YES;
            [self.tableView addInfiniteScrollingWithActionHandler:^{
                
                weakSelf.pageIndex++;
                NSString* argumentStr = [NSString stringWithFormat:@"condition=%@&pageIndex=%ld&pageSize=%ld&sortStyle=%@&siftCondition=%@&siftValue=%@&myId=%ld&apiKey=%@", @"", weakSelf.pageIndex, weakSelf.pageSize, @"", @"", @"", USERID, APIKEY];
                [weakSelf getContactsFromServiceWithArgumentStr:argumentStr];
            }];
        }
    }
     */
}

//隐藏 下拉刷新 视图
-(void)hidePullToRefresh {
    [self.tableView.pullToRefreshView stopAnimating];
}

//隐藏 上拉加载 视图
-(void)hideInfiniteScrolling {
    [self.tableView.infiniteScrollingView stopAnimating];
    self.tableView.showsInfiniteScrolling = NO;
}

//显示共享右上角的红点
-(void)showShareRedDot {
    self.share_RedDot = [[CALayer alloc]init];
    self.share_RedDot.frame = CGRectMake(self.shareBtn.frame.size.width/2 + 20, self.shareBtn.frame.size.height/2 - 10, 8, 8);
    [self.share_RedDot setBackgroundColor:COLOR_RED1.CGColor];
    self.share_RedDot.cornerRadius = self.share_RedDot.frame.size.width/2;
    self.share_RedDot.masksToBounds = YES;
    [self.shareBtn.layer addSublayer:self.share_RedDot];
}

//隐藏共享右上角的红点
-(void)hideShareRedDot {
    if (self.share_RedDot != nil) {
        [self.share_RedDot removeFromSuperlayer];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:0 forKey:@"shareRedDot"];
        [defaults synchronize];
    }
}

//显示通讯录右上角的红点
-(void)showContactsRedDot {
    self.contacts_RedDot = [[CALayer alloc]init];
    self.contacts_RedDot.frame = CGRectMake(self.contactsBtn.frame.size.width/2 + 30, self.contactsBtn.frame.size.height/2 - 10, 8, 8);
    [self.contacts_RedDot setBackgroundColor:COLOR_RED1.CGColor];
    self.contacts_RedDot.cornerRadius = self.contacts_RedDot.frame.size.width/2;
    self.contacts_RedDot.masksToBounds = YES;
    [self.contactsBtn.layer addSublayer:self.contacts_RedDot];
}

//隐藏通讯录右上角的红点
-(void)hideContactsRedDot {
    if (self.contacts_RedDot != nil) {
        [self.contacts_RedDot removeFromSuperlayer];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:0 forKey:@"contactsRedDot"];
        [defaults synchronize];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
