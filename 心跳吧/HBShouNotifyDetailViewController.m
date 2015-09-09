//
//  HBShouNotifyDetailViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/28.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBShouNotifyDetailViewController.h"
#import "HBPayViewController.h"
#import "HBMyHopeViewController.h"
#import "HBUser.h"
#import "HBGoods.h"
#import "HBGoodsDetailViewController.h"
#import "HBSelectAddressViewController.h"

@interface HBShouNotifyDetailViewController ()
@property (nonatomic, strong)UILabel* senderLab;//寄件人
@property (nonatomic, strong)UILabel* goodsNameLab;//物品名称
@property (nonatomic, strong)UILabel* fromPlaceLab;//来自地区
@property (nonatomic, strong)UILabel* postTypeLab;//邮费支付方式
@property (nonatomic, strong)UILabel* addressLab;//添加收货地址
@property (nonatomic, strong)UIButton* sendBtn;//申请发件

@property (nonatomic, strong)NSDictionary* orderDic;//
@property (nonatomic, strong)NSDictionary* senderDic;//
@property (nonatomic, strong)NSDictionary* goodsDic;//
@property (nonatomic, assign)BOOL ifPaid;//标记邮费是否已付

@property (nonatomic, assign)NSInteger provinceId;//省份id
@property (nonatomic, assign)NSInteger cityId;//市id
@property (nonatomic, assign)NSInteger districtId;//区县id
@property (nonatomic, copy)NSString* personName;//联系人
@property (nonatomic, copy)NSString* telphone;//联系电话
@property (nonatomic, copy)NSString* detailAddr;//详细地址

@end

@implementation HBShouNotifyDetailViewController

//行高
#define LINE_HEIGHT 50
//label 距离左间距  宽
#define SPACE_LABEL 10
#define WIDTH_LABEL 105

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"快件详情";
    self.view.backgroundColor = BACKGROUNGCOLOR_GRAY1;
    
    [self initSubviewsWithY:NAVIGATIOINBARHEIGHT];
    
    
    [self initData];
    
    NSString* urlMethod = @"rest/goods/getRecvNotificationDetail.do";
    NSInteger notifyId = [self.notifyDic[@"id"]integerValue];;
    NSString* argumentStr = [NSString stringWithFormat:@"notifyId=%ld&myId=%ld&apiKey=%@", notifyId, USERID, APIKEY];
    [self getShouNotifyDetailFromServiceWithURLMethod:urlMethod AndArgumentString:argumentStr];
}

-(void)initSubviewsWithY:(CGFloat )origin_y {
    NSArray* textArr = @[@"寄件人", @"物品名称", @"来自地区", @"邮费支付方式", @"添加收货地址"];
    for (int i = 0; i < 4; i++) {
        UIButton* button = [self createCellButtonWithRect:CGRectMake(0, LINE_HEIGHT*i + origin_y, self.view.frame.size.width, LINE_HEIGHT) AndLabelText:textArr[i]];
        button.tag = 10+i;
        [self.view addSubview:button];
        if (i == 0) {
            self.senderLab = [self createDisplayLabeWithSuperview:button JianTouOrNot:YES];
        }else if (i == 1) {
            self.goodsNameLab = [self createDisplayLabeWithSuperview:button JianTouOrNot:YES];
        }else if (i == 2) {
            self.fromPlaceLab = [self createDisplayLabeWithSuperview:button JianTouOrNot:NO];
        }else if (i == 3) {
            self.postTypeLab = [self createDisplayLabeWithSuperview:button JianTouOrNot:NO];
        }
    }
    UIButton* addressBtn = [self createCellButtonWithRect:CGRectMake(0, LINE_HEIGHT*4 + origin_y + 15, self.view.frame.size.width, LINE_HEIGHT) AndLabelText:textArr[4]];
    addressBtn.tag = 14;
    self.addressLab = [self createDisplayLabeWithSuperview:addressBtn JianTouOrNot:YES];
    [self.view addSubview:addressBtn];
    
    self.sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4, addressBtn.frame.origin.y + LINE_HEIGHT + 15, self.view.frame.size.width/2, 35)];
    self.sendBtn.backgroundColor = COLOR_BLACK1;
    self.sendBtn.titleLabel.font = FONT_20;
    [self.sendBtn addTarget:self action:@selector(clickedShouButton:) forControlEvents:UIControlEventTouchUpInside];
    self.sendBtn.layer.cornerRadius = 4;
    self.sendBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.sendBtn];
    self.sendBtn.hidden = YES;
}

//创建单元行 button
-(UIButton* )createCellButtonWithRect:(CGRect )rect AndLabelText:(NSString* )textStr {
    UIButton* btn = [[UIButton alloc]initWithFrame:rect];
    btn.backgroundColor = COLOR_WHITE1;
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_LABEL, 15, WIDTH_LABEL, 20)];
    lab.text = textStr;
    lab.textColor = COLOR_BLACK1;
    lab.font = FONT_17;
    [btn addSubview:lab];
    UIImageView* lineIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, LINE_HEIGHT - 1, self.view.frame.size.width, 1)];
    lineIV.image = [UIImage imageNamed:@"line.png"];
    [btn addSubview:lineIV];
    [btn addTarget:self action:@selector(clickedCellButton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

//创建显示 寄件人——邮费支付方式 label
-(UILabel* )createDisplayLabeWithSuperview:(UIButton* )superBtn JianTouOrNot:(BOOL )isMore {
    UILabel* lab = [[UILabel alloc]init];
    if (isMore) {
        lab.frame = CGRectMake(SPACE_LABEL*2 + WIDTH_LABEL, 15, self.view.frame.size.width - SPACE_LABEL*2 - 16 - WIDTH_LABEL, 20);
        UIImageView* jianTouIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 16, (LINE_HEIGHT - 16)/2, 16, 16)];
        jianTouIV.image = [UIImage imageNamed:@"jianTou.png"];
        [superBtn addSubview:jianTouIV];
        
    }else {
        lab.frame = CGRectMake(SPACE_LABEL*2 + WIDTH_LABEL, 15, self.view.frame.size.width - SPACE_LABEL*2 - WIDTH_LABEL, 20);
    }
    lab.textAlignment = NSTextAlignmentRight;
    lab.textColor = COLOR_GRAY1;
    lab.font = FONT_17;
    [superBtn addSubview:lab];
    return lab;
}

-(void)initData {
    self.orderDic = self.notifyDic[@"order"];
    self.goodsDic = self.orderDic[@"goods"];
    self.senderDic = self.goodsDic[@"owner"];
    
    self.senderLab.text = self.senderDic[@"nickName"];
    self.goodsNameLab.text = self.goodsDic[@"name"];
    NSDictionary* provinceDic = self.goodsDic[@"province"];
    self.fromPlaceLab.text = provinceDic[@"provinceName"];
    NSInteger postageType = [self.goodsDic[@"postageType"]integerValue];
    if (postageType == 0) {
        self.postTypeLab.text = @"寄方付";
    }else if (postageType == 1) {
        self.postTypeLab.text = @"收方付";
    }
    
    {
        /*
         NiShoujsonDic={
         msg = "\U67e5\U8be2\U6210\U529f";
         notifyList =     (
         {
         id = 68;
         notifyTime = "<null>";
         order =             {
         goods =                 {
         city =                     {
         cityId = 320500;
         cityName = "\U82cf\U5dde\U5e02";
         };
         description = "\U6211\U662f\U4e00\U4e2a\U597d\U4eba\U6211\U662f\U4e00\U4e2a\U597d\U4eba\U6211\U662f\U4e00\U4e2a\U597d\U4eba\U6211\U662f\U4e00\U4e2a\U597d\U4eba\U6211\U662f\U4e00\U4e2a\U597d\U4eba\U6211\U662f\U4e00\U4e2a\U597d\U4eba\U6211\U662f\U4e00\U4e2a\U597d\U4eba\U6211\U662f\U4e00\U4e2a\U597d\U4eba\U6211\U662f\U4e00\U4e2a\U597d\U4eba\U6211\U662f\U4e00\U4e2a\U597d\U4eba\U6211\U662f\U4e00\U4e2a\U597d\U4eba\U6211\U662f\U4e00\U4e2a\U597d\U4eba\U6211\U662f\U4e00\U4e2a\U597d\U4eba\U6211\U662f\U53ea\U548c\U597d\U4eba\U6211\U662f\U4e00\U4e2a\U4eba\U54ed\U4e86\U89e3\U4e86\U89e3\U91ca\U7136\U540e\U63f4\U624b\U673a\U5668\U4eba\U5386\U9669\U8bb0\U5fc6\U8ff7\U5c40\U9762\U7684\U786e\U4fdd\U62a4\U6cd5\U56fd\U5185\U5bb9\U7eb3\U5170\U9999\U6e2f\U7279\U533a\U57df\U540d\U535a\U6587\U6848\U5934\U53d1\U51fa\U53bb\U8d70\U8d70\U4e86";
         goodsId = 77;
         goodsImageAddrList =                     (
         "http://heartbeat-goods.oss-cn-hangzhou.aliyuncs.com/Android_HeartBeat_20150517151548_0_82.png",
         "http://heartbeat-goods.oss-cn-hangzhou.aliyuncs.com/Android_HeartBeat_20150517151548_1_82.png",
         "http://heartbeat-goods.oss-cn-hangzhou.aliyuncs.com/Android_HeartBeat_20150517151548_2_82.jpg",
         "http://heartbeat-goods.oss-cn-hangzhou.aliyuncs.com/Android_HeartBeat_20150517151548_3_82.jpg",
         "http://heartbeat-goods.oss-cn-hangzhou.aliyuncs.com/Android_HeartBeat_20150517151548_4_82.png",
         "http://heartbeat-goods.oss-cn-hangzhou.aliyuncs.com/Android_HeartBeat_20150517151548_5_82.png"
         );
         name = "\U53ef\U7231\U7684\U964c\U751f\U4eba";
         owner =                     {
         avatar = "<null>";
         gender = "<null>";
         heartbeatNumber = z66wg64sc;
         nickName = Murph;
         personalizedSignature = "<null>";
         userId = 82;
         };
         postageType = 0;
         province =                     {
         provinceId = 320000;
         provinceName = "\U6c5f\U82cf\U7701";
         };
         };
         id = 68;
         orderNumber = 15051716160002;
         };
         }
         );
         status = 1;
         }
         */
    }
}

//获取收件通知详情
-(void)getShouNotifyDetailFromServiceWithURLMethod:(NSString* )urlMethod AndArgumentString:(NSString* )argumentStr {
    NSString* urlString = [NSString stringWithFormat:@"%@%@", HBURL, urlMethod];
    [[HBTool shareTool]postURLConnectionWithURL:urlString andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"shouNotifyDetailStr=%@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"shouNotifyDetailDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                NSDictionary* dic = jsonDic[@"notify"];
//                NSInteger status = [dic[@"status"]integerValue];//是否已申请发货
                NSInteger ifPay = [dic[@"ifPay"]integerValue];//是否已经付款
                NSInteger orderStatus = [dic[@"orderStatus"]integerValue];//订单状态 是否已过期
                
                if (orderStatus == -3) {//订单已过期
                    self.sendBtn.hidden = NO;
                    self.sendBtn.backgroundColor = COLOR_GRAY1;
                    [self.sendBtn setTitle:@"订单已过期" forState:UIControlStateNormal];
                    self.sendBtn.enabled = NO;
                }else {
                    if (ifPay == 0) {//未付款
                        self.sendBtn.hidden = NO;
                        self.sendBtn.backgroundColor = COLOR_BLUE1;
                        [self.sendBtn setTitle:@"申请发快件" forState:UIControlStateNormal];
                        self.sendBtn.enabled = YES;
                        
                    }else if (ifPay == 1) {//已付款
                        self.sendBtn.hidden = NO;
                        self.sendBtn.backgroundColor = COLOR_GRAY1;
                        [self.sendBtn setTitle:@"此订单已处理" forState:UIControlStateNormal];
                        self.sendBtn.enabled = NO;
                    }
                }
                
            }
        });
    }];
}

//点击单元行
-(void)clickedCellButton:(UIButton* )sender {
    if (sender.tag == 10) {//寄件人
        HBMyHopeViewController* HBMyHopeVC = [[HBMyHopeViewController alloc]init];
        HBUser* user = [[HBUser alloc]init];
        user.userID = [self.senderDic[@"userId"]integerValue];
        user.heartBeatNumber = self.senderDic[@"heartbeatNumber"];
        user.nickName = self.senderDic[@"nickName"];
        if ([self.senderDic[@"avatar"] isKindOfClass:[NSNull class]]) {
            
        }else {
            user.avatar = self.senderDic[@"avatar"];
        }
        if ([self.senderDic[@"personalizedSignature"] isKindOfClass:[NSNull class]]) {
            
        }else {
            user.personalizedSignature = self.senderDic[@"personalizedSignature"];
        }
        HBMyHopeVC.user = user;
        [self.navigationController pushViewController:HBMyHopeVC animated:NO];

    }else if (sender.tag == 11) {//物品名称
        HBGoods* tempGoods = [[HBGoods alloc]init];
        tempGoods.goodsId = [self.goodsDic[@"goodsId"]integerValue];
        tempGoods.goodsImageAddrList = self.goodsDic[@"goodsImageAddrList"];
        tempGoods.name = self.goodsDic[@"name"];
        tempGoods.postageType = self.goodsDic[@"postageType"];
        
        HBGoodsDetailViewController* HBGoodsDetailVC = [[HBGoodsDetailViewController alloc]init];
        HBGoodsDetailVC.goods = tempGoods;
        [self.navigationController pushViewController:HBGoodsDetailVC animated:NO];
        
    }else if (sender.tag == 12) {//来自地区
        
    }else if (sender.tag == 13) {//邮费支付方式
        
    }else if (sender.tag == 14) {//添加收货地址
        HBSelectAddressViewController* HBSelectAddressVC = [[HBSelectAddressViewController alloc]init];
        [HBSelectAddressVC returnSelectedAddress:^(NSString *provinceName, NSInteger provinceId, NSString *cityName, NSInteger cityId, NSString *districtName, NSInteger districtId, NSString* nameString, NSString* phoneNumStr, NSString* detailString) {
            self.provinceId = provinceId;
            self.cityId = cityId;
            self.districtId = districtId;
            self.personName = nameString;
            self.telphone = phoneNumStr;
            self.detailAddr = detailString;
            self.addressLab.text = [NSString stringWithFormat:@"%@%@,%@,%@", provinceName, cityName, nameString, phoneNumStr];
        }];
        
        [self.navigationController pushViewController:HBSelectAddressVC animated:NO];
    }
}

//点击 申请发件 按钮
-(void)clickedShouButton:(UIButton* )sender {
    if (sender == self.sendBtn) {
        if ([[self.sendBtn titleForState:UIControlStateNormal]isEqualToString:@"申请发快件"]) {
            if (self.addressLab.text.length > 0) {
                NSInteger postType = [self.goodsDic[@"postageType"]integerValue];
                NSInteger notifyId = [self.notifyDic[@"id"]integerValue];
                NSString* argumentStr = [NSString stringWithFormat:@"orderId=&notifyId=%ld&provinceId=%ld&cityId=%ld&districtId=%ld&personName=%@&telphone=%@&detailAddr=%@&myId=%ld&apiKey=%@", notifyId, self.provinceId, self.cityId, self.districtId, self.personName, self.telphone, self.detailAddr, USERID, APIKEY];
                
                if (postType == 1) {//收方付
                    
                    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/goods/submitOrder.do"];
                    [self submitOrderWithURLStr:urlStr AndArgumentStr:argumentStr];
                    
                }else if (postType == 0) {//寄方付
                    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/goods/submitOrderSelfPay.do"];
                    [self submitOrderSelfPayWithURLStr:urlStr AndArgumentStr:argumentStr];
                }
                
            }else {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"收货地址不能为空" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [av show];
            }
        }
    }
}

//收方付邮费 申请发快件并跳转至支付界面
-(void)submitOrderWithURLStr:(NSString* )urlStr AndArgumentStr:(NSString* )argumentStr {
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"submitOrder_resultStr=%@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"submitOrder_jsonDic=%@", jsonDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                
                double price = [jsonDic[@"postage"]doubleValue];
                HBPayViewController* HBPayVC = [HBPayViewController sharePayViewController];
                HBPayVC.orderId = self.orderDic[@"orderNumber"];
                HBPayVC.postageValue = price;
                HBPayVC.goodsName = self.goodsDic[@"name"];
                HBPayVC.goodsDescription = self.goodsDic[@"description"];
                [self.navigationController pushViewController:HBPayVC animated:NO];
                
            }else if ([jsonDic[@"status"]integerValue] == -1) {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"申请发件失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [av show];
            }
        });
    }];
}

//寄方付邮费 直接申请发快件
-(void)submitOrderSelfPayWithURLStr:(NSString* )urlStr AndArgumentStr:(NSString* )argumentStr {
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"submitOrderSelfPay_resultStr=%@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"submitOrderSelfPay_jsonDic=%@", jsonDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                self.sendBtn.hidden = NO;
                self.sendBtn.backgroundColor = COLOR_GRAY1;
                [self.sendBtn setTitle:@"此订单已处理" forState:UIControlStateNormal];
                self.sendBtn.enabled = NO;
                
            }else {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"申请发快件失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [av show];
            }
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
