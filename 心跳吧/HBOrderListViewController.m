//
//  HBOrderListViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/26.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBOrderListViewController.h"
#import "HBTool.h"
#import "HBOrderListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HBOrderListParser.h"
#import "HBGoods.h"
#import "HBOrderDetailViewController.h"

@interface HBOrderListViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong)UIView* buttonView;//想要中 送出 收进 视图
@property (nonatomic, strong)UIButton* xiangYaoBtn;//想要中 按钮
@property (nonatomic, strong)UIButton* songChuBtn;//送出 按钮
@property (nonatomic, strong)UIButton* shouJinBtn;//收进 按钮
@property (nonatomic, strong)CALayer* blueLayer;//蓝色 线
@property (nonatomic, strong)CALayer* grayLayer1;//灰色 线1
@property (nonatomic, strong)CALayer* grayLayer2;//灰色 线2
@property (nonatomic, strong)UITableView* tableView;

@property (nonatomic, assign)int pageIndex;
@property (nonatomic, assign)int pageSize;
@property (nonatomic, strong)NSMutableArray* xiangYaoArr;//想要中 数组
@property (nonatomic, strong)NSMutableArray* songChuArr;//送出 数组
@property (nonatomic, strong)NSMutableArray* shouJinArr;//收进 数组
@property (nonatomic, strong)NSMutableArray* tableArr;//tableView的dataSource


@end

@implementation HBOrderListViewController

static NSString* identifier = @"cell";

//想要中 送出 收进 三个按钮的高度
#define HEIGHT_BUTTON 50
//行高
#define LINE_HEIGHT 50

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单记录";
    self.view.backgroundColor = COLOR_WHITE1;
    
    self.buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVIGATIOINBARHEIGHT, self.view.frame.size.width, HEIGHT_BUTTON)];
    [self.view addSubview:self.buttonView];
    
//  添加 想要中 送出 收进 按钮
    self.xiangYaoBtn = [self createSelectButtonWithX:0 AndTitle:@"想要中" AndSelectedState:YES];
    [self.buttonView addSubview:self.xiangYaoBtn];
    
    self.songChuBtn = [self createSelectButtonWithX:self.view.frame.size.width/3 AndTitle:@"送出" AndSelectedState:NO];
    [self.buttonView addSubview:self.songChuBtn];
    
    self.shouJinBtn = [self createSelectButtonWithX:self.view.frame.size.width/3*2 AndTitle:@"收进" AndSelectedState:NO];
    [self.buttonView addSubview:self.shouJinBtn];
    
//  添加 蓝色 灰色 线
    [self createLayerLine];
    
//  添加tableView
    self.tableView = [self createTableViewWithY:self.buttonView.frame.origin.y + self.buttonView.frame.size.height];
    [self.view addSubview:self.tableView];
    
//  初始化数据
//    self.currentState = tableViewNone;
    self.pageSize = 10;
    self.pageIndex = 0;
    self.xiangYaoArr = [NSMutableArray array];
    self.songChuArr = [NSMutableArray array];
    self.shouJinArr = [NSMutableArray array];
    self.tableArr = [NSMutableArray array];
    
//  刚进入页面时 应该从服务器获取 想要中 的数据
    [self getXiangYaoDataFromService];
    
}

//添加 蓝色 灰色 线
-(void)createLayerLine {
    //蓝色 线
    self.blueLayer = [[CALayer alloc] init];
    [self.blueLayer setCornerRadius:1];
    self.blueLayer.frame = CGRectMake(0, self.buttonView.frame.size.height - 3, self.buttonView.frame.size.width/3, 3);
    [self.blueLayer setBackgroundColor:COLOR_BLUE1.CGColor];
    [self.buttonView.layer addSublayer:self.blueLayer];
    
    //灰色 线1
    self.grayLayer1 =  [[CALayer alloc] init];
    self.grayLayer1.frame = CGRectMake(self.xiangYaoBtn.frame.size.width, 10, 1, 30);
    [self.grayLayer1 setBackgroundColor:COLOR_GRAY_CALAYER];
    [self.buttonView.layer addSublayer:self.grayLayer1];
    
    //灰色 线2
    self.grayLayer2 =  [[CALayer alloc] init];
    self.grayLayer2.frame = CGRectMake(self.xiangYaoBtn.frame.size.width + self.songChuBtn.frame.size.width, 10, 1, 30);
    [self.grayLayer2 setBackgroundColor:COLOR_GRAY_CALAYER];
    [self.buttonView.layer addSublayer:self.grayLayer2];
}

//创建 想要中 送出 收进 按钮
-(UIButton* )createSelectButtonWithX:(CGFloat )origin_x AndTitle:(NSString* )titleString AndSelectedState:(BOOL )selectedState {
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(origin_x, 0, self.view.frame.size.width/3, HEIGHT_BUTTON)];
    btn.selected = selectedState;
    [btn setTitle:titleString forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_GRAY1 forState:UIControlStateNormal];
    [btn setTitle:titleString forState:UIControlStateSelected];
    [btn setTitleColor:COLOR_BLUE1 forState:UIControlStateSelected];
    btn.titleLabel.font = FONT_17;
    btn.backgroundColor = COLOR_WHITE1;
    [btn addTarget:self action:@selector(clickedTopButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* lineIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, btn.frame.size.height - 1, btn.frame.size.width, 1)];
    lineIV.image = [UIImage imageNamed:@"line.png"];
    [btn addSubview:lineIV];
    return btn;
}

//点击了 想要中 送出 收进 按钮
-(void)clickedTopButton:(UIButton* )sender {
//  将self.pageIndex清零
    self.pageIndex = 0;
    
    if (sender == self.xiangYaoBtn) {
        self.xiangYaoBtn.selected = YES;
        self.songChuBtn.selected = NO;
        self.shouJinBtn.selected = NO;
        [self changeBlueLayerFrameWithFrame:CGRectMake(0, self.buttonView.frame.size.height - 3, self.buttonView.frame.size.width/3, 3)];
        
        [self getXiangYaoDataFromService];
        
    }else if (sender == self.songChuBtn) {
        self.xiangYaoBtn.selected = NO;
        self.songChuBtn.selected = YES;
        self.shouJinBtn.selected = NO;
        [self changeBlueLayerFrameWithFrame:CGRectMake(self.buttonView.frame.size.width/3, self.buttonView.frame.size.height - 3, self.buttonView.frame.size.width/3, 3)];
        
        [self getSongChuDataFromService];
        
    }else if (sender == self.shouJinBtn) {
        self.xiangYaoBtn.selected = NO;
        self.songChuBtn.selected = NO;
        self.shouJinBtn.selected = YES;
        [self changeBlueLayerFrameWithFrame:CGRectMake(self.buttonView.frame.size.width/3*2, self.buttonView.frame.size.height - 3, self.buttonView.frame.size.width/3, 3)];
        
        [self getShouJinDataFromService];
        
    }
    
}

//蓝色线 动画
-(void)changeBlueLayerFrameWithFrame:(CGRect )rect {
    [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.blueLayer setFrame:rect];
    } completion:^(BOOL finished) {
        
    }];
}

//创建tableView
-(UITableView* )createTableViewWithY:(CGFloat )origin_y {
    UITableView* tv = [[UITableView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, self.view.frame.size.height - origin_y) style:UITableViewStylePlain];
    [tv registerClass:[HBOrderListTableViewCell class] forCellReuseIdentifier:identifier];
    tv.dataSource = self;
    tv.delegate = self;
    return tv;
}

#pragma mark- UITableViewDataSource
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LINE_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBOrderListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[HBOrderListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    NSDictionary* cellDic = self.tableArr[indexPath.row];
    
    if (self.xiangYaoBtn.selected == YES) {
        
        cell.nameLab.text = cellDic[@"name"];
        NSString* imagePath = [cellDic[@"goodsImageAddrList"] firstObject];
        NSURL* imageURL = [NSURL URLWithString:imagePath];
        [cell.goodsIV sd_setImageWithURL:imageURL placeholderImage:DEFAULT_HEADIMAGE options:SDWebImageLowPriority];
        
        NSDictionary* owner = cellDic[@"owner"];
        cell.detailLab.text = [NSString stringWithFormat:@"所属用户：%@", owner[@"nickName"]];
        
    }else if (self.songChuBtn.selected == YES) {
        NSDictionary* goodsDic = cellDic[@"goods"];
        
        cell.nameLab.text = goodsDic[@"name"];
        NSString* imagePath = [goodsDic[@"goodsImageAddrList"] firstObject];
        NSURL* imageURL = [NSURL URLWithString:imagePath];
        [cell.goodsIV sd_setImageWithURL:imageURL placeholderImage:DEFAULT_HEADIMAGE options:SDWebImageLowPriority];
        
        cell.detailLab.text = [NSString stringWithFormat:@"订单号:%@", cellDic[@"orderNumber"]];
        
    }else if (self.shouJinBtn.selected == YES) {
        NSDictionary* goodsDic = cellDic[@"goods"];

        cell.nameLab.text = goodsDic[@"name"];
        NSString* imagePath = [goodsDic[@"goodsImageAddrList"] firstObject];
        NSURL* imageURL = [NSURL URLWithString:imagePath];
        [cell.goodsIV sd_setImageWithURL:imageURL placeholderImage:DEFAULT_HEADIMAGE options:SDWebImageLowPriority];
        
        cell.detailLab.text = [NSString stringWithFormat:@"订单号:%@", cellDic[@"orderNumber"]];
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    HBGoods* tempGoods = [[HBGoods alloc]init];
    NSDictionary* cellDic = self.tableArr[indexPath.row];
    
    if (self.xiangYaoBtn.selected == YES) {
        tempGoods.goodsId = [cellDic[@"goodsId"]integerValue];
        tempGoods.goodsImageAddrList = cellDic[@"goodsImageAddrList"];
        tempGoods.name = cellDic[@"name"];
        tempGoods.postageType = cellDic[@"postageType"];
        
    }else if (self.songChuBtn.selected == YES) {
        NSDictionary* goodsDic = cellDic[@"goods"];
        tempGoods.goodsId = [goodsDic[@"goodsId"]integerValue];
        tempGoods.goodsImageAddrList = goodsDic[@"goodsImageAddrList"];
        tempGoods.name = goodsDic[@"name"];
        tempGoods.postageType = goodsDic[@"postageType"];
        
    }else if (self.shouJinBtn.selected == YES) {
        NSDictionary* goodsDic = cellDic[@"goods"];
        tempGoods.goodsId = [goodsDic[@"goodsId"]integerValue];
        tempGoods.goodsImageAddrList = goodsDic[@"goodsImageAddrList"];
        tempGoods.name = goodsDic[@"name"];
        tempGoods.postageType = goodsDic[@"postageType"];
        
    }
    HBOrderDetailViewController* orderDetailVC = [[HBOrderDetailViewController alloc]init];
    orderDetailVC.goods = tempGoods;
    [self.navigationController pushViewController:orderDetailVC animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

//从服务器获取 想要中 数据
-(void)getXiangYaoDataFromService {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/goods/findWantingGoods.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"pageIndex=%d&pageSize=%d&userId=%ld&myId=%ld&apiKey=%@", self.pageIndex, self.pageSize, USERID, USERID, APIKEY];
    [self postDataWithURLString:urlStr AndArgumentStr:argumentStr];
}

//从服务器获取 送出 数据
-(void)getSongChuDataFromService {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/goods/getAllSendedOrder"];
    NSString* argumentStr = [NSString stringWithFormat:@"pageIndex=%d&pageSize=%d&myId=%ld&apiKey=%@&userId=%ld&lastTime=", self.pageIndex, self.pageSize, USERID, APIKEY, USERID];
    [self postDataWithURLString:urlStr AndArgumentStr:argumentStr];
}

//从服务器获取 收进 数据
-(void)getShouJinDataFromService {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/goods/getAllRecvOrder"];
    NSString* argumentStr = [NSString stringWithFormat:@"pageIndex=%d&pageSize=%d&myId=%ld&apiKey=%@&userId=%ld&lastTime=", self.pageIndex, self.pageSize, USERID, APIKEY, USERID];
    [self postDataWithURLString:urlStr AndArgumentStr:argumentStr];
}

-(void)postDataWithURLString:(NSString* )urlStr AndArgumentStr:(NSString* )argumentStr {
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"oriderList_resultStr=%@", resultStr);
        
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"oriderList_jsonDic=%@", jsonDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([jsonDic[@"status"]intValue] == 1) {
                HBOrderListParser* parser = [[HBOrderListParser alloc]init];
                
                if (self.xiangYaoBtn.selected == YES) {
                    if ([jsonDic[@"goodsList"] count] > 0) {
                        NSArray* wantArr = [parser returnWantingOrderListWithJSONDic:jsonDic];
                        if (self.pageIndex == 0) {
                            [self.xiangYaoArr removeAllObjects];
                        }
                        [self.xiangYaoArr addObjectsFromArray:wantArr];
                    }
                    [self.tableArr removeAllObjects];
                    [self.tableArr addObjectsFromArray:self.xiangYaoArr];
                    
                }else if (self.songChuBtn.selected == YES) {
                    if ([jsonDic[@"orderList"] count] > 0) {
                        NSArray* songArr = [parser returnSongOrderListWithJSONDic:jsonDic];
                        if (self.pageIndex == 0) {
                            [self.songChuArr removeAllObjects];
                        }
                        [self.songChuArr addObjectsFromArray:songArr];
                    }
                    [self.tableArr removeAllObjects];
                    [self.tableArr addObjectsFromArray:self.songChuArr];
                    
                }else if (self.shouJinBtn.selected == YES) {
                    if ([jsonDic[@"orderList"] count] > 0) {
                        NSArray* shouArr = [parser returnShouOrderListWithJSONDic:jsonDic];
                        if (self.pageIndex == 0) {
                            [self.shouJinArr removeAllObjects];
                        }
                        [self.shouJinArr addObjectsFromArray:shouArr];
                    }
                    [self.tableArr removeAllObjects];
                    [self.tableArr addObjectsFromArray:self.shouJinArr];
                }
                
            }else if ([jsonDic[@"status"]integerValue] == -2) {
                NSLog(@"您暂时没有想要中、送出、收进相关物品");
            }
            
            [self hidePullToRefresh];
            [self hideInfiniteScrolling];
            
            [self.tableView reloadData];
        });
    }];
}

#pragma mark- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    __weak HBOrderListViewController* weakSelf = self;
    
    if (-scrollView.contentOffset.y > LINE_HEIGHT) {//下拉刷新
        self.pageIndex = 0;
        
        self.tableView.showsInfiniteScrolling = NO;
        [self.tableView.pullToRefreshView setTitle:@"刷新" forState:SVPullToRefreshStateAll];
        [self.tableView addPullToRefreshWithActionHandler:^{
            if (weakSelf.xiangYaoBtn.selected == YES) {
                [weakSelf getXiangYaoDataFromService];
                
            }else if (weakSelf.songChuBtn.selected == YES) {
                [weakSelf getSongChuDataFromService];
                
            }else if (weakSelf.shouJinBtn.selected == YES) {
                [weakSelf getShouJinDataFromService];
                
            }
        }];
        
    }
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + LINE_HEIGHT) {//上拉加载
        self.tableView.showsInfiniteScrolling = YES;
        
        if (self.tableArr.count >= self.pageSize*(self.pageIndex+1)) {
            self.pageIndex++;

            [self.tableView addInfiniteScrollingWithActionHandler:^{
                if (weakSelf.xiangYaoBtn.selected == YES) {
                    [weakSelf getXiangYaoDataFromService];
                    
                }else if (weakSelf.songChuBtn.selected == YES) {
                    [weakSelf getSongChuDataFromService];
                    
                }else if (weakSelf.shouJinBtn.selected == YES) {
                    [weakSelf getShouJinDataFromService];
                    
                }
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
