//
//  User.h
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface User : JSONModel

@property (strong,nonatomic) NSNumber* id;     //用户ID
@property (strong,nonatomic) NSString* nick;       //昵称
@property (strong,nonatomic) NSString* picture;    //头像（预留）
@property (strong,nonatomic) NSNumber* level;      //权限等级

@end
