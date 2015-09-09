//
//  HBPlaceSelectViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/27.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBPlaceSelectViewController.h"
#import "HBTool.h"
#import "HBSelectInfoTableViewCell.h"

@interface HBPlaceSelectViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy)NSString* proviceName;
@property (nonatomic, assign)NSInteger proviceId;
@property (nonatomic, copy)NSString* cityName;
@property (nonatomic, assign)NSInteger cityId;
@property (nonatomic, copy)NSString* districtName;
@property (nonatomic, assign)NSInteger districtId;

@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)NSMutableArray* tableArr;
@property (nonatomic, assign)NSInteger index;//1省 2市 3区县

@end

@implementation HBPlaceSelectViewController

//行高
#define LINE_HEIGHT 40

static NSString* identifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[HBTool shareTool]isIOS7_Later]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    self.title = @"选择所在地区";
    self.view.backgroundColor = COLOR_WHITE1;
    
    self.tableView = [self createTableViewWithY:NAVIGATIOINBARHEIGHT];
    [self.view addSubview:self.tableView];
    self.tableArr = [NSMutableArray array];
    self.index = 1;
    
    NSString* urlMethod = @"rest/data/getProvince.do";
    NSString* argumentStr = [NSString stringWithFormat:@"appToken=%@&appSecret=%@&appType=%@", APPTOKEN, APPSECRET, APPTYPE];
    [self getDataFromServiceWithURLMethod:urlMethod AndArgumentStr:argumentStr];
}

//创建tableView
-(UITableView* )createTableViewWithY:(CGFloat )origin_y {
    UITableView* tv = [[UITableView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, self.view.frame.size.height - origin_y) style:UITableViewStylePlain];
    [tv registerClass:[HBSelectInfoTableViewCell class] forCellReuseIdentifier:identifier];
    tv.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tv.dataSource = self;
    tv.delegate = self;
    return tv;
}

-(void)getDataFromServiceWithURLMethod:(NSString* )urlMethod AndArgumentStr:(NSString* )argumentStr {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, urlMethod];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"resultStr=%@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"jsonDic=%@", jsonDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                if (self.index == 1) {//省
                    self.tableArr = jsonDic[@"provinceList"];
                }else if (self.index == 2) {//市
                    self.tableArr = jsonDic[@"cityList"];
                }else if (self.index == 3) {//区县
                    self.tableArr = jsonDic[@"districtList"];
                }
                [self.tableView reloadData];
            }
        });
    }];
}

#pragma mark- tableViewDataSource
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableArr.count;
}

-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBSelectInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[HBSelectInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary* dic = self.tableArr[indexPath.row];
    if (self.index == 1) {
        NSString* provinceName = dic[@"provinceName"];
        cell.label.text = provinceName;
    }else if (self.index == 2) {
        NSString* cityName = dic[@"cityName"];
        cell.label.text = cityName;
    }else if (self.index == 3) {
        NSString* districtName = dic[@"distName"];
        cell.label.text = districtName;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary* dic = self.tableArr[indexPath.row];
    
    if (self.index == 1) {
        self.proviceId = [dic[@"provinceId"]integerValue];
        self.proviceName = dic[@"provinceName"];
        self.index++;
        NSString* urlMethod = @"rest/data/getCity.do";
        NSString* argumentStr = [NSString stringWithFormat:@"provinceId=%ld&appToken=%@&appSecret=%@&appType=%@", self.proviceId, APPTOKEN, APPSECRET, APPTYPE];
        [self getDataFromServiceWithURLMethod:urlMethod AndArgumentStr:argumentStr];
        
    }else if (self.index == 2) {
        self.cityId = [dic[@"cityId"]integerValue];
        self.cityName = dic[@"cityName"];
        self.index++;
        NSString* urlMethod = @"rest/data/getDistrict.do";
        NSString* argumentStr = [NSString stringWithFormat:@"cityId=%ld&appToken=%@&appSecret=%@&appType=%@", self.cityId, APPTOKEN, APPSECRET, APPTYPE];
        [self getDataFromServiceWithURLMethod:urlMethod AndArgumentStr:argumentStr];
        
    }else if (self.index == 3) {
        self.districtId = [dic[@"distId"]integerValue];
        self.districtName = dic[@"distName"];
        [self goBackToLastVC];
        
    }
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LINE_HEIGHT;
}

-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

//返回上一个VC
-(void)goBackToLastVC {
    if (self.callback != nil) {
        self.callback(self.proviceName, self.proviceId, self.cityName, self.cityId, self.districtName, self.districtId);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)returnPlaceCallBack:(CallBack_Place)block {
    self.callback = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
