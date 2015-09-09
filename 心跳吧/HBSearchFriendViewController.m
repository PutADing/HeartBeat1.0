//
//  HBSearchFriendViewController.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/14.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBSearchFriendViewController.h"
#import "HBSearchFriendTableViewCell.h"
#import "HBMyHopeViewController.h"
#import "HBUser.h"
#import "HBTool.h"
#import "HBSearchFriendParser.h"

@interface HBSearchFriendViewController () <UITextFieldDelegate, UITextInputDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong)UIView* searchView;
@property (nonatomic, strong)UITextField* searchTF;
@property (nonatomic, strong)UIButton* searchBtn;
@property (nonatomic, strong)UILabel* searchLab;
@property (nonatomic, strong)UITableView* tableView;

@property (nonatomic, strong)NSMutableArray* tableArr;//存放NSDictionary类型的用户信息
@property (nonatomic, assign)int pageIndex;
@property (nonatomic, assign)int pageSize;

@end

@implementation HBSearchFriendViewController

//每行高度
#define LINE_HEIGHT 50
//照片距离左间距
#define SPACE_X 10
//照片宽高
#define WIDTH_IV 40

static NSString* identifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索好友";
    self.view.backgroundColor = COLOR_WHITE1;
    
    self.searchView = [self createSearchViewWithY:NAVIGATIOINBARHEIGHT AndHeight:LINE_HEIGHT*2];
    [self.view addSubview:self.searchView];
    
    self.tableView = [self createTableViewWithY:self.searchView.frame.origin.y + self.searchView.frame.size.height AndHeight:self.view.frame.size.height - self.searchView.frame.origin.y - self.searchView.frame.size.height];
    [self.view addSubview:self.tableView];
    
    self.tableArr = [NSMutableArray array];
    self.pageIndex = 0;
    self.pageSize = 10;
    
    [self.searchTF becomeFirstResponder];
}

-(UIView* )createSearchViewWithY:(CGFloat )origin_y AndHeight:(CGFloat )frame_height {
    UIView* vi = [[UIView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, frame_height)];
    UIImageView* searchIV = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_X, LINE_HEIGHT - WIDTH_IV, WIDTH_IV, WIDTH_IV)];
    searchIV.image = [UIImage imageNamed:@"HB_Search.png"];
    [vi addSubview:searchIV];
    //"心跳号/手机号"输入框
    self.searchTF = [[UITextField alloc]initWithFrame:CGRectMake(SPACE_X + searchIV.frame.size.width, searchIV.frame.origin.y + (WIDTH_IV - 30)/2, vi.frame.size.width - SPACE_X*3 - searchIV.frame.size.width, 30)];
    self.searchTF.placeholder = @"请输入心跳号/手机号";
    self.searchTF.font = FONT_17;
    self.searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTF.keyboardType = UIKeyboardTypeWebSearch;
    [self.searchTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.searchTF.inputDelegate = self;
    [vi addSubview:self.searchTF];
    //蓝色线条
    UIImageView* lineIV = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_X, searchIV.frame.origin.y + searchIV.frame.size.height, self.view.frame.size.width - SPACE_X*2, 2)];
    lineIV.image = [UIImage imageNamed:@"blueLine.png"];
    [vi insertSubview:lineIV belowSubview:self.searchTF];
    
    self.searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, LINE_HEIGHT, self.view.frame.size.width, LINE_HEIGHT)];
    [self.searchBtn addTarget:self action:@selector(clickedSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    self.searchBtn.hidden = YES;
    [vi addSubview:self.searchBtn];
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_X, (LINE_HEIGHT - WIDTH_IV)/2, WIDTH_IV, WIDTH_IV)];
    imageView.image = [UIImage imageNamed:@"search_1.png"];
    [self.searchBtn addSubview:imageView];
    self.searchLab = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width, (self.searchBtn.frame.size.height - 30)/2, self.searchBtn.frame.size.width - SPACE_X*2 - imageView.frame.size.width, 30)];
    self.searchLab.font = FONT_17;
    [self.searchBtn addSubview:self.searchLab];
    return vi;
}

-(UITableView* )createTableViewWithY:(CGFloat )origin_y AndHeight:(CGFloat )frame_height {
    UITableView* tv = [[UITableView alloc]initWithFrame:CGRectMake(0, origin_y, self.view.frame.size.width, frame_height) style:UITableViewStylePlain];
    tv.dataSource = self;
    tv.delegate = self;
    [tv registerClass:[HBSearchFriendTableViewCell class] forCellReuseIdentifier:identifier];
    return tv;
}

#pragma mark- UITextInputDelegate
- (void)selectionWillChange:(id <UITextInput>)textInput {
}
- (void)selectionDidChange:(id <UITextInput>)textInput {
}
- (void)textWillChange:(id <UITextInput>)textInput {
}
- (void)textDidChange:(id <UITextInput>)textInput {
    if (self.searchTF.text.length != 0) {
        self.searchLab.text = [NSString stringWithFormat:@"搜索“%@”", self.searchTF.text];
        self.searchBtn.hidden = NO;
    }else {
        self.searchBtn.hidden = YES;
        [self.tableArr removeAllObjects];
        [self.tableView reloadData];
    }
}

-(void)clickedSearchButton:(UIButton* )sender {
    if (sender == self.searchBtn) {
        self.pageIndex = 0;
        if (self.searchTF.text.length > 0) {
            [self getSearchFriendFromervice];
        }
    }
}

-(void)getSearchFriendFromervice {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", HBURL, @"rest/friends/findStranger.do"];
    NSString* argumentStr = [NSString stringWithFormat:@"condition=%@&pageIndex=%d&pageSize=%d&sortStyle=&siftCondition=&siftValue=&myId=%ld&apiKey=%@", self.searchTF.text, self.pageIndex, self.pageSize, USERID, APIKEY];
    [[HBTool shareTool]postURLConnectionWithURL:urlStr andArgument:argumentStr AndBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
//        NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"resultStr = %@", resultStr);
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"jsonDic = %@", jsonDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([jsonDic[@"status"]integerValue] == 1) {
                NSArray* userList = jsonDic[@"userList"];
                if (userList.count > 0) {
                    HBSearchFriendParser* parser = [[HBSearchFriendParser alloc]init];
                    [parser returnSearchFriendArrayWithArray:userList AndCallBack:^(NSMutableArray *userArr) {
                        if (self.pageIndex == 0) {
                            [self.tableArr removeAllObjects];
                        }
                        [self.tableArr addObjectsFromArray:userArr];
                        [self.tableView reloadData];
                    }];
                }
            }
            [self hideInfiniteScrolling];
        });
    }];
}

#pragma mark- UITableViewDataSource
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBSearchFriendTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[HBSearchFriendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    HBUser* user = self.tableArr[indexPath.row];
    
    if (![user.avatar isKindOfClass:[NSNull class]]) {
        if (![user.avatar isEqualToString:@"null  "] && ![user.avatar isEqualToString:@"null"]) {//@"null  "这是服务器的bug  要改
            NSURL* imageURL = [NSURL URLWithString:user.avatar];
            [cell.headIV sd_setImageWithURL:imageURL placeholderImage:DEFAULT_HEADIMAGE options:SDWebImageRetryFailed];
        }else {
            cell.headIV.image = DEFAULT_HEADIMAGE;
        }
    }else {
        cell.headIV.image = DEFAULT_HEADIMAGE;
    }
    
    cell.nickLab.text = user.nickName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    HBUser* tempUser = self.tableArr[indexPath.row];
    HBMyHopeViewController* HBMHVC = [[HBMyHopeViewController alloc]init];
    HBMHVC.user = tempUser;
    
    [self.navigationController pushViewController:HBMHVC animated:NO];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LINE_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + LINE_HEIGHT) {
        self.tableView.showsInfiniteScrolling = YES;
        
        if (self.tableArr.count >= self.pageSize*(self.pageIndex+1)) {
            self.pageIndex++;
            [self getSearchFriendFromervice];
        }
    }
}

-(void)hideInfiniteScrolling {
    [self.tableView.infiniteScrollingView stopAnimating];
    self.tableView.showsInfiniteScrolling = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
