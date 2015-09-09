//
//  HBPayViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/5/7.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBPayViewController.h"
#import "HBTool.h"
#import <AlipaySDK/AlipaySDK.h>

@interface HBPayViewController () <UIAlertViewDelegate>
@property (nonatomic, strong)UIButton* aLiPayBtn;//阿里支付
@property (nonatomic, strong)UIButton* weiXinPayBtn;//微信支付
@property (nonatomic, strong)UIButton* payButton;//去支付 按钮

//@property (nonatomic, copy)NSString* aLiPay_Partner;//阿里支付公钥
//@property (nonatomic, copy)NSString* aLiPay_Seller;//阿里支付私钥

@end

@implementation HBPayViewController

//行高
#define LINE_HEIGHT 50
static HBPayViewController* HBPayVC = nil;

+(instancetype)sharePayViewController {
    if (!HBPayVC) {
        HBPayVC = [[HBPayViewController alloc] init];
    }
    return HBPayVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付运费";
    self.view.backgroundColor = BACKGROUNGCOLOR_GRAY1;
    
    [self initSubiewsWithY:NAVIGATIOINBARHEIGHT];
    
}

-(void)initSubiewsWithY:(CGFloat )origin_y {
    UIButton* cellButton0 = [self createCellButtonWithY:origin_y AndTextString:@"快递运费" AndIsSelectPay:NO];
    [self.view addSubview:cellButton0];
    UILabel* yuanLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 20, 15, 20, 20)];
    yuanLab.text = @"元";
    yuanLab.font = FONT_17;
    [cellButton0 addSubview:yuanLab];
    self.priceLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 20 - 100, 15, 100, 20)];
    self.priceLab.font = FONT_17;
    self.priceLab.text = [NSString stringWithFormat:@"%.2f", self.postageValue];
    self.priceLab.textAlignment = NSTextAlignmentRight;
    [cellButton0 addSubview:self.priceLab];
    
    self.aLiPayBtn = [self createCellButtonWithY:cellButton0.frame.origin.y + cellButton0.frame.size.height + 15 AndTextString:@"支付宝支付" AndIsSelectPay:YES];
    self.aLiPayBtn.selected = YES;
    [self.view addSubview:self.aLiPayBtn];
    
    self.weiXinPayBtn = [self createCellButtonWithY:self.aLiPayBtn.frame.origin.y + self.aLiPayBtn.frame.size.height AndTextString:@"微信支付" AndIsSelectPay:YES];
    self.weiXinPayBtn.selected = NO;
    [self.view addSubview:self.weiXinPayBtn];
    
    self.payButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4, self.weiXinPayBtn.frame.origin.y + self.weiXinPayBtn.frame.size.height + 15, self.view.frame.size.width/2, 35)];
    [self.payButton setTitle:@"前往支付" forState:UIControlStateNormal];
    [self.payButton addTarget:self action:@selector(clickedPayButton:) forControlEvents:UIControlEventTouchUpInside];
    self.payButton.backgroundColor = COLOR_BLUE1;
    self.payButton.layer.cornerRadius = 4;
    self.payButton.layer.masksToBounds = YES;
    [self.view addSubview:self.payButton];
}

//创建单元行
-(UIButton* )createCellButtonWithY:(CGFloat )origin_y AndTextString:(NSString* )textStr AndIsSelectPay:(BOOL )isSelectPay {
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, LINE_HEIGHT)];
    btn.backgroundColor = COLOR_WHITE1;
    
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 90, 20)];
    lab.text = textStr;
    lab.font = FONT_17;
    [btn addSubview:lab];
    if (isSelectPay == YES) {
        [btn setImageEdgeInsets:UIEdgeInsetsMake(10, self.view.frame.size.width - 10 - 30, 10, 10)];
        [btn setImage:[UIImage imageNamed:@"dot_NotSelected.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"dot_Selected.png"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickedALiPayOrWeiXinPay:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIImageView* lineIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, btn.frame.size.height - 1, self.view.frame.size.width, 1)];
    lineIV.image = [UIImage imageNamed:@"line.png"];
    [btn addSubview:lineIV];
    
    return btn;
}

//点击 支付宝支付 微信支付
-(void)clickedALiPayOrWeiXinPay:(UIButton* )sender {
    if (sender == self.aLiPayBtn) {
        self.aLiPayBtn.selected = YES;
        self.weiXinPayBtn.selected = NO;
    }else if (sender == self.weiXinPayBtn) {
        self.weiXinPayBtn.selected = YES;
        self.aLiPayBtn.selected = NO;
    }
}

//点击 去支付 按钮
-(void)clickedPayButton:(UIButton* )sender {
    if (sender == self.payButton) {
        if (self.aLiPayBtn.selected == YES) {
            
            [self getALiPayInfoFromService];
            
        }else if (self.weiXinPayBtn.selected == YES) {
            
            [self getWeiXinPayInfoFromService];
            
        }
    }
}

//获取阿里支付信息
-(void)getALiPayInfoFromService {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/data/getAlipayOrderInfo.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"orderNumber=%@&goodsName=%@&goodsDescription=%@&postageValue=%.2f&myId=%ld&apiKey=%@", self.orderId, self.goodsName, self.goodsDescription, self.postageValue, USERID, APIKEY];
    
    NSLog(@"getAlipayOrderInfo_argumentStr=%@", argumentStr);
    
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"resultStr=%@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                NSString* appScheme = @"heartbeat";//URL Scheme
                NSString* orderString = jsonDic[@"payInfo"];//服务器返回加签后的字符串
                
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                    
                    NSString* error = resultDic[@"memo"];
                    NSLog(@"pay_error=%@", error);
                    
                    NSInteger resultState = [resultDic[@"resultStatus"]integerValue];
                    
                    if (resultState == 9000) {// && [success isEqualToString:@"true"]
                        [self didSuccessfullyPay];
                    }else {
                        [self didFailPay];
                    }
                    
                }];
                
            }
        });
    }];
}



//获取微信支付信息
-(void)getWeiXinPayInfoFromService {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/data/getWCPayOrderInfo.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"myId=%ld&apiKey=%@&orderNumber=%@&goodsName=%@&goodsDescription=%@&postageValue=%f", USERID, APIKEY, self.orderId, self.goodsName, self.goodsDescription, self.postageValue];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"resultStr=%@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                //appid, noncestr,package, partnerid, prepayid, timestamp, sign, err_code_des, return_msg
                NSString* partnerId = jsonDic[@"partnerid"];
                NSString* prepayId = jsonDic[@"prepayid"];
                NSString* package = jsonDic[@"package"];
                NSString* nonceStr = jsonDic[@"noncestr"];
                UInt32 timeStamp = [jsonDic[@"timestamp"]intValue];
                NSString* sign = jsonDic[@"sign"];
                
                NSLog(@"jsonDic.partnerId=%@, prepayId=%@, package=%@, nonceStr=%@, timeStamp=%d, sign=%@", partnerId, prepayId, package, nonceStr, timeStamp, sign);
                
                [self goToWeiXinPayWithPartnerId:partnerId AndPrepayId:prepayId AndPackage:package AndNonceStr:nonceStr And:timeStamp And:sign];//微信支付
                /*
                 appid = wxef10489ea8963163;
                 "err_code_des" = "<null>";
                 msg = "\U8ba2\U5355\U751f\U6210\U6210\U529f";
                 noncestr = 060afc8a563aaccd288f98b7c8723b61;
                 package = "Sign=WXPay";
                 partnerid = 1235302702;
                 prepayid = wx20150521212636708b714e9f0891660061;
                 "return_msg" = OK;
                 sign = 837f77a81aea3e156971ffe525ba2905;
                 status = 1;
                 timestamp = 1432214797;
                 */
            }
        });
    }];
}

//微信支付
-(void)goToWeiXinPayWithPartnerId:(NSString* )partnerId AndPrepayId:(NSString* )prepayId AndPackage:(NSString* )package AndNonceStr:(NSString* )nonceStr And:(UInt32 )timeStamp And:(NSString* )sign {
    
    PayReq* request = [[PayReq alloc]init];
    request.partnerId = partnerId;
    request.prepayId = prepayId;
    request.package = package;
    request.nonceStr = nonceStr;
    request.timeStamp = timeStamp;
    request.sign = sign;
    
    NSLog(@"request.partnerId=%@, prepayId=%@, package=%@, nonceStr=%@, timeStamp=%d, sign=%@", request.partnerId, request.prepayId, request.package, request.nonceStr, request.timeStamp, request.sign);
    
//    [WXApi sendReq:request];
    [WXApi safeSendReq:request];
}

//处理微信支付返回的结果
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
            {
                NSLog(@"微信支付成功");
                [self didSuccessfullyPay];
                
            }
                break;
            default:
                NSLog(@"微信支付失败， retcode=%d",resp.errCode);
                [self didFailPay];
                
                break;
        }
    }
}

//支付成功
-(void)didSuccessfullyPay {
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"支付成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    av.tag = 10;
    [av show];
}

//支付失败
-(void)didFailPay {
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"支付失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [av show];
}

#pragma mark- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
