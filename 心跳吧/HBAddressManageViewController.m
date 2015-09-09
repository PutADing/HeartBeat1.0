//
//  HBAddressManageViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/28.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBAddressManageViewController.h"
#import "HBAddressManageTableViewCell.h"
#import "HBAddAddressViewController.h"
#import "HBTool.h"
#import "HBModifyAddressViewController.h"

@interface HBAddressManageViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UIButton* addAddressBtn;//添加地址按钮
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)NSMutableArray* tableArr;

@end

@implementation HBAddressManageViewController

//行高
#define LINE_HEIGHT 50

static NSString* identifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[HBTool shareTool]isIOS7_Later]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    self.title = @"管理地址";
    self.view.backgroundColor = BACKGROUNGCOLOR_GRAY1;
    
    self.addAddressBtn = [self createAddAddressButtonWithRect:CGRectMake(0, NAVIGATIOINBARHEIGHT + 10, self.view.frame.size.width, LINE_HEIGHT)];
    [self.view addSubview:self.addAddressBtn];
    
    self.tableView = [self createTableViewWithRect:CGRectMake(0, self.addAddressBtn.frame.origin.y + self.addAddressBtn.frame.size.height + 10, self.view.frame.size.width, self.view.frame.size.height - self.addAddressBtn.frame.origin.y - self.addAddressBtn.frame.size.height - 10)];
    [self.view addSubview:self.tableView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/setting/getMyCommAddr.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"myId=%ld&apiKey=%@", USERID, APIKEY];
    [self getAllAddressFromServiceWithURLString:urlStr AndArgumentString:argumentStr];
}

//创建 添加地址 按钮
-(UIButton* )createAddAddressButtonWithRect:(CGRect )rect {
    UIButton* btn = [[UIButton alloc]initWithFrame:rect];
    btn.backgroundColor = COLOR_WHITE1;
    btn.titleLabel.font = FONT_17;
    [btn setTitle:@"添加地址" forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_BLACK1 forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickedAddAddressButton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

//创建tableView
-(UITableView* )createTableViewWithRect:(CGRect )rect {
    UITableView* tv = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    [tv registerClass:[HBAddressManageTableViewCell class] forCellReuseIdentifier:identifier];
    tv.dataSource = self;
    tv.delegate = self;
    return tv;
}

//点击 添加地址 按钮
-(void)clickedAddAddressButton:(UIButton* )sender {
    HBAddAddressViewController* HBAddAddressVC = [[HBAddAddressViewController alloc]init];
    [self.navigationController pushViewController:HBAddAddressVC animated:NO];
}

//从服务器获取所有地址列表
-(void)getAllAddressFromServiceWithURLString:(NSString* )urlString AndArgumentString:(NSString* )argumentStr {
    [[HBTool shareTool]postURLConnectionWithURL:urlString andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"resultStr=%@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                self.tableArr = jsonDic[@"addressList"];
                
                [self.tableView reloadData];
            }else {
                UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取地址列表失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [av show];
            }
        });
    }];
}

#pragma mark- UITableViewDataSource
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tableArr.count > 0) {
        return self.tableArr.count + 1;
    }else {
        return self.tableArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBAddressManageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[HBAddressManageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row == 0) {
        cell.addressLab.text = @"已添加的地址";
        cell.addressLab.textColor = COLOR_GRAY1;
    }else {
        NSDictionary* addressDic;
        if (self.tableArr.count > 0) {
            addressDic = self.tableArr[indexPath.row-1];
        }
        
        NSDictionary* provinceDic = addressDic[@"province"];
        NSDictionary* cityDic = addressDic[@"city"];
        NSDictionary* districtDic = addressDic[@"district"];
        
        cell.addressId = [addressDic[@"addrId"]integerValue];
        cell.nameString = addressDic[@"contactPerson"];
        cell.phoneNumberStr = addressDic[@"tel"];
        cell.detailString = addressDic[@"detailAddr"];
        cell.provinceName = provinceDic[@"provinceName"];
        cell.provinceId = [provinceDic[@"provinceId"]integerValue];
        cell.cityName = cityDic[@"cityName"];
        cell.cityId = [cityDic[@"cityId"]integerValue];
        cell.districtName = districtDic[@"distName"];
        cell.districtId = [districtDic[@"distId"]integerValue];
        
        cell.addressLab.textColor = COLOR_BLACK1;
        cell.addressLab.text = [NSString stringWithFormat:@"地址%ld:%@%@%@", indexPath.row, provinceDic[@"provinceName"], cityDic[@"cityName"], districtDic[@"distName"]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row > 0) {
        HBAddressManageTableViewCell* cell = (HBAddressManageTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        HBModifyAddressViewController* HBModifyAddressVC = [[HBModifyAddressViewController alloc]init];
        HBModifyAddressVC.nameString = cell.nameString;
        HBModifyAddressVC.phoneNumberStr = cell.phoneNumberStr;
        HBModifyAddressVC.detailString = cell.detailString;
        HBModifyAddressVC.provinceId = cell.provinceId;
        HBModifyAddressVC.cityId = cell.cityId;
        HBModifyAddressVC.districtId = cell.districtId;
        HBModifyAddressVC.provinceName = cell.provinceName;
        HBModifyAddressVC.cityName = cell.cityName;
        HBModifyAddressVC.districtName = cell.districtName;
        HBModifyAddressVC.addressId = cell.addressId;
        [self.navigationController pushViewController:HBModifyAddressVC animated:NO];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
