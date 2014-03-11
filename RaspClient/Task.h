//
//  Task.h
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (strong, nonatomic) NSNumber* taskId;         //任务ID
@property (strong, nonatomic) NSNumber* switchId;       //开关ID
@property (strong, nonatomic) NSNumber* userId;         //用户ID
@property (strong, nonatomic) NSNumber* targetStatus;   //目标状态
@property (strong, nonatomic) NSString* ifExpression;   //操作条件表达式
@property (strong, nonatomic) NSNumber* result;         //#操作结果 0操作中，1成功，2失败

@end
