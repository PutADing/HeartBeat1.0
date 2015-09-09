//
//  ChineseString.h
//  ChineseSort
//
//  Created by Bill on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChineseString : NSObject

@property(nonatomic, copy)NSString *string;
@property(nonatomic, copy)NSString *pinYin;
@property(nonatomic, assign)NSInteger tag;//类似userID，作为标识用以区分nickName相同的用户

@end
