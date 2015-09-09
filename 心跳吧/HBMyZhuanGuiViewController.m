//
//  HBMyZhuanGuiViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/26.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBMyZhuanGuiViewController.h"
#import "HBTool.h"
#import "HBMyZhuanGuiCollectionViewCell.h"
#import "HBCollectioinViewCustomLayout.h"
#import "KRLCollectionViewGridLayout.h"
#import "HBGoods.h"
#import "HBGoodsModel.h"
#import "HBPaiZhaoGongxiangViewController.h"
#import "HBGoodsDetailViewController.h"
#import "UIButton+WebCache.h"

@interface HBMyZhuanGuiViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (nonatomic, strong)UICollectionView* collectionView;
@property (nonatomic, strong)KRLCollectionViewGridLayout* layout;

@property (nonatomic, assign)NSInteger pageIndex;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, strong)NSMutableArray* goodsArray;//存放物品


@end

@implementation HBMyZhuanGuiViewController

static NSString* identifier = @"cell";

//collectionView间距
#define SPACE_CELL 10
//collectioinView的宽高
#define WIDTH_CELL ((self.view.frame.size.width - SPACE_CELL)/2)
#define HEIGHT_CELL (WIDTH_CELL + 40)

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_WHITE1;
    if ([[HBTool shareTool]isIOS7_Later]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    self.title = @"专柜详情";
    
    [self createCollectionViewWithY:NAVIGATIOINBARHEIGHT];
    
    
    self.pageIndex = 0;
    self.pageSize = 10;
    self.goodsArray = [NSMutableArray array];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getDataFromService];
}

//创建collectionView
-(void)createCollectionViewWithY:(CGFloat )origin_y {
    //    HBCollectioinViewCustomLayout* customLayout = [[HBCollectioinViewCustomLayout alloc]init];
    KRLCollectionViewGridLayout* customLayout = [[KRLCollectionViewGridLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, self.view.frame.size.height - origin_y) collectionViewLayout:customLayout];
    self.collectionView.backgroundColor = BACKGROUNGCOLOR_GRAY1;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[HBMyZhuanGuiCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    self.layout.numberOfItemsPerLine = 2;
    self.layout.aspectRatio = WIDTH_CELL/HEIGHT_CELL;
    self.layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.layout.interitemSpacing = 10;
    self.layout.lineSpacing = 10;
}

//
-(KRLCollectionViewGridLayout* )layout {
    return (id)self.collectionView.collectionViewLayout;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(WIDTH_CELL, HEIGHT_CELL);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.user.userID == USERID) {
        return self.goodsArray.count + 1;
    }else {
        return self.goodsArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HBMyZhuanGuiCollectionViewCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[HBMyZhuanGuiCollectionViewCell alloc]init];
    }
    
    if (indexPath.item == self.goodsArray.count) {
        cell.goodsIV.hidden = YES;
        cell.likeIV.hidden = YES;
        cell.wantIV.hidden = YES;
        cell.likeNumLab.hidden = YES;
        cell.wantNumLab.hidden = YES;
        cell.nameLab.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
        cell.nameLab.text = @"+";
        cell.nameLab.textColor = COLOR_BLACK1;
        cell.nameLab.textAlignment = NSTextAlignmentCenter;
        cell.nameLab.font = [UIFont systemFontOfSize:80];
        
    }else {
        cell.goodsIV.hidden = NO;
        cell.likeIV.hidden = NO;
        cell.wantIV.hidden = NO;
        cell.wantNumLab.hidden = NO;
        cell.likeNumLab.hidden = NO;
        cell.nameLab.frame = CGRectMake(0,cell.goodsIV.frame.origin.y + cell.goodsIV.frame.size.height, cell.frame.size.width, 20);
        cell.nameLab.textAlignment = NSTextAlignmentCenter;
        cell.nameLab.textColor = COLOR_BLACK1;
        cell.nameLab.font = FONT_17;
        
        HBGoods* goods = self.goodsArray[indexPath.item];
        cell.nameLab.text = goods.name;
        NSString* likeNumber;
        if (goods.likeNum > 99) {
            likeNumber = @"（99+）";
        }else {
            likeNumber = [NSString stringWithFormat:@"（%ld）",goods.likeNum];
        }
        cell.likeNumLab.text = likeNumber;
        NSString* wantNumber;
        if (goods.likeNum > 99) {
            wantNumber = @"（99+）";
        }else {
            wantNumber = [NSString stringWithFormat:@"（%ld）",goods.wantNum];
        }
        cell.wantNumLab.text = wantNumber;
        if (goods.goodsImageAddrList.count > 0) {
            
            NSURL* imageURL = [NSURL URLWithString:goods.goodsImageAddrList[0]];
            
            [cell.goodsIV sd_setImageWithPreviousCachedImageWithURL:imageURL andPlaceholderImage:DEFAULT_HEADIMAGE options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if (indexPath.item == self.goodsArray.count) {
        HBPaiZhaoGongxiangViewController* HBPZGXVC = [[HBPaiZhaoGongxiangViewController alloc]init];
        [self.navigationController pushViewController:HBPZGXVC animated:NO];
    }else {
        HBGoods* selectedGoods = self.goodsArray[indexPath.item];
        HBGoodsDetailViewController* HBGDVC = [[HBGoodsDetailViewController alloc]init];
        HBGDVC.goods = selectedGoods;
        [self.navigationController pushViewController:HBGDVC animated:NO];
    }
    
}

//从服务器获取数据
-(void)getDataFromService {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/goods/findGoodsByUser.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"userId=%ld&pageIndex=%ld&pageSize=%ld&lastTime=%d&sortStyle=%@&myId=%ld&apiKey=%@", self.user.userID, self.pageIndex, self.pageSize, 0, @"", USERID, APIKEY];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
//        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"resultStr=%@", resultStr);
        
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"pageIndex=%ld,ZhuanGui_jsonDic=%@", self.pageIndex, jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                NSArray* goodsList = jsonDic[@"goodsList"];
                if (goodsList.count > 0) {
                    [[HBGoodsModel createGoodsModel]returnGoodsArrayWithArray:goodsList AndBlock:^(NSMutableArray *goodsArr) {
                        
                        if (self.pageIndex == 0) {
                            [self.goodsArray removeAllObjects];
                        }
                        [self.goodsArray addObjectsFromArray:goodsArr];
                    }];
                    [self.collectionView reloadData];
                }
            }
            [self hidePullToRefresh];
            [self hideInfiniteScrolling];
        });
    }];
}

#pragma mark- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    __weak HBMyZhuanGuiViewController* weakSelf = self;
    
    if (-scrollView.contentOffset.y > 50) {//下拉刷新
        self.pageIndex = 0;
        
        self.collectionView.showsInfiniteScrolling = NO;
        [self.collectionView.pullToRefreshView setTitle:@"刷新" forState:SVPullToRefreshStateAll];
        [self.collectionView addPullToRefreshWithActionHandler:^{
            
            [weakSelf getDataFromService];
        }];
        
    }
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + 50) {//上拉加载
        self.collectionView.showsInfiniteScrolling = YES;
        
        if (self.goodsArray.count >= self.pageSize*(self.pageIndex+1)) {
            NSLog(@"self.goodsArray.count=%ld,self.pageSize*(self.pageIndex+1)=%ld", self.goodsArray.count, (self.pageIndex+1)*self.pageSize);
            
            [self.collectionView addInfiniteScrollingWithActionHandler:^{
                [weakSelf hideInfiniteScrolling];
                weakSelf.pageIndex++;
                [weakSelf getDataFromService];
            }];
            
        }
    }
}

-(void)hidePullToRefresh {
    [self.collectionView.pullToRefreshView stopAnimating];
}

-(void)hideInfiniteScrolling {
    [self.collectionView.infiniteScrollingView stopAnimating];
    self.collectionView.showsInfiniteScrolling = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
