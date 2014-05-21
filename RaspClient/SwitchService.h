//
//  SwitchService.h
//  RaspClient
//
//  Created by ShiningChan on 14-3-11.
//  Copyright (c) 2014年 ShiningChan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface SwitchService : NSObject

+(AFHTTPRequestOperation *)getSwitch:(NSNumber *)page callback:(void (^)(NSDictionary *json))block;

+(AFHTTPRequestOperation *)changeSwitch:(NSNumber *)switchId callback:(void (^)(NSDictionary *json))block;

@end
