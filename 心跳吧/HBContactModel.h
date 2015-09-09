//
//  HBContactModel.h
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/4/19.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBUser.h"

@interface HBContactModel : NSObject

+(id)createContactModel;

-(void )returnUserArrayWithDataDictionary:(NSDictionary* )contactsDic AndBlock:(void (^)(NSMutableArray* usersArray))block;

-(void )returnSectionTitleArrayWithTableViewDataArray:(NSArray* )dataArray AndBlock:(void (^)(NSMutableArray* sortedArray, NSMutableArray* sectionTitleArray))block;


//将联系人数据保存在沙盒中
-(void)saveContactsArray:(NSArray* )array WithPageSize:(NSInteger )pageSize AndPageIndex:(NSInteger )pageIndex;

//从沙盒获取联系人数据
-(NSArray* )getContactsArrayWithPageSize:(NSInteger )pageSize AndPageIndex:(NSInteger )pageIndex;

@end
