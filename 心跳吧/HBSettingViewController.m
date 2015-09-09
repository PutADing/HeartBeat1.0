//
//  HBSettingViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/24.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBSettingViewController.h"
#import "HBGeneralSettingViewController.h"
#import "HBAboutUsViewController.h"
#import "HBSuggestionViewController.h"
#import "HBChangePhoneViewController.h"
#import "HBVertifySimpleCodeViewController.h"
#import "HBLoginViewController.h"
#import "HBNavigationController.h"

@interface HBSettingViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* nameArray;//用来存储通用设置、修改密码、更换手机号等的数组

@property (nonatomic, strong)UIView* logoutView;//退出登录时 清理数据

@end

@implementation HBSettingViewController

static NSString* identifier = @"cell";
#define CELLHeight 50   //每一行cell的高度

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.tableView = [self createTableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.nameArray = @[@"通用设置",@"修改密码",@"更换手机号",@"关于我们",@"意见反馈",@"退出"];
    
    [self.tableView registerClass:[HBSettingTableViewCell class] forCellReuseIdentifier:identifier];//注册tableViewCell
    
//    UIEdgeInsets edgeInset = self.tableView.separatorInset;
//    self.tableView.separatorInset = UIEdgeInsetsMake(edgeInset.top, 0, edgeInset.bottom, edgeInset.right);
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//修改分隔线长度
}

-(UITableView* )createTableView {
    UITableView* tempTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)style:UITableViewStylePlain];
    tempTV.backgroundColor = BACKGROUNGCOLOR_GRAY1;
    return tempTV;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 2;
    }else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBSettingTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HBSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//去掉点击时的颜色效果
    if (indexPath.section == 0) {
        cell.nameLabel.text = self.nameArray[indexPath.row];
    }else if (indexPath.section == 1) {
        cell.nameLabel.text = self.nameArray[indexPath.row+1];
    }else if (indexPath.section == 2) {
        cell.nameLabel.text = self.nameArray[indexPath.row+3];
        if (indexPath.row == 2) {
            cell.jianTouIV.hidden = YES;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//通用设置
            HBGeneralSettingViewController* HBGeneralSettingVC = [[HBGeneralSettingViewController alloc]init];
            [self.navigationController pushViewController:HBGeneralSettingVC animated:NO];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {//修改密码
            HBVertifySimpleCodeViewController* HBVSCVC = [[HBVertifySimpleCodeViewController alloc]init];
            [self.navigationController pushViewController:HBVSCVC animated:NO];
        }else if (indexPath.row == 1) {//更换手机号
            HBChangePhoneViewController* HBChangePhoneVC = [[HBChangePhoneViewController alloc]init];
            [self.navigationController pushViewController:HBChangePhoneVC animated:NO];
        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {//关于我们
            HBAboutUsViewController* HBAboutUsVC = [[HBAboutUsViewController alloc]init];
            [self.navigationController pushViewController:HBAboutUsVC animated:NO];
        }else if (indexPath.row == 1) {//意见反馈
            HBSuggestionViewController* HBSuggestionVC = [[HBSuggestionViewController alloc]init];
            [self.navigationController pushViewController:HBSuggestionVC animated:NO];
        }else if (indexPath.row == 2) {//退出
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"确定退出登陆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
            alertView.tag = 200;
            [alertView show];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELLHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        return 15;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

//显示logoutView
-(void)showLogoutView {
    CGFloat FrameWidth = self.view.frame.size.width;
    CGFloat FrameHeight = self.view.frame.size.height;
    self.logoutView = [[UIView alloc]initWithFrame:CGRectMake(FrameWidth/4, (FrameHeight - 100)/2, FrameWidth/2, 100)];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aiv.frame = CGRectMake((self.logoutView.frame.size.width - 130)/2, 35, 30, 30);
    [aiv startAnimating];
    [self.logoutView addSubview:aiv];
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(aiv.frame.origin.x + aiv.frame.size.width, 40, 100, 20)];
    lab.text = @"正在退出...";
    lab.font = FONT_17;
    [self.logoutView addSubview:lab];
    [self.view addSubview:self.logoutView];
}

//清除logoutView
-(void)hideLogoutView {
    [self.logoutView removeFromSuperview];
}

//点击alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 200) {
        if (buttonIndex == 0) {//取消
            
        }else if (buttonIndex == 1) {//退出
            
            [self showLogoutView];//显示 正在退出... 视图
            
            [self deleteUserData];//清除用户数据
            
            [self hideLogoutView];//删除 正在退出... 视图
            
            HBLoginViewController* loginVC = [[HBLoginViewController alloc]init];
            HBNavigationController* navi = [[HBNavigationController alloc]initWithRootViewController:loginVC];
            [self.navigationController presentViewController:navi animated:NO completion:^{
                
            }];
        }
    }
}

//退出登录后 清除用户数据
-(void)deleteUserData {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"voiceSwitch"];
    [defaults removeObjectForKey:@"shakeSwitch"];
    [defaults removeObjectForKey:@"verifySwitch"];
    
    [defaults setInteger:0 forKey:@"runCount"];
    [defaults setBool:NO forKey:@"isLogin"];
    
    [defaults removeObjectForKey:@"phoneNumber"];
    [defaults removeObjectForKey:@"apiKey"];
    [defaults removeObjectForKey:@"avatar"];
    [defaults removeObjectForKey:@"personalizedSignature"];
    [defaults removeObjectForKey:@"heartbeatNumber"];
    [defaults removeObjectForKey:@"nickName"];
    [defaults removeObjectForKey:@"level"];
    [defaults removeObjectForKey:@"registerDate"];
    [defaults removeObjectForKey:@"userId"];
    [defaults removeObjectForKey:@"appSecret"];
    
    [defaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
