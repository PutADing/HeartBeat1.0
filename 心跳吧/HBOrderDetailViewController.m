//
//  HBOrderDetailViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/21.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBOrderDetailViewController.h"
#import "HBTool.h"
#import "HBUser.h"
#import "HBCheckGoodsImagesViewController.h"
#import <UIImageView+WebCache.h>

@interface HBOrderDetailViewController ()
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)UIView* headView;//头 视图
@property (nonatomic, strong)UIView* infoView;//所在地区——所属用户 视图
@property (nonatomic, strong)UILabel* nameLab;//宝贝标题
@property (nonatomic, strong)UILabel* detailLab;//宝贝详情
@property (nonatomic, strong)UILabel* placeLab;//所在地区
@property (nonatomic, strong)UILabel* postTypeLab;//邮费支付
@property (nonatomic, strong)UILabel* sendTimeLab;//截止时间
@property (nonatomic, strong)UILabel* ofUser;//所属用户

@property (nonatomic, strong)NSMutableArray* imagesArr;//存放image对象
@property (nonatomic, strong)NSDictionary* goodsDic;//物品详情数据
@property (nonatomic, strong)HBUser* user;//物品所属用户

@end

@implementation HBOrderDetailViewController

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
        
        
        //        [iv sd_setImageWithURL:imageURL placeholderImage:DEFAULT_HEADIMAGE options:SDWebImageRetryFailed];
        
        [iv sd_setImageWithURL:imageURL placeholderImage:DEFAULT_HEADIMAGE completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
                
                [self resetScrollViewContentSize];
            }else {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"该物品已被删除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [av show];
            }
        });
    }];
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
    [self.scrollView setContentSize:CGSizeMake(0, self.headView.frame.size.height + self.infoView.frame.size.height + SPACE_VIEW*2)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
