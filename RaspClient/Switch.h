//
//  Switch.h
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Switch : NSObject

@property (strong, nonatomic) NSNumber* switchId;   //开关ID
@property (strong, nonatomic) NSString* name;       //开关名称
@property (strong, nonatomic) NSNumber* status;     //开关当前状态
@property (strong, nonatomic) NSNumber* level;      //最小可操作等级

@end
