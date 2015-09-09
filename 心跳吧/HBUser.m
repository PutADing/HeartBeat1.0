//
//  HBUser.m
//  HeartBeat1.0
//
//  Created by 蒋宽 on 15/3/25.
//  Copyright (c) 2015年 蒋宽. All rights reserved.
//

#import "HBUser.h"

@implementation HBUser

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeInteger:self.level forKey:@"level"];
    [encoder encodeInteger:self.userID forKey:@"userID"];
    [encoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [encoder encodeObject:self.nickName forKey:@"nickName"];
    [encoder encodeObject:self.registerData forKey:@"registerData"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.avatar forKey:@"avatar"];
    [encoder encodeObject:self.heartBeatNumber forKey:@"heartBeatNumber"];
    
    [encoder encodeObject:self.headImage forKey:@"headImage"];
    [encoder encodeObject:self.apiKey forKey:@"apiKey"];
    [encoder encodeObject:self.appToken forKey:@"appToken"];

}

-(id)initWithCoder:(NSCoder *)decoder{
    self.level = [decoder decodeIntegerForKey:@"level"];
    
    self.userID = [decoder decodeIntegerForKey:@"userID"];
    self.phoneNumber = [decoder decodeObjectForKey:@"phoneNumber"];
    self.nickName = [decoder decodeObjectForKey:@"nickName"];
    self.registerData = [decoder decodeObjectForKey:@"registerData"];
    self.gender = [decoder decodeObjectForKey:@"gender"];
    self.avatar = [decoder decodeObjectForKey:@"avatar"];
    self.heartBeatNumber = [decoder decodeObjectForKey:@"heartBeatNumber"];
    
    self.headImage = [decoder decodeObjectForKey:@"headImage"];
    self.apiKey = [decoder decodeObjectForKey:@"apiKey"];
    self.appToken = [decoder decodeObjectForKey:@"appToken"];
    
    return self;
}

@end
