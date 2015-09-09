//
//  HBNewFriendsViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/5.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBNewFriendsViewController.h"
#import "HBTool.h"
#import "HBNewFriendsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HBNewFriendsParser.h"
#import "HBVerifyFriendViewController.h"
#import "HBNewFriendRequest.h"
#import "HBUser.h"

@interface HBNewFriendsViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)NSMutableArray* tableArr;//存储好友
@property (nonatomic, assign)NSInteger pageIndex;
@property (nonatomic, assign)NSInteger pageSize;

@end

@implementation HBNewFriendsViewController

//行高
#define LINE_HEIGHT 50

static NSString* identifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[HBTool shareTool]isIOS7_Later]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    self.title = @"新的朋友";
    self.view.backgroundColor = COLOR_WHITE1;
    
    self.tableView = [self createTableViewWithY:NAVIGATIOINBARHEIGHT];
    [self.view addSubview:self.tableView];
    
    
    self.pageSize = 10;
    self.pageIndex = 0;
    self.tableArr = [NSMutableArray array];
    [self getNewFriendsDataFromService];
    
}

//创建tableView
-(UITableView* )createTableViewWithY:(CGFloat )origin_y {
    UITableView* tv = [[UITableView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, self.view.frame.size.height - origin_y) style:UITableViewStylePlain];
    [tv registerClass:[HBNewFriendsTableViewCell class] forCellReuseIdentifier:identifier];
    tv.dataSource = self;
    tv.delegate = self;
    return tv;
}

-(void)getNewFriendsDataFromService {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/friends/findVerifyFriend.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"pageIndex=%ld&pageSize=%ld&myId=%ld&apiKey=%@", self.pageIndex, self.pageSize, USERID, APIKEY];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* result_Str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"result_Str=%@", result_Str);
        
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                NSArray* verifyFriendList = jsonDic[@"verifyFriendList"];
                [[HBNewFriendsParser createHBNewFriendsParser]returnNewFriendsArrayWithDataArray:verifyFriendList AndBlock:^(NSMutableArray *friendRequestArr) {
                    
                    if (self.pageIndex == 0) {
                        [self.tableArr removeAllObjects];
                    }
                    [self.tableArr addObjectsFromArray:friendRequestArr];
                }];
            }
            
            [self hidePullToRefresh];
            [self hideInfiniteScrolling];
            [self.tableView reloadData];
        });
    }];
}

#pragma mark- UITableViewDataSource
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBNewFriendsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[HBNewFriendsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    HBNewFriendRequest* friendRequest = self.tableArr[indexPath.row];
    cell.descriptionLab.text = friendRequest.descriptionStr;
    
    NSInteger status = friendRequest.status;//2:成功 1:失败 -1:等待对方(secUser)验证
    if (status == HBNewFriendRequestFailed) {
        cell.statusLab.text = @"已忽略";
    }else if (status == HBNewFriendRequestSucceed) {
        cell.statusLab.text = @"已处理";
    }else if (status == HBNewFriendRequestVerify) {
        cell.statusLab.text = @"未处理";
    }
    
    HBUser* fstUser = friendRequest.fstUser;
    if (![fstUser.avatar isKindOfClass:[NSNull class]]) {
        if (![fstUser.avatar isEqualToString:@"null  "] && ![fstUser.avatar isEqualToString:@"null"]) {
            NSURL* imageURL = [NSURL URLWithString:fstUser.avatar];
            [cell.headIV sd_setImageWithURL:imageURL placeholderImage:DEFAULT_HEADIMAGE options:SDWebImageLowPriority];
        }else {
            cell.headIV.image = DEFAULT_HEADIMAGE;
        }
    }else {
        cell.headIV.image = DEFAULT_HEADIMAGE;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    HBNewFriendsTableViewCell* cell = (HBNewFriendsTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    HBNewFriendRequest* friendRequest = self.tableArr[indexPath.row];
    HBVerifyFriendViewController* verifyFriendVC = [[HBVerifyFriendViewController alloc]init];
    verifyFriendVC.user = friendRequest.fstUser;
    verifyFriendVC.headImage = cell.headIV.image;
    verifyFriendVC.descriptionStr = friendRequest.descriptionStr;
    verifyFriendVC.status = friendRequest.status;
    
    [verifyFriendVC returnStatus:^(HBNewFriendRequestStatus requestStatus) {
        friendRequest.status = requestStatus;
        if (requestStatus == HBNewFriendRequestFailed) {
            cell.statusLab.text = @"已忽略";
        }else if (requestStatus == HBNewFriendRequestSucceed) {
            cell.statusLab.text = @"已处理";
        }else if (requestStatus == HBNewFriendRequestVerify) {
            cell.statusLab.text = @"未处理";
        }
    }];
    
    [self.navigationController pushViewController:verifyFriendVC animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LINE_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    __weak HBNewFriendsViewController* weakSelf = self;
    
    [self.tableView.pullToRefreshView setTitle:@"刷新" forState:SVPullToRefreshStateAll];
    
    if (-scrollView.contentOffset.y > LINE_HEIGHT) {//下拉刷新
        self.pageIndex = 0;
        
        self.tableView.showsInfiniteScrolling = NO;
        [self.tableView addPullToRefreshWithActionHandler:^{
            
            [weakSelf getNewFriendsDataFromService];
        }];
        
    }
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + LINE_HEIGHT) {//上拉加载
        self.tableView.showsInfiniteScrolling = YES;
        
        if (self.tableArr.count >= self.pageSize*(self.pageIndex+1)) {
            self.pageIndex++;
            
            [self.tableView addInfiniteScrollingWithActionHandler:^{
                
                [weakSelf getNewFriendsDataFromService];
            }];
        }
    }
}

-(void)hidePullToRefresh {
    [self.tableView.pullToRefreshView stopAnimating];
}

-(void)hideInfiniteScrolling {
    [self.tableView.infiniteScrollingView stopAnimating];
    self.tableView.showsInfiniteScrolling = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
