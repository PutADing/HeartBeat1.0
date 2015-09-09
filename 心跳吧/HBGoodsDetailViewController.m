//
//  HBGoodsDetailViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/21.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBGoodsDetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "HBTool.h"
#import "HBUser.h"
#import "HBCheckGoodsImagesViewController.h"
#import <UIImageView+WebCache.h>

@interface HBGoodsDetailViewController () <UIAlertViewDelegate>
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)UIView* headView;//头 视图
@property (nonatomic, strong)UIView* infoView;//所在地区——所属用户 视图
@property (nonatomic, strong)UIView* footView;//尾 视图
@property (nonatomic, strong)UILabel* nameLab;//宝贝标题
@property (nonatomic, strong)UILabel* detailLab;//宝贝详情
@property (nonatomic, strong)UILabel* placeLab;//所在地区
@property (nonatomic, strong)UILabel* postTypeLab;//邮费支付
@property (nonatomic, strong)UILabel* sendTimeLab;//截止时间
@property (nonatomic, strong)UILabel* ofUser;//所属用户
@property (nonatomic, assign)NSInteger likeNum;//喜欢 数量
@property (nonatomic, assign)NSInteger wantNum;//想要 数量
@property (nonatomic, strong)UILabel* likeNumLab;//喜欢 label
@property (nonatomic, strong)UILabel* wantNumLab;//想要 label
@property (nonatomic, strong)UILabel* shareLab;//分享 label
@property (nonatomic, strong)UIButton* likeBtn;//喜欢 button
@property (nonatomic, strong)UIButton* wantBtn;//想要 button
@property (nonatomic, strong)UIButton* shareBtn;//分享 button
@property (nonatomic, strong)UIView* moreView;//点击后展开的视图

@property (nonatomic, strong)NSMutableArray* imagesArr;//存放image对象
@property (nonatomic, strong)NSDictionary* goodsDic;//物品详情数据
@property (nonatomic, strong)HBUser* user;//物品所属用户
@property (nonatomic, assign)BOOL ifUndercarriage;//物品是否过期 标志

@end

@implementation HBGoodsDetailViewController

//行高
#define LINE_HEIGHT 40
//照片 宽高
#define WIDTH_IMAGEVIEW 65
//照片 间距
#define SPACE_IMAGEVIEW (self.view.frame.size.width - WIDTH_IMAGEVIEW*4)/5
//label距离左 间距
#define SPACE_LABEL 10
//宝贝标题 高度
#define HEIGHT_NAMELABEL 20
//headView infoView footView间距
#define SPACE_VIEW 15
//照片视图 高
#define HEIGHT_PHOTOVIEW SPACE_IMAGEVIEW+(SPACE_IMAGEVIEW+WIDTH_IMAGEVIEW)*(self.goods.goodsImageAddrList.count/5+1)

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[HBTool shareTool]isIOS7_Later]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    self.title = @"物品详情";
    self.view.backgroundColor = BACKGROUNGCOLOR_GRAY1;
    
    self.scrollView = [self createScrollViewWithY:NAVIGATIOINBARHEIGHT];
    [self.view addSubview:self.scrollView];
    
    self.headView = [self createHeadViewWithY:0 AndHeight:HEIGHT_PHOTOVIEW + 20 + LINE_HEIGHT];
    [self.scrollView addSubview:self.headView];
    
    self.infoView = [self createInfoViewWithY:self.headView.frame.origin.y + self.headView.frame.size.height + SPACE_VIEW AndHeight:LINE_HEIGHT*4];
    [self.scrollView addSubview:self.infoView];
    
    self.footView = [self createFootViewWithY:self.infoView.frame.origin.y + self.infoView.frame.size.height + SPACE_VIEW AndHeight:LINE_HEIGHT];
    [self.scrollView addSubview:self.footView];
    
    self.moreView = [self createMoreViewWithY:NAVIGATIOINBARHEIGHT];
    self.moreView.hidden = YES;
    [self.view addSubview:self.moreView];
    
    [self resetScrollViewContentSize];
    
    [self getGoodsDataFromService];
    
}

//创建scrollView
-(UIScrollView* )createScrollViewWithY:(CGFloat )origin_y {
    UIScrollView* sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, self.view.frame.size.height - origin_y)];
    sv.backgroundColor = BACKGROUNGCOLOR_GRAY1;
    sv.showsHorizontalScrollIndicator = NO;
    sv.showsVerticalScrollIndicator = YES;
    return sv;
}

//创建headView
-(UIView* )createHeadViewWithY:(CGFloat )origin_y AndHeight:(CGFloat )frame_height {
    self.imagesArr = [NSMutableArray array];
    UIView* vi = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, frame_height)];
    vi.backgroundColor = COLOR_WHITE1;
    UIView* photosView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HEIGHT_PHOTOVIEW)];
    [vi addSubview:photosView];
    for (int i = 0; i < self.goods.goodsImageAddrList.count; i++) {
        UIImageView* iv = [[UIImageView alloc]initWithFrame:CGRectMake((i%4)*WIDTH_IMAGEVIEW + SPACE_IMAGEVIEW*(i%4+1), (i/4)*WIDTH_IMAGEVIEW + SPACE_IMAGEVIEW*(i/4+1), WIDTH_IMAGEVIEW, WIDTH_IMAGEVIEW)];
        NSString* imagePath = self.goods.goodsImageAddrList[i];
        NSURL* imageURL = [NSURL URLWithString:imagePath];
        
        [iv sd_setImageWithPreviousCachedImageWithURL:imageURL andPlaceholderImage:DEFAULT_HEADIMAGE options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            iv.tag = i+1;
            iv.userInteractionEnabled = YES;
            UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
            [iv addGestureRecognizer:tapGR];
            [self.imagesArr addObject:iv.image];
        }];
        
        
        [photosView addSubview:iv];
    }
    
    self.nameLab = [self createLabelWithRect:CGRectMake(SPACE_LABEL, photosView.frame.origin.y + photosView.frame.size.height, self.view.frame.size.width - SPACE_LABEL*2, 20) AndText:nil];
    self.nameLab.textAlignment = NSTextAlignmentCenter;
    [vi addSubview:self.nameLab];
    
    UIImageView* lineIV = [self createLineImageViewWithRect:CGRectMake(0, self.nameLab.frame.origin.y + self.nameLab.frame.size.height + 5, self.view.frame.size.width, 1)];
    [vi addSubview:lineIV];
    
    self.detailLab = [self createLabelWithRect:CGRectMake(SPACE_LABEL, lineIV.frame.origin.y + lineIV.frame.size.height + 5, self.view.frame.size.width - SPACE_LABEL*2, LINE_HEIGHT) AndText:nil];
    [vi addSubview:self.detailLab];
    
    return vi;
}

//点击了照片
-(void)tapImageView:(UITapGestureRecognizer* )tap {
    NSInteger index = tap.view.tag;
    HBCheckGoodsImagesViewController* HBCGIVVC = [[HBCheckGoodsImagesViewController alloc]init];
    HBCGIVVC.imageArray = [NSMutableArray arrayWithArray:self.imagesArr];
    HBCGIVVC.selectedImage = self.imagesArr[index-1];
    HBCGIVVC.currentIndex = index - 1;
    [self.navigationController pushViewController:HBCGIVVC animated:NO];
}

//创建infoView
-(UIView* )createInfoViewWithY:(CGFloat )origin_y AndHeight:(CGFloat )frame_height {
    UIView* vi = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, frame_height)];
    vi.backgroundColor = COLOR_WHITE1;
    NSArray* stringArr = @[@"所在地区",@"邮费支付",@"截止时间",@"所属用户"];
    CGFloat width_Label = 70;
    for (int i = 0; i < 4; i++) {
        UILabel* lab = [self createLabelWithRect:CGRectMake(SPACE_LABEL, LINE_HEIGHT*i + (LINE_HEIGHT-20)/2, width_Label, 20) AndText:stringArr[i]];
        [vi addSubview:lab];
        
        UIImageView* lineIV = [self createLineImageViewWithRect:CGRectMake(0, LINE_HEIGHT*(i+1), self.view.frame.size.width, 1)];
        [vi addSubview:lineIV];
        
        UILabel* displayLab = [self createDisplayLabelWithRect:CGRectMake(SPACE_LABEL*2 + width_Label, lab.frame.origin.y, self.view.frame.size.width - SPACE_LABEL*3 - width_Label, 20)];
        switch (i) {
            case 0:
                self.placeLab = displayLab;
                [vi addSubview:self.placeLab];
                break;
            case 1:
                self.postTypeLab = displayLab;
                [vi addSubview:self.postTypeLab];
                break;
            case 2:
                self.sendTimeLab = displayLab;
                [vi addSubview:self.sendTimeLab];
                break;
            case 3:
                self.ofUser = displayLab;
                [vi addSubview:self.ofUser];
                break;
            default:
                break;
        }
    }
    return vi;
}

//创建 所在地区——所属用户 label
-(UILabel* )createLabelWithRect:(CGRect )rect AndText:(NSString* )textStr {
    UILabel* lab = [[UILabel alloc]initWithFrame:rect];
    lab.textColor = COLOR_BLACK1;
    lab.font = FONT_17;
    lab.text = textStr;
    return lab;
}

//创建显示 所在地区——所属用户 label
-(UILabel* )createDisplayLabelWithRect:(CGRect )rect {
    UILabel* displayLab = [[UILabel alloc]initWithFrame:rect];
    displayLab.textColor = COLOR_GRAY1;
    displayLab.font = FONT_17;
    displayLab.textAlignment = NSTextAlignmentRight;
    return displayLab;
}

//创建 线
-(UIImageView* )createLineImageViewWithRect:(CGRect )rect {
    UIImageView* line = [[UIImageView alloc]initWithFrame:rect];
    line.image = [UIImage imageNamed:@"line.png"];
    return line;
}

-(UIView* )createFootViewWithY:(CGFloat )origin_y AndHeight:(CGFloat )frame_height {
    
    UIView* vi = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, frame_height)];
    vi.backgroundColor = COLOR_WHITE1;
    
    for (int i = 0; i < 3; i++) {
        if (i == 0) {
            self.likeBtn = [self createLikeWantShareButtonWithI:i];
            [vi addSubview:self.likeBtn];
            self.likeNumLab = [self createLikeWantShareLabel];
            self.likeNumLab.text = @"喜欢";
            [self.likeBtn addSubview:self.likeNumLab];
        }else if (i == 1) {
            self.wantBtn = [self createLikeWantShareButtonWithI:i];
            [vi addSubview:self.wantBtn];
            self.wantNumLab = [self createLikeWantShareLabel];
            self.wantNumLab.text = @"想要";
            [self.wantBtn addSubview:self.wantNumLab];
        }else if (i == 2) {
            self.shareBtn = [self createLikeWantShareButtonWithI:i];
            [vi addSubview:self.shareBtn];
            self.shareLab = [self createLikeWantShareLabel];
            self.shareLab.text = @"分享";
            [self.shareBtn addSubview:self.shareLab];
        }
        
    }
    return vi;
}

//创建喜欢 想要 分享按钮
-(UIButton* )createLikeWantShareButtonWithI:(int )i {
    CGFloat width_button = self.view.frame.size.width/3;
    CGFloat width_imageView = (width_button - 20)/2;
    NSArray* picNameArr = @[@"like.png", @"want.png", @"share.png"];
    NSArray* selectedPicNameArr = @[@"like_1.png", @"want_1.png", @"share.png"];
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(width_button*i, 0, width_button, LINE_HEIGHT)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, width_imageView, 20, width_imageView)];
    [btn setImage:[UIImage imageNamed:picNameArr[i]] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectedPicNameArr[i]] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(clickedLikeWantShareButton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

//创建喜欢 想要 分享label
-(UILabel* )createLikeWantShareLabel {
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width/3, 20)];
    lab.font = FONT_17;
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

//点击喜欢 想要 分享按钮
-(void)clickedLikeWantShareButton:(UIButton* )sender {
    if (self.ifUndercarriage == NO) {
        if (sender == self.likeBtn) {
            NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/goods/likeGoods.do"];
            NSString* argumentStr = [NSString stringWithFormat:@"goodsId=%ld&myId=%ld&apiKey=%@", self.goods.goodsId, USERID, APIKEY];
            [self cancleLikeGoodsWithURLStr:urlStr AndArgumentStr:argumentStr];
        }else if (sender == self.wantBtn) {
            if (self.user.userID == USERID) {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"不能想要自己分享的物品" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [av show];
            }else {
                NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/goods/wantGoods.do"];
                NSString* argumentStr = [NSString stringWithFormat:@"goodsId=%ld&myId=%ld&apiKey=%@", self.goods.goodsId, USERID, APIKEY];
                [self cancleWantGoodsWithURLStr:urlStr AndArgumentStr:argumentStr];
            }
        }else if (sender == self.shareBtn) {
            [self shareGoodsWithButton:self.shareBtn];
        }
    }else {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"此物品已过期" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [av show];
    }
}


//
-(void)cancleLikeGoodsWithURLStr:(NSString* )urlStr AndArgumentStr:(NSString* )argumentStr {
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                if (self.likeBtn.selected == YES) {
                    self.likeNum--;
                }else {
                    self.likeNum++;
                }
                self.likeBtn.selected = !self.likeBtn.selected;
                self.likeNumLab.text = [NSString stringWithFormat:@"喜欢(%ld)", self.likeNum];
            }else if ([jsonDic[@"status"]integerValue] == -1) {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"喜欢物品失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [av show];
            }
        });
    }];
}

//
-(void)cancleWantGoodsWithURLStr:(NSString* )urlStr AndArgumentStr:(NSString* )argumentStr {
    if (self.user.userID > 0 && self.user.userID == USERID) {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您不能喜欢自己分享物品" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [av show];
    }else {
        [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
            NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"jsonDic=%@", jsonDic);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([jsonDic[@"status"]integerValue] == 1) {
                    if (self.wantBtn.selected == YES) {
                        self.wantNum--;
                    }else {
                        self.wantNum++;
                    }
                    self.wantBtn.selected = !self.wantBtn.selected;
                    self.wantNumLab.text = [NSString stringWithFormat:@"想要(%ld)", self.wantNum];
                }else if ([jsonDic[@"status"]integerValue] == -1) {
                    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"喜欢物品失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [av show];
                }else if ([jsonDic[@"status"]integerValue] == -2) {
                    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"对方不允许你参与TA的共享" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [av show];
                }
            });
        }];
    }
}

//从服务器获取物品数据
-(void)getGoodsDataFromService {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/goods/findGoodsById.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"goodsId=%ld&myId=%ld&apiKey=%@", self.goods.goodsId, USERID, APIKEY];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"resultStr=%@", resultStr);
        
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                self.goodsDic = jsonDic[@"goods"];
                if ([self.goodsDic[@"meLike"]integerValue] == 0) {
                    self.likeBtn.selected = NO;
                }else {
                    self.likeBtn.selected = YES;
                }
                if ([self.goodsDic[@"meWant"]integerValue] == 0) {
                    self.wantBtn.selected = NO;
                }else {
                    self.wantBtn.selected = YES;
                }
                if ([self.goodsDic[@"ifUndercarriage"]integerValue] == 1) {
                    self.ifUndercarriage = YES;
                    
                }else if ([self.goodsDic[@"ifUndercarriage"]integerValue] == 0){
                    self.ifUndercarriage = NO;
                }
                
                self.nameLab.text = self.goods.name;
                self.detailLab.text =  self.goodsDic[@"description"];
                
                NSDictionary* cityDic = self.goodsDic[@"city"];
                NSDictionary* provinceDic = self.goodsDic[@"province"];
                self.placeLab.text = [NSString stringWithFormat:@"%@%@", provinceDic[@"provinceName"], cityDic[@"cityName"]];
                self.postTypeLab.text = self.goods.postageType==YES?@"收方付":@"送方付";
                NSTimeInterval timeInterval = [self.goodsDic[@"expireTime"]doubleValue];
                self.sendTimeLab.text = [[HBTool shareTool]currentTimeWithTimeStamp:timeInterval];
                
                self.user = [[HBUser alloc]init];
                NSDictionary* userInfo = self.goodsDic[@"owner"];
                self.user.nickName = userInfo[@"nickName"];
                self.ofUser.text = self.user.nickName;
                self.likeNum = [self.goodsDic[@"likeNum"]integerValue];
                self.likeNumLab.text = [NSString stringWithFormat:@"喜欢(%ld)", self.likeNum];
                self.wantNum = [self.goodsDic[@"wantNum"]integerValue];
                self.wantNumLab.text = [NSString stringWithFormat:@"想要(%ld)", self.wantNum];
                
                if (self.ifUndercarriage == YES) {
                    [self createNavigationMoreButton];
                }
                
                [self resetScrollViewContentSize];
            }else {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"该物品已被删除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [av show];
            }
        });
    }];
}

//如果该物品属于自己的 则在导航栏右上角添加"..."按钮
-(void)createNavigationMoreButton {
    NSDictionary* userInfoDic = self.goodsDic[@"owner"];
    self.user.userID = [userInfoDic[@"userId"]integerValue];
    NSInteger myID = USERID;
    if (self.user.userID == myID) {
        UIButton* moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"barItem_More.png"] forState:UIControlStateNormal];
        UIBarButtonItem* moreItem = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
        self.navigationItem.rightBarButtonItem = moreItem;
        
        [moreBtn addTarget:self action:@selector(clickedNavigationMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(UIView* )createMoreViewWithY:(CGFloat )origin_y {
    UIView* vi = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 120 - 20, origin_y, 120, LINE_HEIGHT*2)];
    vi.backgroundColor = COLOR_BLACK1;
    NSArray* imageNameArr = @[@"republishGoods.png", @"delete.png"];
    NSArray* textArr = @[@"上传到期物品", @"删除到期物品"];
    for (int i = 0; i < 2; i++) {
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, LINE_HEIGHT*i, vi.frame.size.width, LINE_HEIGHT)];
        btn.tag = 200 + i;
        [btn addTarget:self action:@selector(clickedMoreViewButton:) forControlEvents:UIControlEventTouchUpInside];
        [vi addSubview:btn];
        
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
        imageView.image = [UIImage imageNamed:imageNameArr[i]];
        [btn addSubview:imageView];
        
        UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width, imageView.frame.origin.y, btn.frame.size.width - imageView.frame.size.width, 20)];
        lab.text = textArr[i];
        lab.font = FONT_15;
        lab.textColor = COLOR_WHITE1;
        lab.textAlignment = NSTextAlignmentRight;
        [btn addSubview:lab];
    }
    return vi;
}

//点击了"..."按钮
-(void)clickedNavigationMoreButton:(UIButton* )sender {
    self.moreView.hidden = !self.moreView.hidden;
}

//点击 上传到期物品 删除到期物品
-(void)clickedMoreViewButton:(UIButton* )sender {
    NSString* urlStr;
    NSString* argumentStr = [NSString stringWithFormat:@"goodsId=%ld&myId=%ld&apiKey=%@", self.goods.goodsId, USERID, APIKEY];
    if (sender.tag == 200) {
        urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/goods/republishGoods.do"];
    }else if (sender.tag == 201) {
        urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/goods/deleteGoods.do"];
    }

    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"resultStr=%@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                if (sender.tag == 200) {
                    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"上传到期物品成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    av.tag = 50;
                    [av show];
                }else if (sender.tag == 201) {
                    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"删除到期物品成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    av.tag = 51;
                    [av show];
                }
            }else {
                if (sender.tag == 200) {
                    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"上传到期物品失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [av show];
                }else if (sender.tag == 201) {
                    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"删除到期物品失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    [av show];
                }
            }
        });
    }];
}

//上传到期物品 删除到期物品 成功后返回上一个界面
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 50) {//上传到期物品成功
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (alertView.tag == 51) {//删除到期物品成功
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (alertView.tag == 52) {//查询物品详情时，该物品已不存在了，则返回
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

//获取 物品详情label 的自适应高
-(CGFloat )getLabelHeightWithText:(NSString* )textString {
    CGSize labelSize = [textString boundingRectWithSize:CGSizeMake(self.detailLab.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_17} context:nil].size;
    return labelSize.height>20?labelSize.height:20;
}

//设置scrollView滑动范围
-(void)resetScrollViewContentSize {
    CGFloat detailLabelHeight;
    if (self.detailLab.text.length > 0) {
        detailLabelHeight = [self getLabelHeightWithText:self.detailLab.text];
    }else {
        detailLabelHeight = [self getLabelHeightWithText:@""];
    }
    self.detailLab.frame = CGRectMake(self.detailLab.frame.origin.x, self.detailLab.frame.origin.y, self.detailLab.frame.size.width, detailLabelHeight);
    self.detailLab.numberOfLines = 20;
    self.detailLab.textAlignment = NSTextAlignmentLeft;
    self.headView.frame = CGRectMake(self.headView.frame.origin.x
                                     , self.headView.frame.origin.y, self.headView.frame.size.width, self.headView.frame.size.height + detailLabelHeight - 20);
    
    self.infoView.frame = CGRectMake(self.infoView.frame.origin.x, self.headView.frame.origin.y + self.headView.frame.size.height + SPACE_VIEW, self.infoView.frame.size.width, self.infoView.frame.size.height);
    self.footView.frame = CGRectMake(self.footView.frame.origin.x, self.infoView.frame.origin.y + self.infoView.frame.size.height + SPACE_VIEW, self.footView.frame.size.width, self.footView.frame.size.height);
    [self.scrollView setContentSize:CGSizeMake(0, self.headView.frame.size.height + self.infoView.frame.size.height + self.footView.frame.size.height + SPACE_VIEW*3)];
}

-(void)shareGoodsWithButton:(UIButton* )sender {
    id<ISSCAttachment> image = [ShareSDK jpegImageWithImage:self.imagesArr[0] quality:0.5];
    
    //构造分享微信朋友圈、QQ空间、微博内容
    id<ISSContent> publishContent_Public = [ShareSDK content:[NSString stringWithFormat:@"发现一个共享宝贝：%@，免费获取，赶紧下手，截止时间:%@", self.nameLab.text, self.sendTimeLab.text]
                                              defaultContent:@"心跳吧分享"
                                                       image:image
                                                       title:@"寻找小伙伴"
                                                         url:@"http://www.xintiao8.com"
                                                 description:@"心跳吧分享"
                                                   mediaType:SSPublishContentMediaTypeNews];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
