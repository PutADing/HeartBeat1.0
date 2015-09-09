//
//  HBSongNotifyDetailViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/28.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBSongNotifyDetailViewController.h"
#import "HBTool.h"
#import "HBSelectAddressViewController.h"
#import "HBGoods.h"
#import "HBGoodsDetailViewController.h"
#import "HBMyHopeViewController.h"
#import "HBUser.h"
#import "HBPayViewController.h"

@interface HBSongNotifyDetailViewController ()
@property (nonatomic, strong)UILabel* receiverLab;//收件人
@property (nonatomic, strong)UILabel* goodsNameLab;//物品名称
@property (nonatomic, strong)UILabel* toPlaceLab;//到达地区
@property (nonatomic, strong)UILabel* postTypeLab;//邮费支付方式
@property (nonatomic, strong)UILabel* addressLab;//上门取货地址
@property (nonatomic, strong)UIButton* sendBtn;//确认发快件

@property (nonatomic, strong)NSDictionary* orderDic;
@property (nonatomic, strong)NSDictionary* receiverDic;
@property (nonatomic, strong)NSDictionary* goodsDic;

@property (nonatomic, assign)NSInteger provinceId;//省份id
@property (nonatomic, assign)NSInteger cityId;//市id
@property (nonatomic, assign)NSInteger districtId;//区县id
@property (nonatomic, copy)NSString* personName;//联系人
@property (nonatomic, copy)NSString* telphone;//联系电话
@property (nonatomic, copy)NSString* detailAddr;//详细地址

@end

@implementation HBSongNotifyDetailViewController

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
    
    
    NSString* urlMethod = @"rest/goods/getSendNotificationDetail.do";
    NSInteger notifyId = [self.notifyDic[@"id"]integerValue];
    NSString* argumentStr = [NSString stringWithFormat:@"notifyId=%ld&myId=%ld&apiKey=%@", notifyId, USERID, APIKEY];
    [self getSongNotifyDetailFromServiceWithURLMethod:urlMethod AndArgumentString:argumentStr];
}

-(void)initSubviewsWithY:(CGFloat )origin_y {
    NSArray* textArr = @[@"收件人", @"物品名称", @"到达地区", @"邮费支付方式", @"上门取货地址"];
    for (int i = 0; i < 4; i++) {
        UIButton* button = [self createCellButtonWithRect:CGRectMake(0, LINE_HEIGHT*i + origin_y, self.view.frame.size.width, LINE_HEIGHT) AndLabelText:textArr[i]];
        button.tag = 10+i;
        [self.view addSubview:button];
        if (i == 0) {
            self.receiverLab = [self createDisplayLabeWithSuperview:button JianTouOrNot:YES];
        }else if (i == 1) {
            self.goodsNameLab = [self createDisplayLabeWithSuperview:button JianTouOrNot:YES];
        }else if (i == 2) {
            self.toPlaceLab = [self createDisplayLabeWithSuperview:button JianTouOrNot:NO];
        }else if (i == 3) {
            self.postTypeLab = [self createDisplayLabeWithSuperview:button JianTouOrNot:NO];
        }
    }
    UIButton* addressBtn = [self createCellButtonWithRect:CGRectMake(0, LINE_HEIGHT*4 + origin_y + 15, self.view.frame.size.width, LINE_HEIGHT) AndLabelText:textArr[4]];
    addressBtn.tag = 14;
    self.addressLab = [self createDisplayLabeWithSuperview:addressBtn JianTouOrNot:YES];
    [self.view addSubview:addressBtn];
    UIImageView* topLineIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    topLineIV.image = [UIImage imageNamed:@"line.png"];
    [addressBtn addSubview:topLineIV];
    
    self.sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4, addressBtn.frame.origin.y + LINE_HEIGHT + 15, self.view.frame.size.width/2, 35)];
    self.sendBtn.titleLabel.font = FONT_20;
    [self.sendBtn addTarget:self action:@selector(clickedSongButton:) forControlEvents:UIControlEventTouchUpInside];
    self.sendBtn.layer.cornerRadius = 4;
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.hidden = YES;
    [self.view addSubview:self.sendBtn];
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

//创建显示 收件人——邮费支付方式 label
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

//初始化数据
-(void)initData {
    self.orderDic = self.notifyDic[@"order"];
    self.receiverDic = self.orderDic[@"receiver"];
    self.goodsDic = self.orderDic[@"goods"];
    
    self.receiverLab.text = self.receiverDic[@"nickName"];
    self.goodsNameLab.text = self.goodsDic[@"name"];
    self.toPlaceLab.text = self.orderDic[@"receiverAddr"];
    NSInteger postType = [self.goodsDic[@"postageType"]integerValue];
    if (postType == 1) {
        self.postTypeLab.text = @"收方付";
    }else if (postType == 0) {
        self.postTypeLab.text = @"寄方付";
    }
    
    {
//    jsonDic={
//        msg = "\U67e5\U8be2\U6210\U529f";
//        notifyList =     (
//                          {
//                              id = 3;
//                              notifyTime = 1429418348000;
//                              order =             {
//                                  goods =                 {
//                                      description = "\U5f88\U597d\U5403\U7684\U8349\U8393";
//                                      goodsId = 2;
//                                      goodsImageAddrList =                     (
//                                                                                "http://heartbeat-goods.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150313223157_9_2.jpg",
//                                                                                "http://heartbeat-goods.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150313223157_10_2.jpg",
//                                                                                "http://heartbeat-goods.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150313223157_11_2.jpg",
//                                                                                "http://heartbeat-goods.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150313223157_12_2.jpg"
//                                                                                );
//                                      name = "\U8349\U8393";
//                                      postageType = 1;
//                                  };
//                                  id = 1;
//                                  orderNumber = "15031622310002 ";
//                                  receiver =                 {
//                                      avatar = "http://heartbeat-avatar.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150408184646_3.jpg";
//                                      gender = "<null>";
//                                      heartbeatNumber = 13207369832;
//                                      nickName = "\U8042\U950b";
//                                      personalizedSignature = "<null>";
//                                      userId = 3;
//                                  };
//                                  receiverAddr = "\U6cb3\U5317\U7701\U79e6\U7687\U5c9b\U5e02";
//                              };
//                          }
//                          );
//        status = 1;
//    }
    }
}

//获取送出通知详情
-(void)getSongNotifyDetailFromServiceWithURLMethod:(NSString* )urlMethod AndArgumentString:(NSString* )argumentStr {
    NSString* urlString = [NSString stringWithFormat:@"%@%@", HBURL, urlMethod];
    [[HBTool shareTool]postURLConnectionWithURL:urlString andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"notifyDetailStr=%@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"notifyDetailDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                NSDictionary* dic = jsonDic[@"notify"];
                NSInteger ifDeliver = [dic[@"ifDeliver"]integerValue];//是否发货，这个是收方付邮费情况
                NSInteger status = [dic[@"status"]integerValue];//status：付费状态，这个是送方付邮费时的状态，因为送方付的时候需要送方付款，所以要检测一下是否已付邮费
                
                NSInteger postType = [self.goodsDic[@"postageType"]integerValue];
                if (postType == 1) {//收方付
                    if (ifDeliver == 0) {//未发快件
                        self.sendBtn.hidden = NO;
                        self.sendBtn.backgroundColor = COLOR_BLUE1;
                        [self.sendBtn setTitle:@"确认发快件" forState:UIControlStateNormal];
                        self.sendBtn.enabled = YES;
                    }else if (ifDeliver == 1) {//已发快件
                        self.sendBtn.hidden = NO;
                        self.sendBtn.backgroundColor = COLOR_GRAY1;
                        [self.sendBtn setTitle:@"此订单已处理" forState:UIControlStateNormal];
                        self.sendBtn.enabled = NO;
                    }
                }else if (postType == 0) {//寄方付
                    if (status == 0) {//寄方未付邮费
                        self.sendBtn.hidden = NO;
                        self.sendBtn.backgroundColor = COLOR_BLUE1;
                        [self.sendBtn setTitle:@"确认发快件" forState:UIControlStateNormal];
                        self.sendBtn.enabled = YES;
                    }else if (status == 1) {//寄方已付邮费
                        self.sendBtn.hidden = NO;
                        self.sendBtn.backgroundColor = COLOR_GRAY1;
                        [self.sendBtn setTitle:@"此订单已处理" forState:UIControlStateNormal];
                        self.sendBtn.enabled = NO;
                    }
                }
                
//                notifyDetailStr={"status":1,"notify":{"status":0,"ifDeliver":1},"msg":"查询成功"}
                
            }else {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取发件详情失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [av show];
            }
        });
    }];
}

//点击单元行
-(void)clickedCellButton:(UIButton* )sender {
    if (sender.tag == 10) {//收件人
        HBMyHopeViewController* HBMyHopeVC = [[HBMyHopeViewController alloc]init];
        HBUser* user = [[HBUser alloc]init];
        user.userID = [self.receiverDic[@"userId"]integerValue];
        user.heartBeatNumber = self.receiverDic[@"heartbeatNumber"];
        user.nickName = self.receiverDic[@"nickName"];
        if ([self.receiverDic[@"avatar"] isKindOfClass:[NSNull class]]) {
            
        }else {
            user.avatar = self.receiverDic[@"avatar"];
        }
        if ([self.receiverDic[@"personalizedSignature"] isKindOfClass:[NSNull class]]) {
            
        }else {
            user.personalizedSignature = self.receiverDic[@"personalizedSignature"];
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
        
    }else if (sender.tag == 12) {//
        
    }else if (sender.tag == 13) {//
        
    }else if (sender.tag == 14) {//上门取货地址
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

-(void)clickedSongButton:(UIButton* )sender {
    if (sender == self.sendBtn) {
        if ([[self.sendBtn titleForState:UIControlStateNormal]isEqualToString:@"确认发快件"]) {
            if (self.addressLab.text.length > 0) {//地址不为空
                
                NSInteger postType = [self.goodsDic[@"postageType"]integerValue];
                NSInteger notifyId = [self.notifyDic[@"id"]integerValue];
                NSString* argumentStr = [NSString stringWithFormat:@"orderId=&notifyId=%ld&provinceId=%ld&cityId=%ld&districtId=%ld&personName=%@&telphone=%@&detailAddr=%@&expressCorpId=&myId=%ld&apiKey=%@&", notifyId, self.provinceId, self.cityId, self.districtId, self.personName, self.telphone, self.detailAddr, USERID, APIKEY];
                if (postType == 1) {//收方付 此时邮费已付 直接确认发快件
                    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/goods/deliveryGoods.do"];
                    
                    [self deliverGoodsWithURLStr:urlStr AndArgumentStr:argumentStr];
                    
                }else if (postType == 0) {//寄方付 此时邮费未付 确认发快件并跳转至支付页面
                    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/goods/deliveryGoodsSelfPay.do"];
                    
                    [self deliverGoodsSelfPayWithURLStr:urlStr AndArgumentStr:argumentStr];
                }
            }else {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"上门取件地址不能为空" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [av show];
            }
        }
    }
}

//收方付 此时邮费已付 直接确认发快件
-(void)deliverGoodsWithURLStr:(NSString* )urlStr AndArgumentStr:(NSString* )argumentStr {
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"deliverGoods_resultStr=%@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"deliverGoods_jsonDic=%@", jsonDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                self.sendBtn.backgroundColor = COLOR_GRAY1;
                [self.sendBtn setTitle:@"此订单已处理" forState:UIControlStateNormal];
                self.sendBtn.enabled = NO;
                
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"快递员将于24小时内预约上门取件" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [av show];
            }else if ([jsonDic[@"status"]integerValue] == -1) {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"确认发件失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [av show];
            }
        });
    }];
}

//寄方付 此时邮费未付 确认发快件并跳转至支付页面
-(void)deliverGoodsSelfPayWithURLStr:(NSString* )urlStr AndArgumentStr:(NSString* )argumentStr {
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"deliverGoodsSelfPay_resultStr=%@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"deliverGoodsSelfPay_jsonDic=%@", jsonDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                double price = [jsonDic[@"postage"]doubleValue];
                
                HBPayViewController* HBPayVC = [HBPayViewController sharePayViewController];
                HBPayVC.orderId = self.orderDic[@"orderNumber"];
                HBPayVC.postageValue = price;
                HBPayVC.goodsName = self.goodsDic[@"name"];
                HBPayVC.goodsDescription = self.goodsDic[@"description"];
                [self.navigationController pushViewController:HBPayVC animated:NO];
            }else {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"确认发快件失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
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
