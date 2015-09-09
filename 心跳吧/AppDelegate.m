//
//  AppDelegate.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/2/2.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "HBNavigationController.h"
#import "HBShareViewController.h"
#import "HBLoginViewController.h"
#import "HBPayViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()
@property (nonatomic, copy)NSString* deviceToken;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:38.0f/255 green:58.0f/255 blue:74.0f/255 alpha:1.0f]];//导航栏的颜色
    [[UINavigationBar appearance] setTintColor:COLOR_BLUE1];//返回按钮的颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_WHITE1}];//标题字体 颜色等属性

//    设置根视图
    [self setRootViewController];
    
    
    
    //注册shareSDK
    [self registerShareSDK];
    
    //注册阿里云
    [self registerALiYunOSS];
    
    
    
    
    //注册个推
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    
    //[2]:注册APNS
    [self registerRemoteNotification];
    
//    如果 App 状态为未运行，此函数将被调用，如果launchOptions包含UIApplicationLaunchOptionsLocalNotificationKey表示用户点击apn 通知导致app被启动运行；如果不含有对应键值则表示 App 不是因点击apn而被启动，可能为直接点击icon被启动或其他
    // [2-EXT]: 获取启动时收到的APN
    
    NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (message) {
        NSLog(@"message=%@", message);
        
        NSString *payloadMsg = [message objectForKey:@"payload"];
        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
        NSLog(@"launchOptions.message:%@", record);
        
        [self setRedDotNumberWithPayloadMsg:payloadMsg];
        
    }
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
//    微信支付需注册APPID
    [WXApi registerApp:@"wxef10489ea8963163" withDescription:@"heartbeat"];
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)setRootViewController {
    
    
     //测试时 将打开应用次数清零
     NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
     NSInteger runCount = [defaults integerForKey:@"runCount"];
     runCount = 0;
     [defaults setInteger:runCount forKey:@"runCount"];
//         [defaults setBool:YES forKey:@"isLogin"];
     [defaults synchronize];
    
    
    //判断 打开应用次数 登录状态
    if ([self isFirstRunCount]) {//&& ![self isLoginIn]
        HBLoginViewController* loginVC = [[HBLoginViewController alloc]init];
        HBNavigationController* navi = [[HBNavigationController alloc]initWithRootViewController:loginVC];
        self.window.rootViewController = navi;
    }else if (![self isFirstRunCount] && [self isLoginIn]) {
        HBShareViewController* shareVC = [[HBShareViewController alloc]init];
        HBNavigationController* navi = [[HBNavigationController alloc]initWithRootViewController:shareVC];
        self.window.rootViewController = navi;
    }
    
}

-(BOOL )isFirstRunCount {
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"runCount"] > 0) {
        return NO;
    }else {
        return YES;
    }
}

-(BOOL )isLoginIn {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"isLogin"] == YES) {
        return YES;
    }else {
        return NO;
    }
}

-(void)registerShareSDK {
    //ShareSDK的AppKey
    [ShareSDK registerApp:@"64cb5b4bc310"];
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"1232104415" appSecret:@"846ac3205aa9baa0d09bb1648bf1b322" redirectUri:@"http://www.sharesdk.cn"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"1232104415" appSecret:@"846ac3205aa9baa0d09bb1648bf1b322" redirectUri:@"http://www.sharesdk.cn" weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1104131050"
                           appSecret:@"COOKuQFtDGMVI3Np"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:@"1104131050"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com 微信APPID  微信APPSecret
    [ShareSDK connectWeChatWithAppId:@"wxef10489ea8963163"
                           wechatCls:[WXApi class]];
    [ShareSDK connectWeChatWithAppId:@"wxef10489ea8963163" appSecret:@"7a062a681e1e66a3b61c28226621086a" wechatCls:[WXApi class]];
    
    //添加短信分享
//    [ShareSDK connectSMS];
}

//shareSDK回执
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url {
//    if ([[url scheme]isEqualToString:@"wxef10489ea8963163"]) {
//        return [WXApi handleOpenURL:url delegate:[HBPayViewController sharePayViewController]];
//    }else {
//        return [ShareSDK handleOpenURL:url
//                        wxDelegate:self];
//    }
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

//shareSDK回调 阿里支付回调 微信支付回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"url.scheme=%@", [url scheme]);
    
    if ([[url scheme]isEqualToString:@"heartbeat"]) {//阿里支付回调
        //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开发包
        if ([url.host isEqualToString:@"safepay"]) {
            
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {//当支付宝客户端在操作时,商户 app 进程在后台被结束,只能通过这个 block 输出支付结果。
                NSLog(@"safepay_result = %@",resultDic);
                
                NSDictionary* payInfoDic = resultDic[@"result"];
                NSInteger resultState = [resultDic[@"resultStatus"]integerValue];
                NSString* success = payInfoDic[@"success"];
                
                NSLog(@"resultState=%ld,success=%@", resultState, success);
                
                if (resultState == 9000) {//&& [success isEqualToString:@"true"]
                    [[HBPayViewController sharePayViewController] didSuccessfullyPay];
                }else {
                    [[HBPayViewController sharePayViewController] didFailPay];
                }
            }];
            
        }
        if ([url.host isEqualToString:@"platformapi"]) {//支付宝钱包快登授权返回 authCode
            
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"platformapi_result = %@",resultDic);
                
//                NSDictionary* payInfoDic = resultDic[@"result"];
//                NSInteger resultState = [resultDic[@"resultStatus"]integerValue];
//                NSString* success = payInfoDic[@"success"];
//                
//                NSLog(@"resultState=%ld,success=%@", resultState, success);
//                
//                if (resultState == 9000) {//&& [success isEqualToString:@"true"]
//                    [[HBPayViewController sharePayViewController] didSuccessfullyPay];
//                }else {
//                    [[HBPayViewController sharePayViewController] didFailPay];
//                }
                
            }];
        }
        return YES;
    }else if ([[url scheme]isEqualToString:@"wxef10489ea8963163"]) {//微信支付回调
        
        return [WXApi handleOpenURL:url delegate:[HBPayViewController sharePayViewController]];
        
    }else {//shareSDK回调
        return [ShareSDK handleOpenURL:url
                     sourceApplication:sourceApplication
                            annotation:annotation
                            wxDelegate:self];
    }
}

//注册阿里云OSS
-(void)registerALiYunOSS {
    id<ALBBOSSServiceProtocol> ossService = [ALBBOSSServiceProvider getService];
    //    阿里云OSS使用继承自OOSClient默认的加签方式
    [ossService setGenerateToken:^(NSString *method, NSString *md5, NSString *type, NSString *date, NSString *xoss, NSString *resource) {
        NSString *signature = nil;
        NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@", method, md5, type, date, xoss, resource];
        signature = [OSSTool calBase64Sha1WithData:content withKey:ALIYUNOSS_SECRETKEY];
        signature = [NSString stringWithFormat:@"OSS %@:%@", ALIYUNOSS_ACCESSKEY, signature];
        
        NSLog(@"signature:%@", signature);
        return signature;
    }];
    [ossService setGlobalDefaultBucketHostId:ALIYUNOSS_HOSTID];
}




- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret {
    if (!self.gexinPusher) {
        self.sdkStatus = SdkStatusStoped;
        
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;
        
        self.clientId = nil;
        
        NSError *err = nil;
        self.gexinPusher = [GexinSdk createSdkWithAppId:self.appID
                                                 appKey:self.appKey
                                              appSecret:self.appSecret
                                             appVersion:@"0.0.0"
                                               delegate:self
                                                  error:&err];
        if (!self.gexinPusher) {
            NSLog(@"GexinSdk createSdkWithAppIdFaildWithError:%@", err.localizedDescription);
        } else {
            self.sdkStatus = SdkStatusStarting;
        }
        
    }
}

//注册APNS
- (void)registerRemoteNotification
{
#ifdef __IPHONE_8_0
    // IOS8 新的注册api
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
        
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}

//执行完registerRemoteNotification这个方法后，若注册成功会调用该方法
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    self.deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"token=%@,self.deviceToken=%@", token, self.deviceToken);
 
    // [3]:向个推服务器注册deviceToken
    if (self.gexinPusher) {
        [self.gexinPusher registerDeviceToken:self.deviceToken];
    }
}

//执行完registerRemoteNotification这个方法后，若注册失败会调用该方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    if (self.gexinPusher) {
        [self.gexinPusher registerDeviceToken:@""];
    }
    
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@", [error localizedDescription]);
}

//如果App状态为正在前台或者后台运行，那么此函数将被调用，并且可通过AppDelegate的applicationState是否为UIApplicationStateActive判断程序是否在前台运行。此种情况在此函数中处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // [4-EXT]:处理APN
    NSLog(@"正在运行时收到推送userinfo:%@", userinfo);
    
    NSString *payloadMsg = [userinfo objectForKey:@"payload"];
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [self setRedDotNumberWithPayloadMsg:payloadMsg];
    
    NSLog(@"正在运行时收到推送record:%@", record);
}

//如果是使用 iOS 7 的 Remote Notification 特性那么处理函数需要使用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // [4-EXT]:处理APN
    NSLog(@"正在后台运行时收到推送userinfo:%@", userInfo);
    
    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSNumber *contentAvailable = aps == nil ? nil : [aps objectForKeyedSubscript:@"content-available"];
    
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@, [content-available: %@]", [NSDate date], payloadMsg, contentAvailable];
    
    
    [self setRedDotNumberWithPayloadMsg:payloadMsg];
    
    
    NSLog(@"正在后台运行时接收到推送：%@,contentAvailable:%@", record, contentAvailable);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

//停止个推
- (void)stopSdk {
    if (self.gexinPusher) {
        [self.gexinPusher destroy];
        self.gexinPusher = nil;
        self.sdkStatus = SdkStatusStoped;
        self.clientId = nil;
    }
}

//检查个推状态
- (BOOL)checkSdkInstance {
    if (!self.gexinPusher) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"SDK未启动" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return NO;
    }
    return YES;
}

//设置deviceToken
- (void)setDeviceToken:(NSString *)aToken
{
    if (![self checkSdkInstance]) {
        return;
    }
    [self.gexinPusher registerDeviceToken:aToken];
}

//设置tag值
- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error
{
    if (![self checkSdkInstance]) {
        return NO;
    }
    
    return [self.gexinPusher setTags:aTags];
}

//绑定用户别名
- (void)bindAlias:(NSString *)aAlias {
    if (![self checkSdkInstance]) {
        return;
    }
    return [self.gexinPusher bindAlias:aAlias];
}

//解绑用户别名
- (void)unbindAlias:(NSString *)aAlias {
    if (![self checkSdkInstance]) {
        return;
    }
    return [self.gexinPusher unbindAlias:aAlias];
}

-(void)testGetClientId {
    NSString *clientId = [_gexinPusher clientId];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"当前的CID" message:clientId delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}
-(void)testSdkFunction {
}
-(NSString *)sendMessage:(NSData *)body error:(NSError *__autoreleasing *)error {
    return nil;
}

#pragma mark - GexinSdkDelegate
//个推已注册
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    self.sdkStatus = SdkStatusStarted;
    NSLog(@"个推SDK已注册");
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:clientId forKey:@"clientId"];
    [defaults synchronize];
    
}

//收到个推消息    （数据线连接测试时，接收到个推消息 调用此方法）
- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{
    // [4]: 收到个推消息
    NSData *payload = [self.gexinPusher retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
//    payloadMsg就是服务器推送过来的关键字
        
        [self setRedDotNumberWithPayloadMsg:payloadMsg];
        
    }
    NSString *record = [NSString stringWithFormat:@"%d, %@, %@", ++self.lastPayloadIndex, [NSDate date], payloadMsg];

    
    NSLog(@"收到个推消息：%@", record);
}

//个推发送消息结果反馈
- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    NSLog(@"发送上行消息结果反馈:%@", record);
}

//个推错误报告
- (void)GexinSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@">>>[GexinSdk error]:%@", [error localizedDescription]);
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
#warning Remember To Add...
    // [EXT] 切后台关闭SDK，让SDK第一时间断线，让个推先用APN推送
    [self stopSdk];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
#warning Remember To Add...
    // [EXT] 重新上线
    [self startSdkWith:_appID appKey:_appKey appSecret:_appSecret];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)setRedDotNumberWithPayloadMsg:(NSString* )payloadMsg {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([payloadMsg isEqualToString:@"REMIND_DOTNEW_FRIEND"]) {//新的朋友 推送
        
        [defaults setInteger:1 forKey:@"contactsRedDot"];
        [defaults setInteger:1 forKey:@"newFriends"];
        
    }else if ([payloadMsg isEqualToString:@"send"]) {//发件 推送
        
        [defaults setInteger:1 forKey:@"shareRedDot"];
        [defaults setInteger:1 forKey:@"songRedDot"];
        
    }else if ([payloadMsg isEqualToString:@"receive"]) {//收件 推送
        
        [defaults setInteger:1 forKey:@"shareRedDot"];
        [defaults setInteger:1 forKey:@"shouRedDot"];
        
    }
    
    [defaults synchronize];
}

@end
