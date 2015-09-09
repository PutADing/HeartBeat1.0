//
//  HBContactModel.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/19.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBContactModel.h"
#import "ChineseString.h"
#import "pinyin.h"

@interface HBContactModel()

@end

@implementation HBContactModel

+(id)createContactModel {
    return [[HBContactModel alloc]init];
}

-(void )returnUserArrayWithDataDictionary:(NSDictionary *)contactsDic AndBlock:(void (^)(NSMutableArray *))block {
    NSMutableArray* usersArray = [NSMutableArray array];
    NSArray* userList = contactsDic[@"userList"];
    for (NSDictionary* userDic in userList) {
        HBUser* user = [[HBUser alloc]init];
        if ([userDic[@"avatar"] isKindOfClass:[NSNull class]]) {
            
        }else {
            user.avatar = userDic[@"avatar"];
        }
        if ([userDic[@"personalizedSignature"] isKindOfClass:[NSNull class]]) {
            
        }else {
            user.personalizedSignature = userDic[@"personalizedSignature"];
        }
        
//        NSLog(@"avatar=%@,personalSign=%@", user.avatar, user.personalizedSignature);
        
        user.level = [userDic[@"level"]integerValue];
        user.phoneNumber = userDic[@"phoneNumber"];
        user.nickName = userDic[@"nickName"];
        user.registerData = userDic[@"registerDate"];
        user.userID = [userDic[@"userId"]integerValue];
        user.gender = userDic[@"gender"];
        user.heartBeatNumber = userDic[@"heartbeatNumber"];
        
        [usersArray addObject:user];
    }
    block(usersArray);
}
/*
 resultStr={"status":1,"userList":[{"personalizedSignature":"坚持就是胜利","level":1,"phoneNumber":"18561369513","nickName":"安嘉","registerDate":1426210993000,"userId":1,"gender":"男","avatar":"http://heartbeat-avatar.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150313094406_1.jpg","heartbeatNumber":"277166603"},{"personalizedSignature":"莫白空","level":1,"phoneNumber":"15574866664","nickName":"tenchael","registerDate":1427541456000,"userId":8,"gender":"男","avatar":"http://heartbeat-avatar.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150419184556_8.png","heartbeatNumber":"tenchael"},{"personalizedSignature":null,"level":1,"phoneNumber":"18512345678","nickName":"duwan","registerDate":1429445404000,"userId":26,"gender":"男","avatar":"http://heartbeat-avatar.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150419201022_26.jpg","heartbeatNumber":"27064543529"},{"personalizedSignature":"stay hungry ","level":1,"phoneNumber":"18512345677","nickName":"jiang ","registerDate":1429445684000,"userId":27,"gender":"男","avatar":"http://heartbeat-avatar.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150419201522_27.jpg","heartbeatNumber":"12780430198"},{"personalizedSignature":"我是大侠","level":1,"phoneNumber":"18512345679","nickName":"聂","registerDate":1429446840000,"userId":28,"gender":"男","avatar":"http://heartbeat-avatar.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150419203426_28.jpg","heartbeatNumber":"47700715163"},{"personalizedSignature":"调试","level":1,"phoneNumber":"18512345670","nickName":"安嘉","registerDate":1429521557000,"userId":29,"gender":"女","avatar":"http://heartbeat-avatar.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150420171935_29.jpg","heartbeatNumber":"37103028024"},{"personalizedSignature":"大喊大叫","level":1,"phoneNumber":"18512345676","nickName":"ABC","registerDate":1429521902000,"userId":30,"gender":"女","avatar":"http://heartbeat-avatar.oss-cn-hangzhou.aliyuncs.com/HeartBeat_20150420172601_30.jpeg","heartbeatNumber":"41853147399"}],"msg":"查找成功"}
 */

-(void )returnSectionTitleArrayWithTableViewDataArray:(NSArray *)dataArray AndBlock:(void (^)(NSMutableArray *, NSMutableArray *))block {
    NSMutableArray* sortedArray = [NSMutableArray array];
    NSMutableArray* sectionTitleArr = [NSMutableArray array];
    NSMutableArray* chineseStringsArray = [NSMutableArray array];
    
    for (int i = 0; i < dataArray.count; i++) {
        HBUser* user = dataArray[i];
        
        ChineseString *chineseString=[[ChineseString alloc]init];
        chineseString.string=[NSString stringWithString:user.nickName];
        chineseString.tag = i;
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        if(![chineseString.string isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                NSString* singlePinyinLetter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    BOOL checkValueAtIndex = NO;  //flag to check
    NSMutableArray* TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString* chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString* strchar = [NSMutableString stringWithString:chineseStr.pinYin];
        NSString* sr = [strchar substringToIndex:1];
//        NSLog(@"%@",sr);//sr containing here the first character of each string
        
//here I'm checking whether the character already in the selection header keys or not
        if(![sectionTitleArr containsObject:[sr uppercaseString]]) {
            [sectionTitleArr addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
            checkValueAtIndex = NO;
        }
        if([sectionTitleArr containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[dataArray objectAtIndex:chineseStr.tag]];
            if(checkValueAtIndex == NO)
            {
                [sortedArray addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    
    block(sortedArray, sectionTitleArr);
}



static NSString* keyName = @"contacts";

//将联系人数据保存在沙盒中
-(void)saveContactsArray:(NSArray* )array WithPageSize:(NSInteger )pageSize AndPageIndex:(NSInteger )pageIndex {
    NSString* fileName = [NSString stringWithFormat:@"contacts-%ld-%ld", pageSize, pageIndex];
    NSMutableData* data = [NSMutableData data];
    NSKeyedArchiver* arch = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [arch encodeObject:array forKey:keyName];
    [arch finishEncoding];
    NSString* filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", fileName];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {//若该文件已经存在，则先删除该文件
        [manager removeItemAtPath:filePath error:nil];
    }
    
    [data writeToFile:filePath atomically:YES];
}

//从沙盒获取联系人数据
-(NSArray* )getContactsArrayWithPageSize:(NSInteger )pageSize AndPageIndex:(NSInteger )pageIndex {
    NSString* fileName = [NSString stringWithFormat:@"contacts-%ld-%ld", pageSize, pageIndex];
    NSString* filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", fileName];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver* unArch = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSArray* array = [unArch decodeObjectForKey:keyName];
    [unArch finishDecoding];
    
    
    return array;
}

@end
