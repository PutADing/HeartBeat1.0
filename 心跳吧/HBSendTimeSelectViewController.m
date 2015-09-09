//
//  HBSendTimeSelectViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/7.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBSendTimeSelectViewController.h"
#import "HBSelectInfoTableViewCell.h"
#import "HBTool.h"

@interface HBSendTimeSelectViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy)NSString* timeStr;
@property (nonatomic, assign)NSInteger timeId;

@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)NSMutableArray* tableArr;

@end

@implementation HBSendTimeSelectViewController

//行高
#define LINE_HEIGHT 40

static NSString* identifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[HBTool shareTool]isIOS7_Later]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    self.title = @"选择时间";
    self.view.backgroundColor = COLOR_WHITE1;
    
    self.tableView = [self createTableViewWithY:NAVIGATIOINBARHEIGHT];
    [self.view addSubview:self.tableView];
    self.tableArr = [NSMutableArray array];
    
    NSString* urlMethod = @"rest/data/getValidTime.do";
    NSString* argumentStr = [NSString stringWithFormat:@"appToken=%@&appSecret=%@&appType=%@", APPTOKEN, APPSECRET, APPTYPE];
    [self getDataFromServiceWithURLMethod:urlMethod AndArgumentStr:argumentStr];
    
//  送出时间  接口: /rest/data/getValidTime.do
//           参数:  String appToken,   String appSecret; Integer appType;
//           返回一个对象JSON列表: validTimeList
//           每一个类型是
//           ValidTime{
//            Integer  id,
//            Integer timeValue,
//            String  timeName
//           }
        
    
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
                self.tableArr = jsonDic[@"validTimeList"];
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
    
    NSDictionary* timeDic = self.tableArr[indexPath.row];
    NSString* timeName = timeDic[@"timeName"];
    cell.label.text = timeName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary* dic = self.tableArr[indexPath.row];
    self.timeId = [dic[@"id"]integerValue];
    self.timeStr = dic[@"timeName"];
    [self goBackToLastVC];
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
        self.callback(self.timeStr, self.timeId);
    }
    NSLog(@"%@%ld", self.timeStr, self.timeId);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)returnSendTimeCallBack:(CallBack_SendTime)block {
    self.callback = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
