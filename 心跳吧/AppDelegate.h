//
//  AppDelegate.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/2/2.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GexinSdk.h"
#import "ALBBOSSServiceProtocol.h"
#import "ALBBOSSServiceProvider.h"
#import "OSSTool.h"

typedef enum {
    SdkStatusStoped,
    SdkStatusStarting,
    SdkStatusStarted
} SdkStatus;

@interface AppDelegate : UIResponder <UIApplicationDelegate, GexinSdkDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GexinSdk *gexinPusher;

@property (copy, nonatomic) NSString *appKey;
@property (copy, nonatomic) NSString *appSecret;
@property (copy, nonatomic) NSString *appID;
@property (copy, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;

@property (assign, nonatomic) int lastPayloadIndex;
@property (copy, nonatomic) NSString *payloadId;

-(BOOL )isFirstRunCount;//程序是否是第一次运行

-(void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret;
- (void)stopSdk;

- (void)setDeviceToken:(NSString *)aToken;
- (BOOL)setTags:(NSArray *)aTag error:(NSError **)error;
- (NSString *)sendMessage:(NSData *)body error:(NSError **)error;

- (void)bindAlias:(NSString *)aAlias;
- (void)unbindAlias:(NSString *)aAlias;

- (void)testSdkFunction;
//- (void)testSendMessage;
- (void)testGetClientId;

@end

