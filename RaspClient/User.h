//
//  User.h
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong,nonatomic) NSNumber* userId;     //用户ID
@property (strong,nonatomic) NSString* nick;       //昵称
@property (strong,nonatomic) NSString* picture;    //头像（预留）
@property (strong,nonatomic) NSNumber* level;      //权限等级

@end
