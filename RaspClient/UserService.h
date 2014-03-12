//
//  UserService.h
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface UserService : NSObject

+(AFHTTPRequestOperation *)checkUserLogin:(NSString *)userName with: (NSString *)password callback:(void (^)(NSDictionary *json))block;

+(AFHTTPRequestOperation *)registUser:(NSString *)userName with: (NSString *)password callback:(void (^)(NSDictionary *json))block;

@end
