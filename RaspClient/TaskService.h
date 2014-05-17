//
//  TaskService.h
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface TaskService : NSObject

+(AFHTTPRequestOperation *)getTask:(NSNumber *)page callback:(void (^)(NSDictionary *json))block;

+(AFHTTPRequestOperation *)addTask:(NSString *)expression id:(NSNumber*)switch_id status:(NSNumber*)status callback:(void (^)(NSDictionary *))block;

@end
