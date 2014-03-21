//
//  Task.h
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface Task : JSONModel

@property (strong, nonatomic) NSNumber* id;         //任务ID
@property (strong, nonatomic) NSNumber* switch_id;       //开关ID
@property (strong, nonatomic) NSNumber* user_id;         //用户ID
@property (strong, nonatomic) NSNumber* target_status;   //目标状态
@property (strong, nonatomic) NSString* if_expression;   //操作条件表达式
@property (strong, nonatomic) NSNumber* result;         //#操作结果 0操作中，1成功，2失败

@end
