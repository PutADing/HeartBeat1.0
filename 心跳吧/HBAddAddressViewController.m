//
//  HBAddAddressViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/26.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBAddAddressViewController.h"
#import "HBPlaceSelectViewController.h"
#import "HBTool.h"

@interface HBAddAddressViewController ()
@property (nonatomic, strong)UITextField* nameTF;//姓名
@property (nonatomic, strong)UITextField* phoneNumberTF;//手机号
@property (nonatomic, strong)UILabel* placeLab;//省/市/区、县
@property (nonatomic, strong)UITextField* detailTF;//详细地址

@property (nonatomic, assign)NSInteger provinceId;//
@property (nonatomic, assign)NSInteger cityId;//
@property (nonatomic, assign)NSInteger districtId;//
@property (nonatomic, copy)NSString* proviceName;//
@property (nonatomic, copy)NSString* cityName;//
@property (nonatomic, copy)NSString* districtName;//

@end

@implementation HBAddAddressViewController

//每行高度
#define LINE_HEIGHT 50
//线距离左的间距
#define SPACE_LINE 5
//textField距离左的间距 宽
#define SPACE_TEXTFIELD 10
#define WIDTH_TEXTFIELD (self.view.frame.size.width - SPACE_TEXTFIELD*2)


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加地址";
    self.view.backgroundColor = COLOR_WHITE1;
    
    [self initSubviewsWithY:NAVIGATIOINBARHEIGHT];
    
}

- (void)initSubviewsWithY:(CGFloat )origin_y {
    NSArray* placeholderArr = @[@"联系人（姓名/昵称）",@"联系方式（手机号）",@"省/市/区、县",@"详细地址",@"详细地址（街道门牌）"];
    CGRect textField_Rect = CGRectMake(SPACE_TEXTFIELD, 10, WIDTH_TEXTFIELD, 30);
    for (int i = 0; i < 4; i++) {
        UIView* cellView = [self createCellViewWithY:i*LINE_HEIGHT + origin_y];
        [self.view addSubview:cellView];
        if (i == 0) {
            self.nameTF = [self createTextFieldWithRect:textField_Rect AndPlaceholder:placeholderArr[i]];
            [cellView addSubview:self.nameTF];
        }else if (i == 1) {
            self.phoneNumberTF = [self createTextFieldWithRect:textField_Rect AndPlaceholder:placeholderArr[i]];
            self.phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
            [cellView addSubview:self.phoneNumberTF];
        }else if (i == 2) {
            UIButton* placeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, cellView.frame.size.width, cellView.frame.size.height)];
            [placeBtn addTarget:self action:@selector(clickedPlaceButton:) forControlEvents:UIControlEventTouchUpInside];
            [cellView addSubview:placeBtn];
            
            UIImageView* jianTouIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 16, (LINE_HEIGHT - 16)/2, 16, 16)];
            jianTouIV.image = [UIImage imageNamed:@"jianTou.png"];
            [placeBtn addSubview:jianTouIV];
            
            self.placeLab = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_TEXTFIELD, 10, WIDTH_TEXTFIELD - 16, 30)];
            self.placeLab.textColor = COLOR_GRAY1;
            self.placeLab.text = placeholderArr[i];
            self.placeLab.font = FONT_17;
            [placeBtn addSubview:self.placeLab];
        }else if (i == 3) {
            self.detailTF = [self createTextFieldWithRect:textField_Rect AndPlaceholder:placeholderArr[i]];
            [cellView addSubview:self.detailTF];
        }
    }
    
    UIButton* saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4, LINE_HEIGHT*4 + origin_y + 15, self.view.frame.size.width/2, 35)];
    saveBtn.backgroundColor = COLOR_BLUE1;
    [saveBtn setTitle:@"确认" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = FONT_20;
    saveBtn.layer.cornerRadius = 4;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn addTarget:self action:@selector(clickedSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

//创建单元行
-(UIView* )createCellViewWithY:(CGFloat )origin_y {
    UIView* vi = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, LINE_HEIGHT)];
    UIImageView* iv = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_LINE, LINE_HEIGHT - 10, self.view.frame.size.width - SPACE_LINE*2, 10)];
    iv.image = [UIImage imageNamed:@"blueLine.png"];
    [vi addSubview:iv];
    vi.backgroundColor = COLOR_WHITE1;
    return vi;
}

//创建textField
-(UITextField* )createTextFieldWithRect:(CGRect )rect AndPlaceholder:(NSString* )placeholderStr {
    UITextField* tf = [[UITextField alloc]initWithFrame:rect];
    tf.placeholder = placeholderStr;
    tf.textColor = COLOR_BLACK1;
    tf.font = FONT_17;
    return tf;
}

//点击 省/市/区、县 按钮
-(void)clickedPlaceButton:(UIButton* )sender {
    HBPlaceSelectViewController* HBPlaceSelectVC = [[HBPlaceSelectViewController alloc]init];
    [HBPlaceSelectVC returnPlaceCallBack:^(NSString *proviceName, NSInteger proviceId, NSString *cityName, NSInteger cityId, NSString *districtName, NSInteger districtId) {
        self.proviceName = proviceName;
        self.cityName = cityName;
        self.districtName = districtName;
        self.provinceId = proviceId;
        self.cityId = cityId;
        self.districtId = districtId;
        self.placeLab.textColor = COLOR_BLACK1;
        self.placeLab.text = [NSString stringWithFormat:@"%@%@%@", self.proviceName, self.cityName, self.districtName];
    }];
    [self.navigationController pushViewController:HBPlaceSelectVC animated:NO];
}

//判断textField是否为空
-(BOOL )isText:(UITextField* )tf {
    if (tf.text.length != 0) {
        return YES;
    }else {
        return NO;
    }
}

//判断手机号
-(BOOL )isCellPhoneNumber:(UITextField* )tf {
    if (tf.text.length == 11) {
        return YES;
    }else {
        return NO;
    }
}

//判断label是否为空
-(BOOL )isTextWithLabel:(UILabel* )lab {
    if (self.provinceId > 0 && self.cityId > 0 && self.districtId > 0) {
        return YES;
    }else {
        return NO;
    }
}

//显示alertView
-(void)showAlertViewWithMessage:(NSString* )messageStr {
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:messageStr delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [av show];
}

//点击 保存 按钮
-(void)clickedSaveButton:(UIButton* )sender {
    if ([self isText:self.nameTF]) {
        if ([self isCellPhoneNumber:self.phoneNumberTF]) {
            if ([self isTextWithLabel:self.placeLab]) {
                if ([self isText:self.detailTF]) {
                    
                    [self submitAddressData];
                    
                }else {
                    [self showAlertViewWithMessage:@"详细地址不能为空"];
                }
            }else {
                [self showAlertViewWithMessage:@"地址不能为空"];
            }
        }else {
            [self showAlertViewWithMessage:@"联系方式不能为空"];
        }
    }else {
        [self showAlertViewWithMessage:@"联系人不能为空"];
    }
}

//提交地址
-(void)submitAddressData {
    NSString* urlString = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/setting/addCommAddr.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"name=%@&provinceId=%ld&cityId=%ld&districtId=%ld&detailAddr=%@&telphone=%@&myId=%ld&apiKey=%@", self.nameTF.text, self.provinceId, self.cityId, self.districtId, self.detailTF.text, self.phoneNumberTF.text, USERID, APIKEY];
    [[HBTool shareTool]postURLConnectionWithURL:urlString andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"resultStr=%@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                
//                [self goBackToLastViewController];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"添加地址失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [av show];
            }
            
        });
    }];
}

/*//返回至上一个界面
-(void)goBackToLastViewController {
    if (self.callback != nil) {
        self.callback(self.proviceName, self.provinceId, self.cityName, self.cityId, self.districtName, self.districtId);
    }
    
    
}

-(void)returnPlaceCallBack:(CallBack_AddAddress)block {
    self.callback = block;
}
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
