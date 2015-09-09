//
//  HBWoSongNiShouViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/24.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBWoSongNiShouViewController.h"
#import "HBTool.h"
#import <UIImageView+WebCache.h>
#import "HBSongNotifyDetailViewController.h"
#import "HBShouNotifyDetailViewController.h"

@interface HBWoSongNiShouViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong)UIView* woSongNiShouView;//送出收进 视图
@property (nonatomic, strong)UIButton* woSongBtn;//"送出"按钮
@property (nonatomic, strong)UIButton* niShouBtn;//"收进"按钮
@property (nonatomic, strong)CALayer* blueLine;//送出 收进 按钮底部蓝色线条
@property (nonatomic, strong)UITableView* tableView;

@property (nonatomic, strong)NSMutableArray* dataArray;
@property (nonatomic, strong)NSMutableArray* songArray;//送出 数组
@property (nonatomic, strong)NSMutableArray* shouArray;//收进 数组
@property (nonatomic, assign)NSInteger pageSize;//pageSize
@property (nonatomic, assign)NSInteger songIndex;//送出 pageIndex
@property (nonatomic, assign)NSInteger shouIndex;//收进 pageIndex

@property (nonatomic, strong)CALayer* song_RedDot;//送出右上角红点
@property (nonatomic, strong)CALayer* shou_RedDot;//收进右上角红点

@end

@implementation HBWoSongNiShouViewController

//行高
#define LINE_HEIGHT 50
#define identifier @"cell"

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我送你收";
    self.view.backgroundColor = COLOR_WHITE1;
    self.dataArray = [NSMutableArray array];
    self.woSongNiShouView = [self createWoSongNiShouButtonViewWithY:NAVIGATIOINBARHEIGHT AndHeight:LINE_HEIGHT];
    [self.view addSubview:self.woSongNiShouView];
    
    self.tableView = [self createTableViewWithY:self.woSongNiShouView.frame.origin.y + self.woSongNiShouView.frame.size.height AndHeight:self.view.frame.size.height - self.woSongNiShouView.frame.origin.y - self.woSongNiShouView.frame.size.height];
    [self.view addSubview:self.tableView];
    
    
    self.pageSize = 10;
    self.dataArray = [NSMutableArray array];
    self.songArray = [NSMutableArray array];
    self.shouArray = [NSMutableArray array];
    
    [self refreshWoSongData];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"songRedDot"] > 0) {
        [self showSongRedDot];
    }
    if ([defaults integerForKey:@"shouRedDot"] > 0) {
        [self showShouRedDot];
    }
}

//创建"送出"、"收进"两个按钮  视图
-(UIView* )createWoSongNiShouButtonViewWithY:(CGFloat )origin_y AndHeight:(CGFloat )frame_height {
    UIView* tempView = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, frame_height)];
    self.woSongBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, tempView.frame.size.width/2, tempView.frame.size.height - 1)];
    self.woSongBtn.selected = YES;
    self.woSongBtn.titleLabel.font = FONT_20;
    [self.woSongBtn setTitle:@"送出" forState:UIControlStateNormal];
    [self.woSongBtn setTitleColor:COLOR_BLUE1 forState:UIControlStateSelected];
    [self.woSongBtn addTarget:self action:@selector(clickedWoSongNiShouButton:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:self.woSongBtn];
    
    //中间灰色的 竖线
    CALayer* grayLayer =  [[CALayer alloc] init];
    grayLayer.frame = CGRectMake(self.woSongBtn.frame.size.width - 1, (self.woSongBtn.frame.size.height - 20)/2, 1, 20);
    [grayLayer setBackgroundColor:COLOR_GRAY_CALAYER];
    [self.woSongBtn.layer addSublayer:grayLayer];
    
    self.niShouBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.woSongBtn.frame.size.width, 0, tempView.frame.size.width/2, tempView.frame.size.height - 1)];
    self.niShouBtn.selected = NO;
    self.niShouBtn.titleLabel.font = FONT_20;
    [self.niShouBtn setTitle:@"收进" forState:UIControlStateNormal];
    [self.niShouBtn setTitleColor:COLOR_GRAY1 forState:UIControlStateNormal];
    [self.niShouBtn addTarget:self action:@selector(clickedWoSongNiShouButton:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:self.niShouBtn];
    
    UIImageView* lineIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, tempView.frame.size.height - 1, tempView.frame.size.width, 1)];
    lineIV.image = [UIImage imageNamed:@"line.png"];
    [tempView addSubview:lineIV];
    
    //送出 收进 按钮底部蓝色线条
    self.blueLine = [[CALayer alloc]init];
    self.blueLine.frame = CGRectMake(tempView.frame.size.width/8, tempView.frame.size.height - 3, tempView.frame.size.width/4, 3);
    [self.blueLine setBackgroundColor:COLOR_BLUE1.CGColor];
    [tempView.layer addSublayer:self.blueLine];
    return tempView;
}

//点击了"送出"或"收进"按钮
-(void)clickedWoSongNiShouButton:(UIButton* )sender {
    if (sender == self.woSongBtn) {
        self.niShouBtn.selected = NO;
        [self.niShouBtn setTitleColor:COLOR_GRAY1 forState:UIControlStateNormal];
        self.woSongBtn.selected = YES;
        [self.woSongBtn setTitleColor:COLOR_BLUE1 forState:UIControlStateSelected];
        [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blueLine.frame = CGRectMake(self.woSongBtn.frame.size.width/4, self.woSongBtn.frame.size.height - 3, self.woSongBtn.frame.size.width/2, 3);
        } completion:^(BOOL finished) {
            
        }];
        
        [self hideSongRedDot];
        [self refreshWoSongData];
        
        
    }else if (sender == self.niShouBtn) {
        self.woSongBtn.selected = NO;
        [self.woSongBtn setTitleColor:COLOR_GRAY1 forState:UIControlStateNormal];
        self.niShouBtn.selected = YES;
        [self.niShouBtn setTitleColor:COLOR_BLUE1 forState:UIControlStateSelected];
        [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.blueLine.frame = CGRectMake(self.woSongNiShouView.frame.size.width/8*5, self.niShouBtn.frame.size.height - 3, self.woSongNiShouView.frame.size.width/4, 3);
        } completion:^(BOOL finished) {
            
        }];
        
        [self hideShouRedDot];
        [self refreshNiShouData];
        
        
    }
}

//刷新 送出 数据
-(void)refreshWoSongData {
    self.songIndex = 0;
    NSString* argumentStr = [NSString stringWithFormat:@"pageIndex=%ld&pageSize=%ld&myId=%ld&apiKey=%@", self.songIndex, self.pageSize, USERID, APIKEY];
    [self getWoSongDataFromServiceWithArgumentString:argumentStr];
}

//加载更多 送出 数据
-(void)loadMoreWoSongData {
    self.songIndex++;
    NSString* argumentStr = [NSString stringWithFormat:@"pageIndex=%ld&pageSize=%ld&myId=%ld&apiKey=%@", self.songIndex, self.pageSize, USERID, APIKEY];
    [self getWoSongDataFromServiceWithArgumentString:argumentStr];
}

//刷新 收进 数据
-(void)refreshNiShouData {
    self.shouIndex = 0;
    NSString* argumentStr2 = [NSString stringWithFormat:@"pageIndex=%ld&pageSize=%ld&myId=%ld&apiKey=%@", self.shouIndex, self.pageSize, USERID, APIKEY];
    [self getNiShouDataFromServiceWithArgumentString:argumentStr2];
}

//加载更多 手机 数据
-(void)loadMoreNiShouData {
    self.shouIndex++;
    NSString* argumentStr2 = [NSString stringWithFormat:@"pageIndex=%ld&pageSize=%ld&myId=%ld&apiKey=%@", self.shouIndex, self.pageSize, USERID, APIKEY];
    [self getNiShouDataFromServiceWithArgumentString:argumentStr2];
}

//从服务器获取 送 数据
-(void)getWoSongDataFromServiceWithArgumentString:(NSString* )argumentStr {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/goods/getAllSendNotification.do"];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* result_String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"result_String=%@", result_String);
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"WoSongjsonDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                if (self.songIndex > 0) {
                    NSArray* arr = jsonDic[@"notifyList"];
                    [self.songArray addObjectsFromArray:arr];
                }else {
                    self.songArray = jsonDic[@"notifyList"];
                }
                self.dataArray = self.songArray;
                [self.tableView reloadData];
            }else {
                
            }
            [self hidePullToRefresh];
            [self hideInfiniteScrolling];
            
        });
    }];
    
    
}

//从服务器获取 收 数据
-(void)getNiShouDataFromServiceWithArgumentString:(NSString* )argumentStr {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/goods/getAllRecvNotification.do"];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"NiShoujsonDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                if (self.shouIndex > 0) {
                    NSArray* arr = jsonDic[@"notifyList"];
                    [self.shouArray addObjectsFromArray:arr];
                }else {
                    self.shouArray = jsonDic[@"notifyList"];
                }
                self.dataArray = self.shouArray;
                [self.tableView reloadData];
            }else {
                
            }
            [self hidePullToRefresh];
            [self hideInfiniteScrolling];
            
        });
    }];
}

//创建tableView
-(UITableView* )createTableViewWithY:(CGFloat )origin_y AndHeight:(CGFloat )frame_height {
    UITableView* tv = [[UITableView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, frame_height) style:UITableViewStylePlain];
    [tv registerClass:[HBWoSongNiShouTableViewCell class] forCellReuseIdentifier:identifier];
    tv.dataSource = self;
    tv.delegate = self;
    return tv;
}

#pragma mark- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBWoSongNiShouTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HBWoSongNiShouTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//去掉点击时的颜色效果
    
    NSDictionary* dic = self.dataArray[indexPath.row];
    NSDictionary* orderDic = dic[@"order"];
    NSDictionary* goodsDic = orderDic[@"goods"];
    NSArray* imagePathArr = goodsDic[@"goodsImageAddrList"];
    
    cell.titleLab.text = goodsDic[@"name"];
    cell.descriptionLab.text = @"发货通知，送到后增加心跳指数";
    
    NSURL* imageURL = [NSURL URLWithString:imagePathArr[0]];
    [cell.productIV sd_setImageWithURL:imageURL placeholderImage:DEFAULT_HEADIMAGE options:SDWebImageLowPriority];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary* dic = self.dataArray[indexPath.row];

    if (self.woSongBtn.selected == YES) {
        [self hideSongRedDot];
        
        HBSongNotifyDetailViewController* HBSongVC = [[HBSongNotifyDetailViewController alloc]init];
        HBSongVC.notifyDic = dic;
        [self.navigationController pushViewController:HBSongVC animated:NO];
    }else if (self.niShouBtn.selected == YES) {
        [self hideShouRedDot];
        
        HBShouNotifyDetailViewController* HBShouVC = [[HBShouNotifyDetailViewController alloc]init];
        HBShouVC.notifyDic = dic;
        [self.navigationController pushViewController:HBShouVC animated:NO];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LINE_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    __weak HBWoSongNiShouViewController* weakSelf = self;
    if (-scrollView.contentOffset.y > LINE_HEIGHT) {//下拉刷新
        
        self.tableView.showsInfiniteScrolling = NO;
        [self.tableView.pullToRefreshView setTitle:@"刷新" forState:SVPullToRefreshStateAll];
        [self.tableView addPullToRefreshWithActionHandler:^{
            if (weakSelf.woSongBtn.selected == YES) {
                [weakSelf refreshWoSongData];
            }else if (weakSelf.niShouBtn.selected == YES) {
                [weakSelf refreshNiShouData];
            }
        }];
    }
    if ((scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height+LINE_HEIGHT)))) {//上拉加载
        self.tableView.showsInfiniteScrolling = YES;
        
        if (self.woSongBtn.selected == YES) {
            if (self.dataArray.count >= self.pageSize*(self.songIndex + 1)) {
                
                [self.tableView addInfiniteScrollingWithActionHandler:^{
                    [weakSelf loadMoreWoSongData];
                }];
            }
            
        }else if (self.niShouBtn.selected == YES) {
            if (self.dataArray.count >= self.pageSize*(self.shouIndex + 1)) {
                
                [self.tableView addInfiniteScrollingWithActionHandler:^{
                    [weakSelf loadMoreNiShouData];
                }];
            }
        }
    }
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

//显示送出右上角的红点
-(void)showSongRedDot {
    self.song_RedDot = [[CALayer alloc]init];
    self.song_RedDot.frame = CGRectMake(self.woSongBtn.frame.size.width/2 + 20, self.woSongBtn.frame.size.height/2 - 10, 8, 8);
    [self.song_RedDot setBackgroundColor:COLOR_RED1.CGColor];
    self.song_RedDot.cornerRadius = self.song_RedDot.frame.size.width/2;
    self.song_RedDot.masksToBounds = YES;
    [self.woSongBtn.layer addSublayer:self.song_RedDot];
}

//隐藏送出右上角的红点
-(void)hideSongRedDot {
    if (self.song_RedDot != nil) {
        [self.song_RedDot removeFromSuperlayer];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:0 forKey:@"songRedDot"];
        [defaults synchronize];
    }
}

//显示送出右上角的红点
-(void)showShouRedDot {
    self.shou_RedDot = [[CALayer alloc]init];
    self.shou_RedDot.frame = CGRectMake(self.niShouBtn.frame.size.width/2 + 20, self.niShouBtn.frame.size.height/2 - 10, 8, 8);
    [self.shou_RedDot setBackgroundColor:COLOR_RED1.CGColor];
    self.shou_RedDot.cornerRadius = self.shou_RedDot.frame.size.width/2;
    self.shou_RedDot.masksToBounds = YES;
    [self.niShouBtn.layer addSublayer:self.shou_RedDot];
}

//隐藏送出右上角的红点
-(void)hideShouRedDot {
    if (self.shou_RedDot != nil) {
        [self.shou_RedDot removeFromSuperlayer];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:0 forKey:@"shouRedDot"];
        [defaults synchronize];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
