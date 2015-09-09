//
//  HBTool.m
//  HBDemoVersion
//
//  Created by okwei on 14-11-4.
//  Copyright (c) 2014年 heartbeat. All rights reserved.
//

#import "HBTool.h"

@implementation HBTool

static HBTool *tool;

+(instancetype)shareTool{
    if (!tool) {
        tool = [[HBTool alloc] init];
    }
    return tool;
}

-(BOOL)isIOS7_Later{
    return [[UIDevice currentDevice].systemVersion floatValue] >= 7.0;
}

-(BOOL)isIOS8_Later{
    return [[UIDevice currentDevice].systemVersion floatValue] >= 8.0;
}

-(NSString *)currentTimeStamp {
    NSDate* date = [NSDate date];
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    //时间模板 YYYYMMddHHmmss
    df.dateFormat = @"YYYYMMddHHmmss";
    //通过时间模板对象 转换当前时间
    NSString* nowDate = [df stringFromDate:date];
    
    return nowDate;
}

-(NSString *)currentTimeWithTimeStamp:(NSTimeInterval )timeStamp {
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    //时间模板 YYYYMMddHHmmss
    df.dateFormat = @"M-dd HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp/1000.0];
    NSString* nowTime = [df stringFromDate:date];
    return nowTime;
}

-(void)postURLConnectionWithURL:(NSString* )urlStr andArgument:(NSString* )argumentStr AndBlock:(void (^)(NSURLResponse* response, NSData* data, NSError* error)) block {
    
    if (self.reach.isReachable) {//若网络连接正常 则发送网络请求
        
        NSURL* url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:20];
        NSData* postData = [argumentStr dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        
        //创建一个新的队列（开启新线程）
        NSOperationQueue* queue = [NSOperationQueue new];
        //发送异步请求，请求完以后返回的数据，通过completionHandler参数来调用
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:block];
    }else {
        
    }
}


-(void)postWithURL:(NSString *)urlStr andArgument:(NSString *)argumentStr AndBlock:(void (^)(NSDictionary *))block {
    NSURL* url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20];
    NSData* postData = [argumentStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    //创建一个新的队列（开启新线程）
    NSOperationQueue* queue = [NSOperationQueue new];
    //发送异步请求，请求完以后返回的数据，通过completionHandler参数来调用
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSDictionary* jsonDic;
                               if (data == nil || data.length == 0) {
                                   NSLog(@"connectionError=%@", [connectionError localizedDescription]);
                               }else {
                                   NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"resultStr=%@", resultStr);
                                   jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   NSLog(@"jsonDic=%@", jsonDic);
                               }
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   block(jsonDic);
                               });
                           }];
}


-(void)postURLSessionWithURL:(NSString* )urlStr andArgument:(NSString* )argumentStr AndCallBack:(CallBack)callback {
    
    if (self.reach.isReachable) {//若网络连接正常 则发送网络请求
        
        NSURL* url = [NSURL URLWithString:urlStr];
        NSData* postData = [argumentStr dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
            NSString* resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"resultStr=%@", resultStr);
            
            NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
            NSLog(@"jsonDic=%@", jsonDic);
            
            callback(jsonDic);
            
        }];
        //开始请求
        [task resume];
    }
}
/*
 Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
 
 // Set the blocks
 reach.reachableBlock = ^(Reachability*reach)
 {
 // keep in mind this is called on a background thread
 // and if you are updating the UI it needs to happen
 // on the main thread, like this:
 
 dispatch_async(dispatch_get_main_queue(), ^{
 NSLog(@"REACHABLE!");
 });
 };
 
 reach.unreachableBlock = ^(Reachability*reach)
 {
 NSLog(@"UNREACHABLE!");
 };
 
 // Start the notifier, which will cause the reachability object to retain itself!
 [reach startNotifier];
 
 [reachability stopNotifier];
 */

-(HBReachability *)getHBReachability {
    HBReachability* toolReach = [HBReachability reachabilityWithHostname:@"www.baidu.com"];
    return toolReach;
}

-(void)saveArray:(NSArray *)array AndKey:(NSString *)keyName AndFileName:(NSString *)fileName {
    NSMutableData* data = [NSMutableData data];
    NSKeyedArchiver* arch = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [arch encodeObject:array forKey:keyName];
    [arch finishEncoding];
    NSString* filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", fileName];
    [data writeToFile:filePath atomically:YES];
}

-(NSArray *)getArrayWithKeyName:(NSString *)keyName AndFileName:(NSString *)fileName {
    NSString* filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", fileName];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver* unArch = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSArray* array = [unArch decodeObjectForKey:keyName];
    return array;
}

@end
